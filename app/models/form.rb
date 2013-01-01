class Form < ActiveRecord::Base
  belongs_to :species

  validates :form, :presence => true, :uniqueness => {:scope => :species_id}
  validates :authority, :presence => true
  validates_length_of :form, :maximum => 255
  validates_length_of :authority, :maximum => 255

  default_scope order(:form)

  # correct the case before validating
  before_validation do
    self.form = form.downcase if attribute_present?("form")
  end

  def display_name
    "#{form} - #{authority}"
  end

end
