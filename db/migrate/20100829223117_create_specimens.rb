class CreateSpecimens < ActiveRecord::Migration
  def self.up
    create_table :specimens do |t|
      t.integer :collector_id
      t.string :collector_number
      t.date :collection_date
      t.string :country
      t.string :state
      t.string :botanical_division
      t.text :locality_description
      t.integer :latitude_degrees
      t.integer :latitude_minutes
      t.integer :latitude_seconds
      t.integer :longitude_degrees
      t.integer :longitude_minutes
      t.integer :longitude_seconds
      t.integer :altitude
      t.string :point_data
      t.string :datum
      t.string :waypoint
      t.text :topography
      t.string :aspect
      t.text :substrate
      t.text :vegetation
      t.string :frequency
      t.text :plant_description

      t.timestamps
    end
  end

  def self.down
    drop_table :specimens
  end
end
