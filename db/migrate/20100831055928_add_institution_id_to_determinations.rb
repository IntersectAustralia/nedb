class AddInstitutionIdToDeterminations < ActiveRecord::Migration
  def self.up
    add_column :determinations, :determiner_institution_id, :integer
  end

  def self.down
    remove_column :determinations, :determiner_institution_id
  end
end
