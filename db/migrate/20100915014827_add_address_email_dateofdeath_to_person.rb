class AddAddressEmailDateofdeathToPerson < ActiveRecord::Migration
  def self.up
    remove_column :people, :date_of_birth
    add_column :people, :date_of_birth_day, :integer
    add_column :people, :date_of_birth_month, :integer
    add_column :people, :date_of_birth_year, :integer
    add_column :people, :date_of_death_day, :integer
    add_column :people, :date_of_death_month, :integer
    add_column :people, :date_of_death_year, :integer
    add_column :people, :address, :string
    add_column :people, :email, :string
  end

  def self.down
    remove_column :people, :date_of_birth_day
    remove_column :people, :date_of_birth_month
    remove_column :people, :date_of_birth_year
    remove_column :people, :date_of_death_day
    remove_column :people, :date_of_death_month
    remove_column :people, :date_of_death_year
    remove_column :people, :address
    remove_column :people, :email
  end
end
