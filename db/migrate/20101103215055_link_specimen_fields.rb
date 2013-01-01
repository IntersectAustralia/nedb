class LinkSpecimenFields < ActiveRecord::Migration
  def self.up
    add_column :specimens, :replicate_from, :string
    add_column :specimens, :replicate_from_no, :string
  end

  def self.down
    remove_column :specimens, :replicate_from
    remove_column :specimens, :replicate_from_no
  end
end
