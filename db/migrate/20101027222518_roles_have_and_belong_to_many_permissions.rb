class RolesHaveAndBelongToManyPermissions < ActiveRecord::Migration
  def self.up
    create_table :profiles_permissions, :id => false do |t|
      t.references :profile, :permission
    end
  end
 
  def self.down
    drop_table :profiles_permissions
  end
end
