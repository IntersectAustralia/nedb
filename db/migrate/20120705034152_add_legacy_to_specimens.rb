class AddLegacyToSpecimens < ActiveRecord::Migration
  def self.up
    add_column :specimens, :legacy, :boolean
  end

  def self.down
    remove_column :specimens, :legacy
  end
end
