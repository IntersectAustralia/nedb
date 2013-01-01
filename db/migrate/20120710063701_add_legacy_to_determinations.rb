class AddLegacyToDeterminations < ActiveRecord::Migration
  def self.up
    add_column :determinations, :legacy, :boolean
  end

  def self.down
    remove_column :determinations, :legacy
  end
end
