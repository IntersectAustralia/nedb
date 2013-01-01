class CreateSpecimenReplicates < ActiveRecord::Migration
  def self.up
    create_table 'specimen_replicates', :id => false do |t|
      t.column :specimen_id, :integer
      t.column :institution_id, :integer
    end
  end

  def self.down
    drop_table 'specimen_replicates'
  end
end
