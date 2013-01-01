class SplitDeterminationDate < ActiveRecord::Migration
  def self.up
    change_table :determinations do |t|
      t.remove :determination_date

      t.integer :determination_date_year
      t.integer :determination_date_month
      t.integer :determination_date_day
    end
  end

  def self.down
    change_table :determinations do |t|
      t.remove :determination_date_day, :determination_date_month, :determination_date_year

      t.date :determination_date
    end
  end
end
