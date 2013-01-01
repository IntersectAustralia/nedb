class AddIndexToDeterminationDeterminers < ActiveRecord::Migration
  def self.up
    add_index :determination_determiners, :determination_id
    add_index :determination_determiners, :determiner_id   
  end

  def self.down
    remove_index :determination_determiners, :determination_id
    remove_index :determination_determiners, :determiner_id
  end
end
