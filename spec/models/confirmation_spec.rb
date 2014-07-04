require 'spec_helper'

describe Confirmation do

  describe "Associations" do
    it { should belong_to(:specimen) }
    it { should belong_to(:determination) }
    it { should belong_to(:confirmer) }
    it { should belong_to(:confirmer_herbarium) }
  end

  describe "Validations" do
    it { should validate_presence_of(:specimen) }
    it { should validate_presence_of(:confirmer) }
    it { should validate_presence_of(:determination) }
  end

  describe "When entering a date for a confirmation at least the year should be present" do
    
    before(:each) do
      @person = FactoryGirl.create(:person)
      @specimen = FactoryGirl.create(:specimen, :collector => @person)
      @herbarium = FactoryGirl.create(:herbarium)
      @determination = Determination.new
    end

    it "should reject an empty confirmation date" do
      @confirmation = @determination.create_confirmation()
      @confirmation.should_not be_valid
    end
    it "should accept a confirmation date with only the year filled in" do
      @confirmation = Confirmation.new(:specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_year => '2010', :determination => @determination)
      @confirmation.should be_valid
    end 
    it "should not accept a confirmation date with only the month filled in" do
      @confirmation = Confirmation.new(:specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_month => '7', :determination => @determination)
      @confirmation.should_not be_valid
    end
    it "should not accept a confirmation date with only the day filled in" do
      @confirmation = Confirmation.new(:specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_day => '20', :determination => @determination)
      @confirmation.should_not be_valid
    end
    it "should not accept a confirmation date with two date fields - not including the year " do
      @confirmation = Confirmation.new(:specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_month => '12', :confirmation_date_day => '20', :determination => @determination)
      @confirmation.should_not be_valid
    end
    it "should accept a confirmation date with year and month" do
      @confirmation = Confirmation.new(:specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_year => '2020', :confirmation_date_month => '8', :determination => @determination)   
      @confirmation.should be_valid
    end
    it "should verify valid day" do
      @confirmation = Confirmation.new(:specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_day => '50', :determination => @determination)
      @confirmation.should_not be_valid
      @confirmation.should have(1).error_on(:confirmation_date_day)
    end
    it "should verify valid month" do
      @confirmation = Confirmation.new(:specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_month => '50', :determination => @determination)
      @confirmation.should_not be_valid
      @confirmation.should have(1).error_on(:confirmation_date_month)
    end 
    it "should verify valid year" do
      @confirmation = Confirmation.new(:specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_year => '10000', :determination => @determination)
      @confirmation.should_not be_valid
      @confirmation.should have(1).error_on(:confirmation_date_year)
    end

    it "should accept an empty confirmation date if legacy" do
      @confirmation = Confirmation.new(:legacy => true, :specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :determination => @determination)
      @confirmation.should be_valid
    end
    it "should accept a confirmation date with only the year filled in if legacy" do
      @confirmation = Confirmation.new(:legacy => true, :specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_year => '2010', :determination => @determination)
      @confirmation.should be_valid
    end
    it "should not accept a confirmation date with only the month filled in if legacy" do
      @confirmation = Confirmation.new(:legacy => true, :specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_month => '7', :determination => @determination)
      @confirmation.should_not be_valid
    end
    it "should not accept a confirmation date with only the day filled in if legacy" do
      @confirmation = Confirmation.new(:legacy => true, :specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_day => '20', :determination => @determination)
      @confirmation.should_not be_valid
    end
    it "should not accept a confirmation date with two date fields - not including the year if legacy" do
      @confirmation = Confirmation.new(:legacy => true, :specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_month => '12', :confirmation_date_day => '20', :determination => @determination)
      @confirmation.should_not be_valid
    end
    it "should accept a confirmation date with year and month if legacy" do
      @confirmation = Confirmation.new(:legacy => true, :specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_year => '2020', :confirmation_date_month => '8', :determination => @determination)
      @confirmation.should be_valid
    end
    it "should verify valid day if legacy" do
      @confirmation = Confirmation.new(:legacy => true, :specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_day => '50', :determination => @determination)
      @confirmation.should_not be_valid
      @confirmation.should have(1).error_on(:confirmation_date_day)
    end
    it "should verify valid month if legacy" do
      @confirmation = Confirmation.new(:legacy => true, :specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_month => '50', :determination => @determination)
      @confirmation.should_not be_valid
      @confirmation.should have(1).error_on(:confirmation_date_month)
    end
    it "should verify valid year if legacy" do
      @confirmation = Confirmation.new(:legacy => true, :specimen => @specimen, :confirmer => @person, :confirmer_herbarium => @herbarium, :confirmation_date_year => '10000', :determination => @determination)
      @confirmation.should_not be_valid
      @confirmation.should have(1).error_on(:confirmation_date_year)
    end
  end

  describe "A confirmation belong to a determination" do
    it "should be linked to existing determination" do
      confirmer = FactoryGirl.create(:person)
      specimen = FactoryGirl.create(:specimen, :collector => confirmer)
      determination = Determination.new(:id => '20')
      confirmation = determination.create_confirmation(:specimen => specimen, :confirmer => confirmer)      
      confirmation.determination_id.should eq(determination.id)
    end
  end
end
