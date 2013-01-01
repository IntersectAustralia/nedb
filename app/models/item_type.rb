class ItemType < ActiveRecord::Base

  TYPE_SPECIMEN_SHEET = "Specimen sheet"
  
  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
  #validates :create_labels, :presence => true
  
  default_scope order(:name)
  
end
