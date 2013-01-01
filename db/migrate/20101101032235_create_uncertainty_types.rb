class CreateUncertaintyTypes < ActiveRecord::Migration
  def self.up
    create_table :uncertainty_types do |t|
      t.string :uncertainty_type
      t.timestamps
    end
  end

  def self.down
    drop_table :uncertainty_types
  end
end
