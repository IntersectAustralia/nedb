class SplitCollectionDateOnSpecimen < ActiveRecord::Migration
  def self.up
    change_table :specimens do |t|
      t.remove :collection_date

      t.integer :collection_date_year
      t.integer :collection_date_month
      t.integer :collection_date_day
    end
  end

  def self.down
    change_table :specimens do |t|
      t.remove :collection_date_day, :collection_date_month, :collection_date_year

      t.date :collection_date
    end
  end
end
