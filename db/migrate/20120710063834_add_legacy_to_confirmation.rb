class AddLegacyToConfirmation < ActiveRecord::Migration
  def self.up
    add_column :confirmations, :legacy, :boolean
  end

  def self.down
    remove_column :confirmations, :legacy
  end
end
