require 'spec_helper'

describe SpecimenImage do

  describe "Create valid" do
    it "should be valid with minimum fields filled in" do
      specimen   = FactoryGirl.create(:specimen)
      specimen_image = SpecimenImage.create(:specimen => specimen,
                                            :description => "from somewhere",
                                            :image_file_name => "filename.jpg")
      specimen_image.should be_valid
    end
  end

  describe "Associations" do
    it { should belong_to(:specimen) }
  end

  describe "Required Field Validations" do
    it { should validate_presence_of(:specimen) }
    it { should validate_presence_of(:description) }
  end

  it "should reject input that is missing description" do
    @specimen_image = SpecimenImage.create(:specimen => FactoryGirl.create(:specimen),
                                           :description => "",
                                           :image_file_name =>  "filename.jpg")
    @specimen_image.should_not be_valid
    @specimen_image.should have(1).error_on(:description)
  end

  it "should reject input that has a description of more than 255 characters" do
    @specimen_image = SpecimenImage.create(:specimen => FactoryGirl.create(:specimen),
                                           :description => "a"*256,
                                           :image_file_name =>  "filename.jpg")
    @specimen_image.should_not be_valid
    @specimen_image.should have(1).error_on(:description)
  end

  it "should reject file sizes larger than 10MB" do
    @specimen_image = SpecimenImage.create(:specimen => FactoryGirl.create(:specimen),
                                           :description => "a",
                                           :image_file_name =>  "filename.jpg",
                                           :image_file_size => 20.megabytes)
    @specimen_image.should_not be_valid
    @specimen_image.should have(1).error_on(:image_file_size)
  end

end
