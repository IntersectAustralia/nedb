class SpecimenNeedsReviewFlag < ActiveRecord::Migration
  def self.up
    add_column :specimens, :needs_review, :boolean
  end

  def self.down
    remove_column :specimens, :needs_review
  end
end
