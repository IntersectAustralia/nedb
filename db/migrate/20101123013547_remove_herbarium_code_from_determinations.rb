class RemoveHerbariumCodeFromDeterminations < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE determinations DROP COLUMN herbarium_code CASCADE"
  end

  def self.down
    add_column :determinations, :herbarium_code, :string
  end
end
