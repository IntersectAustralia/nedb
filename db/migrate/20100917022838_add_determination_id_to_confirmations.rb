class AddDeterminationIdToConfirmations < ActiveRecord::Migration
  def self.up
    add_column :confirmations, :determination_id, :integer
  end

  def self.down
    remove_column :confirmations, :determination_id
  end
end
