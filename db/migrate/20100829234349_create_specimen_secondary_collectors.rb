class CreateSpecimenSecondaryCollectors < ActiveRecord::Migration
  def self.up
    create_table 'specimen_secondary_collectors', :id => false do |t|
      t.column :specimen_id, :integer
      t.column :collector_id, :integer
    end
  end

  def self.down
    drop_table 'specimen_secondary_collectors'
  end
end
