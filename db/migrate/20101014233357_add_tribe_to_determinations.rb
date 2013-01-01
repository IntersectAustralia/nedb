class AddTribeToDeterminations < ActiveRecord::Migration
  def self.up
    add_column :determinations, :tribe, :string
  end

  def self.down
    remove_column :determinations, :tribe
  end
end
