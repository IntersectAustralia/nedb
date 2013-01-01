class RenameDeterminationOrder < ActiveRecord::Migration
  def self.up
    rename_column :determinations, :order, :order_name
  end

  def self.down
    rename_column :determinations, :order_name, :order
  end
end
