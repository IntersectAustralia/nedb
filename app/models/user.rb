class User < ActiveRecord::Base
  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable, :timeoutable

  belongs_to :profile
  has_many :specimen_images

  # Setup accessible attributes for your model
  attr_accessible :email, :password, :password_confirmation, :title, :first_name, :last_name, :other_initials, :position, :supervisor, :group_school_institution, :address, :telephone
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  
  with_options :if => :password_required? do |v|
    v.validates :password, :password_format => true
  end
  
  validates :status, :presence => true

  scope :pending_approval, where(:status => 'U').order(:email)
  scope :approved, where(:status => 'A').order(:email)
  scope :deactivated_or_approved, where("status = 'D' or status = 'A' ").order(:email)

  # Override Devise active method so that users must be approved before being allowed to log in
  def active?
    super && approved?
  end
  
  # Overrride Devise method so we can check if account is active before allowing them to get a password reset email
  def send_reset_password_instructions
    if approved?
      generate_reset_password_token!
      ::Devise.mailer.reset_password_instructions(self).deliver
    else
      errors.add(:base, "Your account is not active.")
    end
  end

  # Custom method overriding update_with_password so that we always require a password on the update password action
  # Devise expects the update user and update password to be the same screen so accepts a blank password as indicating that 
  # the user doesn't want to change it 
  def update_password(params={})
    current_password = params.delete(:current_password)
  
    result = if valid_password?(current_password)
      update_attributes(params)
    else
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      self.attributes = params
      false
    end
  
    clean_up_passwords
    result
  end
  
  def approved?
    self.status == 'A'
  end
  
  def pending_approval?
    self.status == 'U'
  end

  def deactivated?
    self.status == 'D'
  end
  
  def deactivate
    self.status = 'D'
    save!(:validate => false)
  end

  def activate
    self.status = 'A'
    save!(:validate => false)
  end

  def approve_access_request
    self.status = 'A'
    save!(:validate => false)

    # send an email to the user
    Notifier.notify_user_of_approved_request(self).deliver
  end

  def reject_access_request
    self.status = 'R'
    save!(:validate => false)

    # send an email to the user
    Notifier.notify_user_of_rejected_request(self).deliver
  end

  def notify_admin_by_email
    Notifier.notify_superusers_of_access_request(self).deliver
  end
 
  def submit_feedback(feedback)
    Notifier.notify_superusers_of_user_feedback(self, feedback).deliver
  end

end
