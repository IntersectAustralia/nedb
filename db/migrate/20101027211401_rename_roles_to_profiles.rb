class RenameRolesToProfiles < ActiveRecord::Migration
  def self.up
    rename_table :roles, :profiles
    rename_column :users, :role_id, :profile_id
  end

  def self.down
    rename_table :profiles, :roles
    rename_column :users, :profile_id, :role_id
  end
end
