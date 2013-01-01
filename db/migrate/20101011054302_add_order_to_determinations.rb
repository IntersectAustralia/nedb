class AddOrderToDeterminations < ActiveRecord::Migration
  def self.up
    add_column :determinations, :order, :string
  end

  def self.down
    remove_column :determinations, :order
  end
end
