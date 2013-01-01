class RemoveWaypointFromSpecimens < ActiveRecord::Migration
  def self.up
    remove_column :specimens, :waypoint
  end

  def self.down
  end
end
