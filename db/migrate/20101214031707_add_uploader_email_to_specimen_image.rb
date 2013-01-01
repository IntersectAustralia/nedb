class AddUploaderEmailToSpecimenImage < ActiveRecord::Migration
  def self.up
    change_table :specimen_images do |t|
      t.string :uploader_email
    end
  end

  def self.down
    change_table :specimen_images do |t|
      t.remove uploader_email
    end
  end
end
