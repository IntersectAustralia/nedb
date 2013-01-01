class Confirmation < ActiveRecord::Base

  belongs_to :specimen
  belongs_to :determination
  belongs_to :confirmer, :class_name => 'Person'
  belongs_to :confirmer_herbarium, :class_name => 'Herbarium'
  
  validates :specimen, :presence => true
  validates :confirmer, :presence => true
  validates :determination, :presence => true
  validates :confirmation_date_day, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 31}
  validates :confirmation_date_month, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 12}
  validates :confirmation_date_year, :numericality => {:only_integer => true, :allow_nil => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 9999}
  
  validates_with DateValidator, :legacy_data => :legacy, :field_name => 'Confirmation date', :fields =>  {:year => :confirmation_date_year, :month => :confirmation_date_month, :day => :confirmation_date_day}

end
