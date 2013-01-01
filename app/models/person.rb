class Person < ActiveRecord::Base

  before_validation :compare_dates, :strip_fields

  belongs_to :herbarium

  has_many :specimens, :foreign_key => 'collector_id', :dependent => :restrict

  has_many :confirmations, :foreign_key => 'confirmer_id', :dependent => :restrict

  has_many :determination_determiners, :foreign_key => 'determiner_id', :dependent => :restrict
  has_many :determinations, :through => :determination_determiners, :dependent => :restrict

  has_many :specimen_secondary_collectors, :foreign_key => 'collector_id', :dependent => :restrict
  has_many :secondary_specimens, :through => :specimen_secondary_collectors, :source => :specimen, :dependent => :restrict

  validates :last_name, :presence => true
  validates :initials, :presence => true, :uniqueness => {:case_sensitive => false, :scope => :last_name}

  validates_length_of :first_name, :maximum => 255
  validates_length_of :initials, :maximum => 20
  validates_length_of :last_name, :maximum => 255
  validates_length_of :address, :maximum => 255
  validates_length_of :email, :maximum => 255
  validates_length_of :middle_name, :maximum => 255

  validates :date_of_birth_day, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 31}
  validates :date_of_birth_month, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 12}
  validates :date_of_birth_year, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 9999}
  validates :date_of_death_day, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 31}
  validates :date_of_death_month, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 12}
  validates :date_of_death_year, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 9999}

  validates_with DateValidator, :field_name => 'Date of birth', :fields => {:year => :date_of_birth_year, :month => :date_of_birth_month, :day => :date_of_birth_day}
  validates_with DateValidator, :field_name => 'Date of death', :fields => {:year => :date_of_death_year, :month => :date_of_death_month, :day => :date_of_death_day}

  default_scope order('last_name, first_name', 'middle_name')

  def display_name
    "#{initials} #{last_name}"
  end

  def create_initials
    form_initials(self.first_name, self.middle_name)
  end

  def update_initials(first_name, middle_name)
    form_initials(first_name, middle_name)
  end

  private

  def form_initials(first_name, middle_name)
    initial = "#{first_name[0,1].to_s.capitalize}."
    if middle_name.nil? || middle_name.empty?
      initial
    else
      initial.concat "#{middle_name[0,1].to_s.capitalize}."
    end
  end

  def strip_fields
    initials.strip! unless initials.blank?
    last_name.strip! unless last_name.blank?
    first_name.strip! unless first_name.blank?
  end


  def compare_dates
    if date_of_birth == 0 and date_of_death != 0
      errors.add(:base, 'You cannot have a date of death without a date of birth')
    elsif date_of_birth != 0 and date_of_death != 0 and date_of_birth > date_of_death
      errors.add(:base, 'Date of death cannot precede the date of birth')
    end
  end

  def date_of_birth
    date_string = "%d%02d%02d" % [date_of_birth_year || 0, date_of_birth_month || 0, date_of_birth_day || 0]
    date_string.to_i
  end

  def date_of_death
    date_string = "%d%02d%02d" % [date_of_death_year || 0, date_of_death_month || 0, date_of_death_day || 0]
    date_string.to_i
  end

end
