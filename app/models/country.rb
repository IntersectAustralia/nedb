class Country < ActiveRecord::Base
  
  has_many :states
  validates :name, :presence => true
  
  def self.alpha_order_with_australia_first
    countries = order(:name)
    aust = countries.find { |country| country.is_australia? }
    others = countries.delete_if { |country| country.is_australia? }
    [aust] + others
  end
  
  def self.find_australia
    where(:name => "Australia").first
  end
  
  def is_australia?
    self.name.upcase == "AUSTRALIA"
  end
end
