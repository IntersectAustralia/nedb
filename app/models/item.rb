class Item < ActiveRecord::Base
  
  belongs_to :specimen, :touch => true
  belongs_to :item_type
  
  validates :specimen, :presence => true
  validates :item_type, :presence => true
  
  scope :ordered_by_type_name, includes(:item_type).order("item_types.name")

  # note the syntax is to make this cross-database compatible due to different databases storing booleans differently
  scope :requiring_labels, includes(:item_type).where(['item_types.create_labels = ?', true]).order('items.id')

end
