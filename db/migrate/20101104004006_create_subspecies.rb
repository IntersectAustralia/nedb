class CreateSubspecies < ActiveRecord::Migration
  def self.up
    create_table :subspecies do |t|
      t.string :subspecies
      t.string :authority
      t.references :species

      t.timestamps
    end
  end

  def self.down
    drop_table :subspecies
  end
end
