class RenameInstitutionToHerbarium < ActiveRecord::Migration
  def self.up
    rename_column :specimen_replicates, :institution_id, :herbarium_id 
    rename_column :confirmations, :confirmer_institution_id, :confirmer_herbarium_id
    rename_column :determinations, :determiner_institution_id, :determiner_herbarium_id
    rename_column :people, :institution_id, :herbarium_id
  end

  def self.down
    rename_column :specimen_replicates, :herbarium_id, :institution_id
    rename_column :confirmations, :confirmer_herbarium_id, :confirmer_institution_id
    rename_column :determinations, :determiner_herbarium_id, :determiner_institution_id
    rename_column :people, :herbarium_id, :institution_id
  end
end
