class CreateUncertainties < ActiveRecord::Migration
  def self.up
    create_table :uncertainties do |t|
      t.string :field
      t.references :determination
      t.references :uncertainty_type

      t.timestamps
    end
  end

  def self.down
    drop_table :uncertainties
  end
end
