class AddDetailsToDeterminations < ActiveRecord::Migration
  def self.up
    change_table :determinations do |t|
      t.string :herbarium_code
      t.string :class_name
      t.string :sub_family
      t.string :species_authority
      t.string :sub_species
      t.string :sub_species_authority
      t.string :variety
      t.string :variety_authority
      t.string :form
      t.string :form_authority

      t.remove :authority, :infraspecific_rank, :infraspecific_epithet, :infraspecific_authority
    end

  end

  def self.down
    change_table :determinations do |t|
      t.string :authority
      t.string :infraspecific_rank
      t.string :infraspecific_epithet
      t.string :infraspecific_authority

      t.remove :herbarium_code, :class_name, :sub_family, :species_authority, :sub_species, :sub_species_authority,
        :variety, :variety_authority, :form, :form_authority
    end
  end
end
