class ChangeDefaultValueOfSpecimenNeedsReview < ActiveRecord::Migration
  def self.up
    Specimen.find_each do |specimen|
      specimen.update_attribute(:needs_review, false) if specimen.needs_review.nil?
    end

    change_column_default :specimens, :needs_review, false
  end

  def self.down

  end
end
