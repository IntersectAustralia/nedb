class SplitConfirmationDate < ActiveRecord::Migration
  def self.up
    change_table :confirmations do |t|
      t.remove :confirmation_date

      t.integer :confirmation_date_year
      t.integer :confirmation_date_month
      t.integer :confirmation_date_day
    end
  end

  def self.down
    change_table :confirmations do |t|
      t.remove :confirmation_date_day, :confirmation_date_month, :confirmation_date_year

      t.date :confirmation_date
    end

  end
end
