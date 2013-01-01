require 'spec_helper'

describe Herbarium do
  describe "Validations" do
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:name) }

    it "should reject duplicate codes" do
      attr = {:code => "ABC", :name => "abc"}
      Herbarium.create!(attr)
      type_with_duplicate_code = Herbarium.new(attr)
      type_with_duplicate_code.should_not be_valid
    end

    it "should reject codes identical up to case" do
      attr = {:code => "ABC", :name => "abc"}
      Herbarium.create!(attr.merge(:code => "abc"))
      type_with_duplicate_code = Herbarium.new(@attr)
      type_with_duplicate_code.should_not be_valid
    end

    describe "should reject any characters other than the whitelisted ones" do
      it { Factory.build(:herbarium, :code => 'ABCDEFGHIXYZ123').should be_valid }
      it { Factory.build(:herbarium, :code => 'jklmnopqrstuv90').should be_valid }
      it { Factory.build(:herbarium, :code => ' %-/$+.').should be_valid }
      it { Factory.build(:herbarium, :code => ' ABC%').should be_valid }
      it { Factory.build(:herbarium, :code => 'ABC!').should_not be_valid }
      it { Factory.build(:herbarium, :code => 'ABC@').should_not be_valid }
      it { Factory.build(:herbarium, :code => 'ABC#').should_not be_valid }
      it { Factory.build(:herbarium, :code => 'ABC^').should_not be_valid }
      it { Factory.build(:herbarium, :code => 'ABC=').should_not be_valid }
      it { Factory.build(:herbarium, :code => 'ABC>').should_not be_valid }

      it "should have the correct error message" do
        herbarium = Factory.build(:herbarium, :code => 'abc##')
        herbarium.should_not be_valid
        message = herbarium.errors[:code]
        message.first.should eq("Herbarium code can ony contain letters, numbers, spaces and characters . % - / $ +")
      end
    end

    describe "should reject codes longer than 15 characters" do
      it { Factory.build(:herbarium, :code => '123456789012345').should be_valid }
      it { Factory.build(:herbarium, :code => '1234567890123456').should_not be_valid }

      it "should have the correct error message" do
        herbarium = Factory.build(:herbarium, :code => '1234567890123456')
        herbarium.should_not be_valid
        message = herbarium.errors[:code]
        message.first.should eq("is too long (maximum is 15 characters)")
      end
    end
  end

  describe "Autocomplete search " do
    before do
      Factory :herbarium, :code => "ABC", :name => "Al's Botanical Collective"
      Factory :herbarium, :code => "ACDC", :name => "Australian Classification of Data Co-op"
      Factory :herbarium, :code => "BCE", :name => "Brisbane Curator's Expedition"
      Factory :herbarium, :code => "FFF", :name => "AAA"
    end
      it "should return matches that start with the same letters" do
        Herbarium.autocomplete_herbarium_name("A").collect { |s| s.code }.should eq %w(ABC ACDC FFF)
      end
      it "should return matches regardless of case of search term" do
        Herbarium.autocomplete_herbarium_name("bRIS").collect { |s| s.code }.should eq %w(BCE)
      end

  end

  describe "Is stud? method" do
    it "should return true only for the student herbarium" do
      Factory(:herbarium, :code => 'Blah').should_not be_student_herbarium
      Factory(:herbarium, :code => 'Stud').should_not be_student_herbarium
      Factory(:herbarium, :code => 'Stud.').should be_student_herbarium
    end
  end

end
