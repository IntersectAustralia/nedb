class RenameDeterminationDivClass < ActiveRecord::Migration
  def self.up
    rename_column :determinations, :div_class, :division 
  end

  def self.down
    rename_column :determinations, :division, :div_class 
  end
end
