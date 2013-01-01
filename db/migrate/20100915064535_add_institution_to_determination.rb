class AddInstitutionToDetermination < ActiveRecord::Migration
  def self.up
    change_table :determinations do |t|
      t.string :institution
    end
  end

  def self.down
    change_table :determinations do |t|  
      t.remove :institution
    end
  end
end
