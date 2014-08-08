class SpecimenImage < ActiveRecord::Base
  after_validation :clean_paperclip_errors

  IMAGES_ROOT = APP_CONFIG['images_root']

  belongs_to :specimen, :touch => true
  belongs_to :user

  validates :specimen, :presence => true
  validates :description, :presence => true
  validates_length_of :description, :maximum => 255

  has_attached_file :image, :styles => { :thumb => "100x100>", :medium => '800x800>' },
                    :path => "#{IMAGES_ROOT}/:id/:style_:basename.:extension",
                    :url => "/:id/:style_:basename"

  validates_attachment_presence :image, :message => "Image file name must be set."
  validates_attachment_size :image, :less_than => 10.megabytes, :message => "must be less than 10MB"
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp'], :message => 'is not supported. Please make sure you have selected an image file.'

  # This is because paperclip duplicates error messages... See: https://github.com/thoughtbot/paperclip/pull/1554
  def clean_paperclip_errors
    errors.delete(:image) if errors.include?(:image_content_type) || errors.include?(:image_file_size)
  end
end
