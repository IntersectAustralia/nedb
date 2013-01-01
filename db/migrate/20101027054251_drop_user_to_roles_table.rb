class DropUserToRolesTable < ActiveRecord::Migration
  def self.up
    drop_table :roles_users
  end

  def self.down
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end
  end
end
