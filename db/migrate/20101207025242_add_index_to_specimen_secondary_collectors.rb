class AddIndexToSpecimenSecondaryCollectors < ActiveRecord::Migration
  def self.up
    add_index :specimen_secondary_collectors, :specimen_id  
    add_index :specimen_secondary_collectors, :collector_id
   end

  def self.down
    remove_index :specimen_secondary_collectors, :specimen_id
    remove_index :specimen_secondary_collectors, :collector_id
  end
end
