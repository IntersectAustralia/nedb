class AddIndexToSpecimenReplicates < ActiveRecord::Migration
  def self.up
    add_index :specimen_replicates, :specimen_id
    add_index :specimen_replicates, :herbarium_id
  end

  def self.down
    remove_index :specimen_replicates, :specimen_id
    remove_index :specimen_replicates, :herbarium_id
  end
end
