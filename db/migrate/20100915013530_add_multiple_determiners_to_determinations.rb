class AddMultipleDeterminersToDeterminations < ActiveRecord::Migration
  def self.up
    change_table :determinations do |t|
      t.remove :determiner_id
    end
    create_table :determination_determiners, :id => false do |t|
      t.integer :determination_id
      t.integer :determiner_id
    end 
  end

  def self.down
    drop_table :determination_determiners
    change_table :determinations do |t|
      t.integer :determiner_id
    end
  end
end
