class CombineUserFields < ActiveRecord::Migration
  def self.up
    remove_column :users, :group
    remove_column :users, :school
    remove_column :users, :institution
    add_column :users, :group_school_institution, :string
  end

  def self.down
    add_column :users, :group, :string
    add_column :users, :school, :string
    add_column :users, :institution, :string
    remove_column :users, :group_school_institution
  end
end
