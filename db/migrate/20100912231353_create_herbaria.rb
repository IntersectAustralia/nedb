class CreateHerbaria < ActiveRecord::Migration
  def self.up
    create_table :herbaria do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :herbaria
  end
end
