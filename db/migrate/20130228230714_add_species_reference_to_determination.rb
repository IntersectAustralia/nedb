class AddSpeciesReferenceToDetermination < ActiveRecord::Migration
  def self.up
    add_column :determinations, :referenced, :boolean
    Determination.all.each do |determination|
      unless %w(division class_name order_name family sub_family tribe genus species).all?{|attr| determination[attr].blank?}
        determination.update_attribute(:referenced, true)
      end
    end
  end

  def self.down
    remove_column :determinations, :referenced
  end
end
