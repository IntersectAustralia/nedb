require 'spec_helper'

describe Variety do
  describe "Validations" do
    it { should validate_presence_of(:variety) }
    it { should validate_presence_of(:authority) }

    describe "Duplicate checks" do
      before(:each) do
        @species1 = FactoryGirl.create(:species)
        @species2 = FactoryGirl.create(:species)
      end

      it "should reject duplicate name within a species" do
        @species1.varieties.create!({:variety => "def", :authority => "auth1"})
        duplicate = @species1.varieties.new({:variety => "def", :authority => "auth2"})
        duplicate.should_not be_valid
      end

      it "should allow duplicate names under different species" do
        @species1.varieties.create!({:variety => "def", :authority => "auth1"})
        duplicate = @species2.varieties.new({:variety => "def", :authority => "auth2"})
        duplicate.should be_valid
      end
    end
  end

  describe "Associations" do
    it { should belong_to(:species) }
  end

  describe "Forcing correct case" do
    it "should set case correctly on name before save" do
      variety = Variety.create!(:variety => "VarieTY Blah",
                          :authority => "Auth. FBC.")
      #reload from db
      variety = Variety.find(variety.id)

      variety.variety.should eq("variety blah")
      variety.authority.should eq("Auth. FBC.")
    end
  end
end
