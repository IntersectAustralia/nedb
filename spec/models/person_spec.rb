require 'spec_helper'

describe Person do

  describe "Validations" do
    it { should validate_presence_of(:initials) }
    it { should validate_presence_of(:last_name) }
    it { should validate_numericality_of(:date_of_birth_day) }
    it { should validate_numericality_of(:date_of_birth_month) }
    it { should validate_numericality_of(:date_of_birth_year) }
    it { should validate_numericality_of(:date_of_death_day) }
    it { should validate_numericality_of(:date_of_death_month) }
    it { should validate_numericality_of(:date_of_death_year) }

    it "should reject input that is missing last name" do
      @person = Person.new(:first_name => 'James')
      @person.should_not be_valid
      @person.should have(1).error_on(:last_name)
    end
    it "should reject input that is missing initials" do
      @person = Person.new(:last_name => 'James')
      @person.should_not be_valid
      @person.should have(1).error_on(:initials)
    end
    it "should not save an invalid entry for DOB day" do
      @person = Person.new(:first_name => 'James', :last_name => 'Jam', :date_of_birth_day => '50')
      @person.should_not be_valid
      @person.should have(1).error_on(:date_of_birth_day)
    end
    it "should not save an invalid entry for DOB month" do
      @person = Person.new(:first_name => 'James', :last_name => 'Jam', :date_of_birth_month => '50')
      @person.should_not be_valid
      @person.should have(1).error_on(:date_of_birth_month)
    end
    it "should not save an invalid entry for DOB year" do
      @person = Person.new(:first_name => 'James', :last_name => 'Jam', :date_of_birth_year => '121250')
      @person.should_not be_valid
      @person.should have(1).error_on(:date_of_birth_year)
    end
    it "should not save an invalid entry for Date of death day" do
      @person = Person.new(:first_name => 'James', :last_name => 'Jam', :date_of_death_day => '50')
      @person.should_not be_valid
      @person.should have(1).error_on(:date_of_death_day)
    end
    it "should not save an invalid entry for Date of death month" do
      @person = Person.new(:first_name => 'James', :last_name => 'Jam', :date_of_death_month => '10000')
      @person.should_not be_valid
      @person.should have(1).error_on(:date_of_death_month)
    end
    it "should not save an invalid entry for Date of death year" do
      @person = Person.new(:first_name => 'James', :last_name => 'Jam', :date_of_death_year => '10000')
      @person.should_not be_valid
      @person.should have(1).error_on(:date_of_death_year)
    end

    it "should reject duplicate last names" do
      attr = {:first_name => "Fred", :last_name => "Quimby", :initials => 'F. Quimby'}
      Person.create!(attr)
      duplicate = Person.new(attr)
      duplicate.should_not be_valid
    end

    it "should reject display names identical up to case" do
      attr = {:first_name => "Fred", :last_name => "Quimby", :initials => 'F. Quimby'}
      Person.create!(attr.merge(:first_name => "Fruit"))
      duplicate = Person.new(@attr)
      duplicate.should_not be_valid
    end
  end

  describe "Associations" do
    it { should belong_to(:herbarium) }
    it { should have_many(:specimens) }
    it { should have_many(:determinations) }
    it { should have_many(:secondary_specimens) }
    it { should have_many(:confirmations) }
  end

  describe "Destroy restrictions" do

    it "should allow deletion on person with no references" do
      @person = FactoryGirl.create(:person, :first_name => "Fred", :last_name => "Quimby")
      @person.specimens.should be_blank
      @person.secondary_specimens.should be_blank
      @person.confirmations.should be_blank
      @person.determinations.should be_blank
      lambda { @person.destroy }.should_not raise_error(ActiveRecord::DeleteRestrictionError)
    end

    it "should error on person with specimens" do
      @person = FactoryGirl.create(:person, :first_name => "Fred", :last_name => "Quimby")
      FactoryGirl.create(:specimen, :collector => @person)

      @person.specimens.should_not be_blank
      @person.secondary_specimens.should be_blank
      @person.confirmations.should be_blank
      @person.determinations.should be_blank

      lambda { @person.destroy }.should raise_error(ActiveRecord::DeleteRestrictionError)
    end

    it "should error on person with secondary specimens" do
      @person = FactoryGirl.create(:person, :first_name => "Fred", :last_name => "Quimby")
      @specimen = FactoryGirl.create(:specimen)
      @specimen.secondary_collectors << @person

      @person.specimens.should be_blank
      @person.secondary_specimens.should_not be_blank
      @person.confirmations.should be_blank
      @person.determinations.should be_blank

      lambda { @person.destroy }.should raise_error(ActiveRecord::DeleteRestrictionError)
    end

    it "should error on person with confirmations" do
      @person_1 = FactoryGirl.create(:person, :first_name => "Jack", :last_name => "Cat")
      @person_2 = FactoryGirl.create(:person, :first_name => "George", :last_name => "Goat")
      @specimen = FactoryGirl.create(:specimen, :collector => @person_1)
      @determination = FactoryGirl.create(:determination, :specimen => @specimen)

      @confirmation = Confirmation.create(:specimen => @specimen, :confirmer => @person_2, :confirmer_herbarium => @herbarium, :confirmation_date_year => '2010', :determination => @determination)

      @person_2.specimens.should be_blank
      @person_2.secondary_specimens.should be_blank
      @person_2.confirmations.should_not be_blank
      @person_2.determinations.should be_blank

      lambda { @person_2.destroy }.should raise_error(ActiveRecord::DeleteRestrictionError)
    end

    it "should error on person with determinations" do
      @person = FactoryGirl.create(:person, :first_name => "Fred", :last_name => "Quimby")
      @determination = FactoryGirl.create(:determination, :determiners => [@person])

      @determination.determiners << @person

      @person.specimens.should be_blank
      @person.secondary_specimens.should be_blank
      @person.confirmations.should be_blank
      @person.determinations.should_not be_blank

      lambda { @person.destroy }.should raise_error(ActiveRecord::DeleteRestrictionError)
    end

  end
end
