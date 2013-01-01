class AddStatusToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :status, :string, :default => "U"
    remove_column :users, :approved
  end

  def self.down
    remove_column :users, :status
    add_column :users, :approved, :boolean, :default => false
  end
end
