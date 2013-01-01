class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :title, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :other_initials, :string
    add_column :users, :position, :string
    add_column :users, :supervisor, :string
    add_column :users, :group, :string
    add_column :users, :school, :string
    add_column :users, :institution, :string
    add_column :users, :address, :text
    add_column :users, :telephone, :string
  end

  def self.down
    remove_column :users, :telephone
    remove_column :users, :address
    remove_column :users, :institution
    remove_column :users, :school
    remove_column :users, :group
    remove_column :users, :supervisor
    remove_column :users, :position
    remove_column :users, :other_initials
    remove_column :users, :last_name
    remove_column :users, :first_name
    remove_column :users, :title
  end
end
