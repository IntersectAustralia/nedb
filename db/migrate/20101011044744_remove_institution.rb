class RemoveInstitution < ActiveRecord::Migration
  def self.up
    remove_column :confirmations, :confirmer_institution
    remove_column :determinations, :institution
    remove_column :people, :institution
  end

  def self.down
    add_column :confirmations, :confirmer_institution, :string
    add_column :determinations, :institution, :string
    add_column :people, :institution, :string
  end
end
