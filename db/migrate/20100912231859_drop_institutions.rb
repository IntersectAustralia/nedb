class DropInstitutions < ActiveRecord::Migration
  def self.up
    drop_table :institutions
  end

  def self.down
    create_table :institutions do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
