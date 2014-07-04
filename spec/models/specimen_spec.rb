# encoding: UTF-8

require 'spec_helper'

describe Specimen do

  describe "Create valid" do
    it "should be valid with minimum fields filled in" do
      person   = FactoryGirl.create(:person)
      specimen = Specimen.new(:collector_id => person.id, :collection_date_year => 2010)
      specimen.should be_valid
    end
  end

  describe "Associations" do
    it { should belong_to(:collector) }
    it { should have_and_belong_to_many(:secondary_collectors) }
    it { should have_and_belong_to_many(:replicates) }
    it { should have_many(:determinations) }
    it { should have_many(:confirmations) }
    it { should have_many(:items) }
  end

  describe "Required Field Validations" do
    it { should validate_presence_of(:collector) }
  end

  describe "State validation" do
    it "should require state if country is australia" do
      person   = FactoryGirl.create(:person)
      specimen = Specimen.new(:collector_id => person.id, :collection_date_year => 2010, :country => "Australia")
      specimen.should_not be_valid
    end

    it "should be valid if state included and country is australia" do
      person   = FactoryGirl.create(:person)
      specimen = Specimen.new(:collector_id => person.id, :collection_date_year => 2010, :country => "Australia", :state => "Tasmania")
      specimen.should be_valid
    end

    it "should not require state if country is not australia" do
      person   = FactoryGirl.create(:person)
      specimen = Specimen.new(:collector_id => person.id, :collection_date_year => 2010, :country => "Peru")
      specimen.should be_valid
    end
  end

  describe "Other Validations" do
    it { should validate_numericality_of(:altitude) }

    it { should validate_numericality_of(:latitude_degrees) }
    it { should validate_numericality_of(:latitude_minutes) }
    it { should validate_numericality_of(:latitude_seconds) }
    it { should validate_numericality_of(:longitude_degrees) }
    it { should validate_numericality_of(:longitude_minutes) }
    it { should validate_numericality_of(:longitude_seconds) }

    it "should allow valid values for latitude_degrees" do
      (0..90).to_a.each do |v|
        should allow_value(v).for(:latitude_degrees)
      end
    end

    it "should allow valid values for latitude_minutes" do
      (0..59).to_a.each do |v|
        should allow_value(v).for(:latitude_minutes)
      end
    end

    it "should allow valid values for latitude_seconds" do
      (0..60).to_a.each do |v|
        should allow_value(v).for(:latitude_seconds)
      end
    end

    it "should allow valid values for longitude_degrees" do
      (0..180).to_a.each do |v|
        should allow_value(v).for(:longitude_degrees)
      end
    end

    it "should allow valid values for longitude_minutes" do
      (0..59).to_a.each do |v|
        should allow_value(v).for(:longitude_minutes)
      end
    end

    it "should allow valid values for longitude_seconds" do
      (0..60).to_a.each do |v|
        should allow_value(v).for(:longitude_seconds)
      end
    end

    it { should validate_numericality_of(:collection_date_year) }
    it { should validate_numericality_of(:collection_date_month) }
    it { should validate_numericality_of(:collection_date_day) }

    it "should allow valid values for collection_date_year" do
      (1..9999).to_a.each do |v|
        should allow_value(v).for(:collection_date_year)
      end
    end

    it "should allow valid values for collection_date_month" do
      (1..12).to_a.each do |v|
        should allow_value(v).for(:collection_date_month)
      end
    end

    it "should allow valid values for collection_date_day" do
      (1..31).to_a.each do |v|
        should allow_value(v).for(:collection_date_day)
      end
    end

    # empty values are allows for lat/long/alt
    it { should allow_value("").for(:latitude_degrees) }
    it { should allow_value("").for(:latitude_minutes) }
    it { should allow_value("").for(:latitude_seconds) }
    it { should allow_value("").for(:longitude_degrees) }
    it { should allow_value("").for(:longitude_minutes) }
    it { should allow_value("").for(:longitude_seconds) }

  end

  describe "Partial Date Validations" do
    defaults = {:collection_date_day => nil, :collection_date_month => nil, :collection_date_year => nil, :legacy => false}
    it "should reject a totally empty date" do
      specimen = FactoryGirl.build(:specimen, defaults)
      specimen.should_not be_valid
    end
    it "should not accept a date with only the day filled in" do
      specimen = FactoryGirl.build(:specimen, defaults.merge({:collection_date_day => 31}))
      specimen.should_not be_valid
    end
    it "should not accept a date with only the month filled in" do
      specimen = FactoryGirl.build(:specimen, defaults.merge({:collection_date_month => 6}))
      specimen.should_not be_valid
    end
    it "should not accept a date with only the month and day filled in" do
      specimen = FactoryGirl.build(:specimen, defaults.merge({:collection_date_day => 31, :collection_date_month => 1}))
      specimen.should_not be_valid
    end
    it "should not accept a date with only the year and day filled in" do
      specimen = FactoryGirl.build(:specimen, defaults.merge({:collection_date_day => 31, :collection_date_year => 2001}))
      specimen.should_not be_valid
    end
    it "should accept a date with only the year filled in" do
      specimen = FactoryGirl.create(:specimen, defaults.merge({:collection_date_year => 2001}))
      specimen.should be_valid
    end
    it "should accept a date with only month and year filled in" do
      specimen = FactoryGirl.create(:specimen, defaults.merge({:collection_date_month => 12, :collection_date_year => 2001}))
      specimen.should be_valid
    end
    it "should accept a date with all of year month and day filled in" do
      specimen = FactoryGirl.create(:specimen, {:collection_date_year => 2001, :collection_date_month => 10, :collection_date_day => 5})
      specimen.should be_valid
    end
    it "should accept a totally empty date if specimen is legacy" do
      specimen = FactoryGirl.build(:specimen, defaults.merge({:legacy => true}))
      specimen.should be_valid
    end
    it "should not accept a date with only the day filled in if specimen is legacy" do
      specimen = FactoryGirl.build(:specimen, defaults.merge({:collection_date_day => 31, :legacy => true}))
      specimen.should_not be_valid
    end
    it "should not accept a date with only the month filled in if specimen is legacy" do
      specimen = FactoryGirl.build(:specimen, defaults.merge({:collection_date_month => 6, :legacy => true}))
      specimen.should_not be_valid
    end
    it "should not accept a date with only the month and day filled in if specimen is legacy" do
      specimen = FactoryGirl.build(:specimen, defaults.merge({:collection_date_day => 31, :collection_date_month => 1, :legacy => true}))
      specimen.should_not be_valid
    end
    it "should not accept a date with only the year and day filled in if specimen is legacy" do
      specimen = FactoryGirl.build(:specimen, defaults.merge({:collection_date_day => 31, :collection_date_year => 2001, :legacy => true}))
      specimen.should_not be_valid
    end
    it "should accept a date with only the year filled in if specimen is legacy" do
      specimen = FactoryGirl.create(:specimen, defaults.merge({:collection_date_year => 2001, :legacy => true}))
      specimen.should be_valid
    end
    it "should accept a date with only month and year filled in if specimen is legacy" do
      specimen = FactoryGirl.create(:specimen, defaults.merge({:collection_date_month => 12, :collection_date_year => 2001, :legacy => true}))
      specimen.should be_valid
    end
    it "should accept a date with all of year month and day filled in if specimen is legacy" do
      specimen = FactoryGirl.create(:specimen, {:collection_date_year => 2001, :collection_date_month => 10, :collection_date_day => 5, :legacy => true})
      specimen.should be_valid
    end
  end

  describe "Get replicates as comma separated" do
    it "should return the correct string with multiple values" do
      specimen            = FactoryGirl.create(:specimen)
      bol                 = FactoryGirl.create(:herbarium, :code => "BOL")
      eiu                 = FactoryGirl.create(:herbarium, :code => "EIU")
      sss                 = FactoryGirl.create(:herbarium, :code => "SSS")
      specimen.replicates = [eiu, bol, sss]
      specimen.replicates_comma_separated.should eq("BOL, EIU, SSS")
    end

    it "should return the correct string with no values" do
      specimen = FactoryGirl.create(:specimen)
      specimen.replicates_comma_separated.should eq("")
    end

    it "should return the correct string with one value" do
      specimen            = FactoryGirl.create(:specimen)
      bol                 = FactoryGirl.create(:herbarium, :code => "BOL")
      specimen.replicates = [bol]
      specimen.replicates_comma_separated.should eq("BOL")
    end

    it "should put Stud. at the end if present" do
      specimen            = FactoryGirl.create(:specimen)
      zol                 = FactoryGirl.create(:herbarium, :code => "ZOL")
      eiu                 = FactoryGirl.create(:herbarium, :code => "EIU")
      stud                = FactoryGirl.create(:herbarium, :code => "Stud.")
      specimen.replicates = [stud, zol, eiu]
      specimen.replicates_comma_separated.should eq("EIU, ZOL, Stud.")
    end
  end

  describe "Get items as comma separated" do
    before(:each) do
      type_1    = FactoryGirl.create(:item_type, :name => 'Specimen sheet')
      type_2    = FactoryGirl.create(:item_type, :name => 'Fruit')
      type_3    = FactoryGirl.create(:item_type, :name => 'Phytochem')

      @specimen = FactoryGirl.create(:specimen)
      @specimen.items.create!(:item_type => type_1)
      @specimen.items.create!(:item_type => type_3)
      @specimen.items.create!(:item_type => type_2)
      @specimen.items.create!(:item_type => type_2)
      @specimen.items.create!(:item_type => type_1)

      person_1 = FactoryGirl.create(:person, :first_name => "Steve", :last_name => "Jobs", :initials => "S. Jobs")
      @specimen_no_items         = FactoryGirl.create(:specimen, :collector => person_1)
      @specimen_with_only_sheets = FactoryGirl.create(:specimen, :collector => person_1)
      @specimen_with_only_sheets.items.create!(:item_type => type_1)
    end

    it "Should return the unique list of items, ordered alphabetically, duplicates removed" do
      @specimen.items_comma_separated.should eq("Fruit, Phytochem, Specimen sheet")
    end

    it "Get without specimen sheet should exclude specimen sheet from the list" do
      @specimen.items_comma_separated_excluding_specimen_sheet.should eq("Fruit, Phytochem")
    end

    it "should return blank if no items" do
      @specimen_no_items.items_comma_separated.should eq("")
      @specimen_no_items.items_comma_separated_excluding_specimen_sheet.should eq("")
    end

    it "should handle the case of only having specimen sheets" do
      @specimen_with_only_sheets.items_comma_separated.should eq("Specimen sheet")
      @specimen_with_only_sheets.items_comma_separated_excluding_specimen_sheet.should eq("")
    end
  end

  describe "Get altitude with unit" do
    it "should return altitude m when filled in" do
      specimen = FactoryGirl.create(:specimen, :altitude=>20)
      specimen.altitude_with_unit.should eq("20 m")
    end

    it "should handle negatives" do
      specimen = FactoryGirl.create(:specimen, :altitude => -1444)
      specimen.altitude_with_unit.should eq("-1444 m")
    end
  end

  describe "Get secondary collectors as semicolon separated" do
    it "should return the correct string with multiple values" do
      specimen                      = FactoryGirl.create(:specimen)
      collector_1                   = FactoryGirl.create(:person, :initials => "R.A.", :last_name => "Barrett")
      collector_2                   = FactoryGirl.create(:person, :initials => "K.L.", :last_name => "Wilson")
      collector_3                   = FactoryGirl.create(:person, :initials => "A.K.", :last_name => "Gibbs")
      specimen.secondary_collectors = [collector_1, collector_2, collector_3]
      specimen.secondary_collectors_semicolon_separated.should eq("R.A. Barrett; K.L. Wilson; A.K. Gibbs")
    end

    it "should return the correct string with no values" do
      specimen = FactoryGirl.create(:specimen)
      specimen.secondary_collectors_semicolon_separated.should eq("")
    end

    it "should return the correct string with one value" do
      specimen                      = FactoryGirl.create(:specimen)
      collector_1                   = FactoryGirl.create(:person, :initials => "R.A.", :last_name => "Barrett")
      specimen.secondary_collectors = [collector_1]
      specimen.secondary_collectors_semicolon_separated.should eq("R.A. Barrett")
    end
  end

  describe "Get current determination" do
    before(:each) do
      person = FactoryGirl.create(:person, :first_name => "Steve", :last_name => "Tools", :initials => "S. Tools")
      specimen = FactoryGirl.create(:specimen, :collector => person)
      @det_2010        = FactoryGirl.create(:determination, :specimen => specimen, :determiners => [person], :determination_date_year => '2010', :determination_date_month => '', :determination_date_day => '')
      @det_mar_2010    = FactoryGirl.create(:determination, :specimen => specimen, :determiners => [person], :determination_date_year => '2010', :determination_date_month => '3', :determination_date_day => '')
      @det_15_mar_2010 = FactoryGirl.create(:determination, :specimen => specimen, :determiners => [person], :determination_date_year => '2010', :determination_date_month => '3', :determination_date_day => '15')
      @det_jan_2010    = FactoryGirl.create(:determination, :specimen => specimen, :determiners => [person], :determination_date_year => '2010', :determination_date_month => '1', :determination_date_day => '')
      @det_1_jan_2010  = FactoryGirl.create(:determination, :specimen => specimen, :determiners => [person], :determination_date_year => '2010', :determination_date_month => '1', :determination_date_day => '1')
      @det_2009        = FactoryGirl.create(:determination, :specimen => specimen, :determiners => [person], :determination_date_year => '2009', :determination_date_month => '', :determination_date_day => '')
    end
    it "month and year should be considered sooner than just year" do
      specimen = FactoryGirl.create(:specimen, :determination_ids => [@det_2010.id, @det_jan_2010.id])
      specimen.current_determination.id.should eq(@det_jan_2010.id)
    end

    it "day, month and year should be considered sooner than just month and year" do
      specimen = FactoryGirl.create(:specimen, :determination_ids => [@det_1_jan_2010.id, @det_jan_2010.id])
      specimen.current_determination.id.should eq(@det_1_jan_2010.id)
    end

    it "complete dates should be compared correctly" do
      specimen = FactoryGirl.create(:specimen, :determination_ids => [@det_1_jan_2010.id, @det_15_mar_2010.id])
      specimen.current_determination.id.should eq(@det_15_mar_2010.id)
    end

    it "month and year should be compared correctly" do
      specimen = FactoryGirl.create(:specimen, :determination_ids => [@det_jan_2010.id, @det_mar_2010.id])
      specimen.current_determination.id.should eq(@det_mar_2010.id)
    end

    it "just years should be compared correctly" do
      specimen = FactoryGirl.create(:specimen, :determination_ids => [@det_2010.id, @det_2009.id])
      specimen.current_determination.id.should eq(@det_2010.id)
    end

    it "should return nil if no determinations" do
      specimen = FactoryGirl.create(:specimen)
      specimen.current_determination.should be_nil
    end

  end

  describe "Get printable latitude" do
    it "should return full details when all items filled in" do
      specimen = FactoryGirl.create(:specimen, :latitude_degrees => 80, :latitude_minutes => 33, :latitude_seconds => 24, :latitude_hemisphere => "S")
      specimen.latitude_printable.should eq("80° 33' 24\" S")
    end

    it "should include decimal seconds when provided" do
      specimen = FactoryGirl.create(:specimen, :latitude_degrees => 80, :latitude_minutes => 33, :latitude_seconds => 24.342, :latitude_hemisphere => "S")
      specimen.latitude_printable.should eq("80° 33' 24.342\" S")
    end

    it "should include zero before point when seconds less than zero" do
      specimen = FactoryGirl.create(:specimen, :latitude_degrees => 80, :latitude_minutes => 33, :latitude_seconds => 0.342, :latitude_hemisphere => "S")
      specimen.latitude_printable.should eq("80° 33' 0.342\" S")
    end

    it "should return partial details if partially filled" do
      specimen = FactoryGirl.create(:specimen, :latitude_degrees => 80, :latitude_hemisphere => "S")
      specimen.latitude_printable.should eq("80° S")
    end

    it "should return blank if nothing filled" do
      specimen = FactoryGirl.create(:specimen)
      specimen.latitude_printable.should eq("")
    end

    it "should return blank if only hemisphere filled" do
      specimen = FactoryGirl.create(:specimen, :latitude_hemisphere => "S")
      specimen.latitude_printable.should eq("")
    end
  end

  describe "Get printable longitude" do
    it "should return full details when all items filled in" do
      specimen = FactoryGirl.create(:specimen, :longitude_degrees => 80, :longitude_minutes => 33, :longitude_seconds => 24, :longitude_hemisphere => "W")
      specimen.longitude_printable.should eq("80° 33' 24\" W")
    end

    it "should include decimal seconds when provided" do
      specimen = FactoryGirl.create(:specimen, :longitude_degrees => 80, :longitude_minutes => 33, :longitude_seconds => 24.234, :longitude_hemisphere => "W")
      specimen.longitude_printable.should eq("80° 33' 24.234\" W")
    end

    it "should include zero before point when seconds less than zero" do
      specimen = FactoryGirl.create(:specimen, :longitude_degrees => 80, :longitude_minutes => 33, :longitude_seconds => 0.234, :longitude_hemisphere => "W")
      specimen.longitude_printable.should eq("80° 33' 0.234\" W")
    end

    it "should return partial details if partially filled" do
      specimen = FactoryGirl.create(:specimen, :longitude_degrees => 80, :longitude_hemisphere => "W")
      specimen.longitude_printable.should eq("80° W")
    end

    it "should return blank if nothing filled" do
      specimen = FactoryGirl.create(:specimen)
      specimen.longitude_printable.should eq("")
    end

    it "should return blank if only hemisphere filled" do
      specimen = FactoryGirl.create(:specimen, :longitude_hemisphere => "W")
      specimen.longitude_printable.should eq("")
    end
  end

  describe "CSV Generation" do
    it "should include the correct fields from specimen" do
      coll     = FactoryGirl.create(:person, :initials =>"J.J.", :last_name => "Adams")
      attrs    = {:collector             => coll,
                  :collector_number      => "5678",
                  :collection_date_year  => 2010,
                  :collection_date_month => 3,
                  :collection_date_day   => 21,
                  :country               => "Australia",
                  :state                 => "New South Wales",
                  :botanical_division    =>"Central Tablelands",
                  :locality_description  => "Locality",
                  :altitude              => 123,
                  :point_data            =>"point",
                  :datum                 => "datum",
                  :topography            => "topo",
                  :aspect                => "asp",
                  :substrate             => "sub",
                  :vegetation            => "vege",
                  :frequency             => "freq",
                  :plant_description     => "plant desc",
                  :replicate_from        => "from",
                  :replicate_from_no     => "from no"}

      specimen = FactoryGirl.create(:specimen, attrs)

      csv      = specimen.add_csv_row
      csv.should eq [specimen.id, "J.J. Adams", "5678", "21 Mar 2010", "", "Australia", "New South Wales", "Central Tablelands",
                     "Locality", "", "", "123 m", "point", "datum", "topo", "asp", "sub", "vege", "freq", "plant desc", "", "", nil, "from", "from no"]
    end

    it "should include replicates comma separated" do
      specimen            = FactoryGirl.create(:specimen)
      bol                 = FactoryGirl.create(:herbarium, :code => "BOL")
      eiu                 = FactoryGirl.create(:herbarium, :code => "EIU")
      stud                = FactoryGirl.create(:herbarium, :code => "Stud")
      specimen.replicates = [eiu, bol, stud]

      csv                 = specimen.add_csv_row
      csv[20].should eq "BOL, EIU, Stud"
    end

    it "should include item info" do
      type_1   = FactoryGirl.create(:item_type, :name => 'Specimen sheet')
      type_2   = FactoryGirl.create(:item_type, :name => 'Fruit')
      type_3   = FactoryGirl.create(:item_type, :name => 'Phytochem')

      specimen = FactoryGirl.create(:specimen)
      specimen.items.create!(:item_type => type_1)
      specimen.items.create!(:item_type => type_3)
      specimen.items.create!(:item_type => type_2)
      specimen.items.create!(:item_type => type_2)
      specimen.items.create!(:item_type => type_1)

      csv = specimen.add_csv_row
      csv[21].should eq "Fruit, Phytochem, Specimen sheet"
    end

    it "should handle specimen status correctly" do
      specimen = FactoryGirl.create(:specimen, :status => "DeAcc")

      csv      = specimen.add_csv_row
      csv[22].should eq "DeAcc"
    end

    it "should include determination details if present" do
      person_1                = FactoryGirl.create(:person, :initials => "J.J.", :last_name => "Brown")
      person_2                = FactoryGirl.create(:person, :initials => "F.S.", :last_name => "Smith")
      specimen                = FactoryGirl.create(:specimen, :collector => person_1)
      attrs                   = {:determination_date_year  => 2010,
                                 :determination_date_month => 4,
                                 :determination_date_day   => 30,
                                 :determiner_herbarium     => FactoryGirl.create(:herbarium, :code =>"ABC"),
                                 :division                 => "Div",
                                 :class_name               => "Cls",
                                 :order_name               => "Ord",
                                 :family                   => "Fam",
                                 :family_uncertainty       => "Fam unc",
                                 :sub_family               => "Sub_fam",
                                 :sub_family_uncertainty   => "Sub_fam unc",
                                 :tribe                    => "Tr",
                                 :tribe_uncertainty        => "Tr unc",
                                 :genus                    => "Gen",
                                 :genus_uncertainty        => "Gen unc",
                                 :species                  => "spec",
                                 :species_authority        => "SpecAuth",
                                 :species_uncertainty      => "spec_un",
                                 :sub_species              => "sub_sp",
                                 :sub_species_authority    => "SubSpAuth",
                                 :subspecies_uncertainty   => "subspec_un",
                                 :variety                  => "var",
                                 :variety_authority        => "VarAuth",
                                 :variety_uncertainty      => "var_un",
                                 :form                     => "form",
                                 :form_authority           => "FormAuth",
                                 :form_uncertainty         => "form_un",
                                 :naturalised              => true,
                                 :determiners              => [person_1],
                                 :specimen                 => specimen}
      det                     = FactoryGirl.create(:determination, attrs)
      det.determiners         = [person_1, person_2]
      specimen.determinations = [det]

      csv                     = specimen.add_csv_row
      csv[25..51].should eq ["J.J. Brown, F.S. Smith", "30 Apr 2010", "ABC", "Div", "Cls", "Ord", "Fam", "Fam unc", "Sub_fam", "Sub_fam unc", "Tr", "Tr unc", "Gen", "Gen unc", "true", "spec", "SpecAuth", "spec_un",
                             "sub_sp", "SubSpAuth", "subspec_un", "var", "VarAuth", "var_un", "form", "FormAuth", "form_un"]
    end

    it "should include confirmation details if present" do
      person                  = FactoryGirl.create(:person, :initials => "J.J.", :last_name => "Bloggs")
      specimen                = FactoryGirl.create(:specimen, :collector => person)
      det                     = FactoryGirl.create(:determination, :determiners => [person])
      specimen.determinations = [det]
      attrs                   = {:determination           => det,
                                 :confirmation_date_year  => 2010,
                                 :confirmation_date_month => 5,
                                 :confirmation_date_day   => 3,
                                 :confirmer               => person,
                                 :confirmer_herbarium     => FactoryGirl.create(:herbarium, :code =>"DEF"),
                                 :specimen                => specimen}
      det.confirmation        = FactoryGirl.create(:confirmation, attrs)

      csv                     = specimen.add_csv_row
      csv[52..54].should eq ["J.J. Bloggs", "DEF", "3 May 2010"]
    end

    it "should handle blank determiner herbarium" do
      person                  = FactoryGirl.create(:person, :initials => "J.J", :last_name => "Bloggs")
      specimen                = FactoryGirl.create(:specimen, :collector => person)
      specimen.determinations = [FactoryGirl.create(:determination, :determiners => [person])]

      csv                     = specimen.add_csv_row
      csv[27].should eq nil
    end

    it "should handle blank confirmer herbarium" do
      person                  = FactoryGirl.create(:person, :initials => "J.J", :last_name => "Bloggs")
      specimen                = FactoryGirl.create(:specimen, :collector => person)
      det                     = FactoryGirl.create(:determination, :determiners => [person])
      specimen.determinations = [det]
      det.confirmation        = FactoryGirl.create(:confirmation, :specimen => specimen, :determination => det, :confirmer => person)

      csv                     = specimen.add_csv_row
      csv[53].should eq nil
    end

    it "should convert degrees to equivalent decimal values for longitude" do
      specimen = FactoryGirl.create(:specimen, :longitude_degrees => '12', :longitude_minutes => '23', :longitude_seconds => '6.5', :longitude_hemisphere => 'E')
      specimen.longitude_decimal_printable.should eq("12.38513888888889 E")
    end

    it "should convert degrees to equivalent decimal values for latitude" do
      specimen = FactoryGirl.create(:specimen, :latitude_degrees => '23', :latitude_minutes => '59', :latitude_seconds => '43.2', :latitude_hemisphere => 'S')
      specimen.latitude_decimal_printable.should eq("23.995333333333335 S")
    end

    it "should convert degrees correctly when only a degree is supplied" do
      specimen = FactoryGirl.create(:specimen, :latitude_degrees => '50', :latitude_minutes => '', :latitude_seconds => '', :latitude_hemisphere => 'N')
      specimen.latitude_decimal_printable.should eq("50.0 N")
    end

    it "should convert degrees correctly when only degrees and minutes are present" do
      specimen = FactoryGirl.create(:specimen, :latitude_degrees => '34', :latitude_minutes => '51', :latitude_seconds => '', :latitude_hemisphere => 'S')
      specimen.latitude_decimal_printable.should eq("34.85 S")
    end

    it "should convert degrees correctly when only minutes and seconds are present " do
      specimen = FactoryGirl.create(:specimen, :latitude_degrees => '', :latitude_minutes => '54', :latitude_seconds => '43.2', :latitude_hemisphere => 'S')
      specimen.latitude_decimal_printable.should eq("0.912 S")
    end
  end

  describe "zip file of images" do
    pending "should work"
  end
end
