class Variety < ActiveRecord::Base
  belongs_to :species

  validates :variety, :presence => true, :uniqueness => {:scope => :species_id}
  validates :authority, :presence => true
  validates_length_of :variety, :maximum => 255
  validates_length_of :authority, :maximum => 255

  default_scope order(:variety)

  # correct the case before validating
  before_validation do
    self.variety = variety.downcase if attribute_present?("variety")
  end

  def display_name
    "#{variety} - #{authority}"
  end
end
