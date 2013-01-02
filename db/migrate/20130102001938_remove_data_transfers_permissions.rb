class RemoveDataTransfersPermissions < ActiveRecord::Migration
  def self.up
    perms = Permission.where(:entity => 'DataTransfersController')
    perms.delete_all
  end

  def self.down
  end
end
