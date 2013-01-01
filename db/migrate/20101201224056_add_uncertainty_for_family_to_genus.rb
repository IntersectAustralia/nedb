class AddUncertaintyForFamilyToGenus < ActiveRecord::Migration
  def self.up
    add_column :determinations, :family_uncertainty, :string
    add_column :determinations, :sub_family_uncertainty, :string
    add_column :determinations, :tribe_uncertainty, :string
    add_column :determinations, :genus_uncertainty, :string
  end

  def self.down
    remove_column :determinations, :family_uncertainty
    remove_column :determinations, :sub_family_uncertainty
    remove_column :determinations, :tribe_uncertainty
    remove_column :determinations, :genus_uncertainty
  end
end
