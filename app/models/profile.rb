class Profile < ActiveRecord::Base

  has_and_belongs_to_many :permissions, :join_table => 'profiles_permissions'
  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
  has_many :users 
  scope :by_name, order('name')
  
  def has_permission(entity, action)
    permissions.each do |perm|
      if perm.entity == entity && perm.action == action
        return true
      end
    end
    false
  end

  def self.get_superuser_emails
    find_by_name('Superuser').users.approved.collect {|u| u.email}
  end
  
end
