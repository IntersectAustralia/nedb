class RemoveLockingColumnsFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :failed_attempts
    remove_column :users, :unlock_token
    remove_column :users, :locked_at
  end

  def self.down
    add_column :users, :failed_attempts, :integer, :default => 0
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime
  end
end
