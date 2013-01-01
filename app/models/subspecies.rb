class Subspecies < ActiveRecord::Base
  belongs_to :species

  validates :subspecies, :presence => true, :uniqueness => {:scope => :species_id}
  validates :authority, :presence => true
  validates_length_of :subspecies, :maximum => 255
  validates_length_of :authority, :maximum => 255 

  default_scope order(:subspecies)

  # correct the case before validating
  before_validation do
    self.subspecies = subspecies.downcase if attribute_present?("subspecies")
  end

  def display_name
    "#{subspecies} - #{authority}"
  end
end
