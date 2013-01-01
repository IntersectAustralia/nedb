require 'spec_helper'

describe Profile do
  describe "Associations" do
    it { should have_and_belong_to_many(:permissions) }
  end
  
  describe "Validations" do
    it { should validate_presence_of(:name) }

    it "should reject duplicate names" do
      attr = {:name => "abc"}
      Profile.create!(attr)
      with_duplicate_name = Profile.new(attr)
      with_duplicate_name.should_not be_valid
    end

    it "should reject duplicate names identical up to case" do
      attr = {:name => "abc"}
      Profile.create!(attr.merge(:name => "ABC"))
      with_duplicate_name = Profile.new(@attr)
      with_duplicate_name.should_not be_valid
    end
  end

  describe "Get superuser emails" do
    it "should find all approved superusers and extract their email address" do
      super_profile = Factory(:profile, :name => "Superuser")
      admin_profile = Factory(:profile, :name => "Admin")
      super_1 = Factory(:user, :profile => super_profile, :status => "A", :email => "a@intersect.org.au")
      super_2 = Factory(:user, :profile => super_profile, :status => "U", :email => "b@intersect.org.au")
      super_3 = Factory(:user, :profile => super_profile, :status => "A", :email => "c@intersect.org.au")
      super_4 = Factory(:user, :profile => super_profile, :status => "D", :email => "d@intersect.org.au")
      super_5 = Factory(:user, :profile => super_profile, :status => "R", :email => "e@intersect.org.au")
      admin = Factory(:user, :profile => admin_profile, :status => "A", :email => "f@intersect.org.au")

      supers = Profile.get_superuser_emails
      supers.should eq(["a@intersect.org.au", "c@intersect.org.au"])
    end
  end

end
