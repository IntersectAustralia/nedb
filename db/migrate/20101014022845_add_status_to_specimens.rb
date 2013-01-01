class AddStatusToSpecimens < ActiveRecord::Migration
  def self.up
    add_column :specimens, :status, :string
  end

  def self.down
    remove_column :specimens, :status
  end
end
