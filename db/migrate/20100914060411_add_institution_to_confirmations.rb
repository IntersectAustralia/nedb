class AddInstitutionToConfirmations < ActiveRecord::Migration
  def self.up
    add_column :confirmations, :confirmer_institution, :string
  end

  def self.down
    remove_column :confirmations, :confirmer_institution
  end
end
