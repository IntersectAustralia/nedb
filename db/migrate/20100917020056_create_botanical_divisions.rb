class CreateBotanicalDivisions < ActiveRecord::Migration
  def self.up
    create_table :botanical_divisions do |t|
      t.integer :state_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :botanical_divisions
  end
end
