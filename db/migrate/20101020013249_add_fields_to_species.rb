class AddFieldsToSpecies < ActiveRecord::Migration
  def self.up
    add_column :species, :division, :string
    add_column :species, :class_name, :string
    add_column :species, :order_name, :string
    add_column :species, :family, :string
    add_column :species, :sub_family, :string
    add_column :species, :tribe, :string
    add_column :species, :genus, :string
    add_column :species, :authority, :string
  end

  def self.down
    remove_column :species, :authority
    remove_column :species, :genus
    remove_column :species, :tribe
    remove_column :species, :sub_family
    remove_column :species, :family
    remove_column :species, :order_name
    remove_column :species, :class_name
    remove_column :species, :division
  end
end
