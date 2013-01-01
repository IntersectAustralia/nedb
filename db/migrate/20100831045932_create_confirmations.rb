class CreateConfirmations < ActiveRecord::Migration
  def self.up
    create_table :confirmations do |t|
      t.integer :specimen_id
      t.integer :confirmer_id
      t.date :confirmation_date
      t.integer :confirmer_institution_id
      t.timestamps
    end
  end

  def self.down
    drop_table :confirmations
  end
end
