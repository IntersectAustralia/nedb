require 'spec_helper'

describe Form do
  describe "Validations" do
    it { should validate_presence_of(:form) }
    it { should validate_presence_of(:authority) }

    describe "Duplicate checks" do
      before(:each) do
        @species1 = Factory(:species)
        @species2 = Factory(:species)
      end

      it "should reject duplicate name within a species" do
        @species1.forms.create!({:form => "def", :authority => "auth1"})
        duplicate = @species1.forms.new({:form => "def", :authority => "auth2"})
        duplicate.should_not be_valid
      end

      it "should allow duplicate names under different species" do
        @species1.forms.create!({:form => "def", :authority => "auth1"})
        duplicate = @species2.forms.new({:form => "def", :authority => "auth2"})
        duplicate.should be_valid
      end
    end
  end

  describe "Associations" do
    it { should belong_to(:species) }
  end

  describe "Forcing correct case" do
    it "should set case correctly on name before save" do
      form = Form.create!(:form => "FoRM Blah",
                          :authority => "Auth. FBC.")
      #reload from db
      form = Form.find(form.id)

      form.form.should eq("form blah")
      form.authority.should eq("Auth. FBC.")
    end
  end
end
