class AddIndexToProfilePermissions < ActiveRecord::Migration
  def self.up
    add_index :profiles_permissions, :profile_id
    add_index :profiles_permissions, :permission_id 
  end

  def self.down
    remove_index :profiles_permissions, :profile_id
    remove_index :profiles_permissions, :permission_id
  end
end
