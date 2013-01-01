class CreateVarieties < ActiveRecord::Migration
  def self.up
    create_table :varieties do |t|
      t.string :variety
      t.string :authority
      t.references :species

      t.timestamps
    end
  end

  def self.down
    drop_table :varieties
  end
end
