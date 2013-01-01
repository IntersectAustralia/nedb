class AddLabelFlagToItemTypes < ActiveRecord::Migration
  def self.up
    add_column :item_types, :create_labels, :boolean
  end

  def self.down
    remove_column :item_types, :create_labels
  end
end
