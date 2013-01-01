class ChangeSecondsToDecimalInSpecimen < ActiveRecord::Migration
  def self.up
    change_table :specimens do |t|
      t.remove :latitude_seconds
      t.remove :longitude_seconds
      t.decimal :latitude_seconds
      t.decimal :longitude_seconds
    end
  end

  def self.down
    change_table :specimens do |t|
      t.remove :latitude_seconds
      t.remove :longitude_seconds
      t.integer :latitude_seconds
      t.integer :longitude_seconds
    end
  end
end
