class AddUserIdRemoveEmailFromSpecimenImages < ActiveRecord::Migration
  def self.up
    remove_column :specimen_images, :uploader_email
    add_column :specimen_images, :user_id, :integer
  end

  def self.down
    add_column :specimen_images, :uploader_email, :string
    remove_column :specimen_images, :user_id
  end
end
