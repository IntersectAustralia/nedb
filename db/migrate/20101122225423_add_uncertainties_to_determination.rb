class AddUncertaintiesToDetermination < ActiveRecord::Migration
  def self.up
    add_column :determinations, :species_uncertainty, :string
    add_column :determinations, :subspecies_uncertainty, :string
    add_column :determinations, :variety_uncertainty, :string
    add_column :determinations, :form_uncertainty, :string
  end

  def self.down
    remove_column :determinations, :species_uncertainty
    remove_column :determinations, :subspecies_uncertainty
    remove_column :determinations, :variety_uncertainty
    remove_column :determinations, :form_uncertainty
  end
end
