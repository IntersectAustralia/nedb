class CreateDeterminations < ActiveRecord::Migration
  def self.up
    create_table :determinations do |t|
      t.integer :specimen_id
      t.string :div_class
      t.string :family
      t.string :genus
      t.string :species
      t.string :authority
      t.string :infraspecific_rank
      t.string :infraspecific_epithet
      t.string :infraspecific_authority
      t.integer :determiner_id
      t.date :determination_date

      t.timestamps
    end
  end

  def self.down
    drop_table :determinations
  end
end
