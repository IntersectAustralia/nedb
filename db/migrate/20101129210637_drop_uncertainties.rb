class DropUncertainties < ActiveRecord::Migration
  def self.up
    drop_table :uncertainties
  end

  def self.down
    create_table :uncertainties do |t|
      t.string :uncertainty_field
      t.references :determination
      t.references :uncertainty_type

      t.timestamps
    end
  end
end
