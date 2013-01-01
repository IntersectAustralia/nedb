class AddNaturalisedToDeterminations < ActiveRecord::Migration
  def self.up
    add_column :determinations, :naturalised, :boolean
  end

  def self.down
    remove_column :determinations, :naturalised
  end
end
