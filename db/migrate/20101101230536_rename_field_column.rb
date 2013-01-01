class RenameFieldColumn < ActiveRecord::Migration
  def self.up
    rename_column :uncertainties, :field, :uncertainty_field
  end

  def self.down
    rename_column :uncertainties, :uncertainty_field, :field
  end
end
