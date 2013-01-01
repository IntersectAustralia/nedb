class AddHemispheresToSpecimens < ActiveRecord::Migration
  def self.up
    add_column :specimens, :latitude_hemisphere, :string, :limit => 1
    add_column :specimens, :longitude_hemisphere, :string, :limit => 1
  end

  def self.down
    remove_column :specimens, :longitude_hemisphere
    remove_column :specimens, :latitude_hemisphere
  end
end
