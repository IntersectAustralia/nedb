class AddDobAndInstitutionToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :date_of_birth, :date
    add_column :people, :institution, :string 
  end

  def self.down
    remove_column :people, :date_of_birth
    remove_column :people, :institution
  end
end
