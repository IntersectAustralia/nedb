class AddDetailsToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :first_name, :string
    add_column :people, :middle_name, :string
    add_column :people, :last_name, :string
  end

  def self.down
    remove_column :people, :last_name
    remove_column :people, :middle_name
    remove_column :people, :first_name
  end
end
