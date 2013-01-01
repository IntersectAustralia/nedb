require 'spec_helper'

describe Determination do

  describe "Associations" do
    it { should belong_to(:specimen) }
    it { should have_and_belong_to_many(:determiners) }
    it { should belong_to(:determiner_herbarium) }
  end

  describe "Validations" do
    it { should validate_presence_of(:specimen) }
    it { should validate_presence_of(:determiners) }

    describe "should test each date field individually" do
      before(:each) do
        @defaults = {:specimen => Specimen.new, :determiners => [Factory(:person, :last_name => "John", :last_name => "Apple")], :legacy => false}
      end
      it "should reject a totally empty determination date" do
        d = Determination.new @defaults
        d.should_not be_valid
      end
      it "should not accept a determination date with only the day filled in" do
        d = Determination.new({:determination_date_day => 31}.merge(@defaults))
        d.should_not be_valid
      end
      it "should not accept a determination date with only the month filled in" do
        d = Determination.new({:determination_date_month => 12}.merge(@defaults))
        d.should_not be_valid
      end
      it "should accept a determination date with only the year filled in" do
        d = Determination.new({:determination_date_year => 1}.merge(@defaults))
        d.should be_valid
      end
      it "should accept a determination date with the year and month filled in" do
        d = Determination.new({:determination_date_year => 2322, :determination_date_month => 10}.merge(@defaults))
        d.should be_valid
      end
      it "should accept a totally empty determination date if determination is legacy" do
        d = Determination.new(:specimen => Specimen.new, :determiners => [Factory(:person, :last_name => "John", :last_name => "Apple")], :legacy => true)
        d.should be_valid
      end
      it "should not accept a determination date with only the day filled in if determination is legacy" do
        d = Determination.new({:determination_date_day => 31, :legacy => true}.merge(@defaults))
        d.should_not be_valid
      end
      it "should not accept a determination date with only the month filled in if determination is legacy" do
        d = Determination.new({:determination_date_month => 12, :legacy => true}.merge(@defaults))
        d.should_not be_valid
      end
      it "should accept a determination date with only the year filled in if determination is legacy" do
        d = Determination.new({:determination_date_year => 1, :legacy => true}.merge(@defaults))
        d.should be_valid
      end
      it "should accept a determination date with the year and month filled in if determination is legacy" do
        d = Determination.new({:determination_date_year => 2322, :determination_date_month => 10, :legacy => true}.merge(@defaults))
        d.should be_valid
      end
    end
  end

  describe "CSV" do
    before(:each) do
      @pete = Person.new :first_name => 'Pete', :last_name => 'Po', :initials => 'P.'
      @jack = Person.new :first_name => 'Jack', :last_name => 'Ja', :initials => 'J.'
    end
    it "should comma-separate determiners" do
      d = Determination.new :determiners => [@pete, @jack]
      d.determiners_csv.should eq 'P. Po, J. Ja'
    end
    it "should not have a comma with only one name" do
      d = Determination.new :determiners => [@jack]
      d.determiners_csv.should eq 'J. Ja'
    end
  end

  describe "sorting by latest first" do
    before(:each) do
      person = Factory(:person, :last_name => "Pie", :initials => "A. Pie")
      specimen = Factory(:specimen, :collector => person)
      @d2000_12_10 = Determination.new :determination_date_year => 2000, :determination_date_month => 12, :determination_date_day => 10, :determiners => [person], :specimen => specimen
      @d2000_10_12 = Determination.new :determination_date_year => 2000, :determination_date_month => 10, :determination_date_day => 12, :determiners => [person], :specimen => specimen
      @d2000       = Determination.new :determination_date_year => 2000, :determiners => [person], :specimen => specimen
      @d2000_12    = Determination.new :determination_date_year => 2000, :determination_date_month => 12, :determiners => [person], :specimen => specimen
      @d19         = Determination.new :determination_date_year => 19, :determiners => [person], :specimen => specimen
    end
    it "should sort by date" do
      dets = [@d2000_10_12, @d2000_12_10].sort!
      dets.first.should eq @d2000_12_10
      dets.last.should eq @d2000_10_12
    end
    it "should sort partial dates" do
      dets = [@d2000, @d2000_12_10].sort!
      dets.first.should eq @d2000_12_10
      dets.last.should eq @d2000
    end
    it "should sort more complete dates before less complete dates" do
      dets = [@d2000, @d2000_12].sort!
      dets.first.should eq @d2000_12
      dets.last.should eq @d2000
    end
    it "should sort lots of dates properly" do
      dets = [@d2000_12, @d19, @d2000_10_12, @d2000, @d2000_12_10].sort!
      dets.first.should eq @d2000_12_10
      dets.second.should eq @d2000_12
      dets.third.should eq @d2000_10_12
      dets.fourth.should eq @d2000
      dets.fifth.should eq @d19
    end
  end

  describe "Get determiners for labels" do
    person = Factory(:person, :initials => "A.A.", :last_name => "Bee")
    before(:each) do
      @det_attrs = {:determiners => [person], :determination_date_year => '2010', :determination_date_month => '12', :determination_date_day => '12', :family => 'Rose'}
    end
    it "should return the correct string" do
      specimen   = Factory(:specimen, :collector => person)
      herbarium1 = Factory(:herbarium, :code => "ABC")
      herbarium2 = Factory(:herbarium, :code => "DEF")
      det1       = Factory(:person, :initials => 'B.B.', :last_name => 'Brown', :herbarium => herbarium1)
      det2       = Factory(:person, :initials => 'A.B.', :last_name => 'Black', :herbarium => herbarium2)
      det3       = Factory(:person, :initials => 'H.E.', :last_name => 'Bart', :herbarium => herbarium1)
      specimen.determinations.create!(@det_attrs)
      specimen.determinations[0].determiners = [det1, det2, det3]
      specimen.current_determination.determiners_name_herbarium_id('someone', false).join(", ").should eq("B.B. Brown (ABC), A.B. Black (DEF), H.E. Bart (ABC)")
    end

    it "should handle the case where no herbarium set" do
      specimen   = Factory(:specimen, :collector => person)
      herbarium1 = Factory(:herbarium, :code => "ABC")
      det1       = Factory(:person, :initials => 'B.B.', :last_name => 'Brown', :herbarium => herbarium1)
      det2       = Person.create!(:first_name => 'Ariel', :last_name => ' Black', :initials => 'A.B.')
      det3       = Factory(:person, :initials => 'H.E.', :last_name => 'Bart', :herbarium => herbarium1)
      specimen.determinations.create!(@det_attrs)
      specimen.determinations[0].determiners = [det1, det2, det3]
      specimen.current_determination.determiners_name_herbarium_id('someone', false).join(", ").should eq("B.B. Brown (ABC), A.B. Black, H.E. Bart (ABC)")
    end
  end

  describe "Set determining at level" do
    before(:each) do
      @person = Factory(:person, :initials => "A.A.", :last_name => "Cake")
    end

    it "should blank out all values at lower levels" do
      det = Factory(:determination,
                    :determiners            => [@person],
                    :family                 => "Fam",
                    :sub_family             => "Subf",
                    :tribe                  => "Tribe",
                    :genus                  => "Gen",
                    :species                => "blah")
      det.set_determining_at_level("family")
      det.sub_family.should be_blank
      det.tribe.should be_blank
      det.genus.should be_blank
      det.species.should be_blank
    end

    it "should blank out all species/subspecies/variety/form info if determining above species" do
      det = Factory(:determination,
                    :determiners            => [@person],
                    :family                 => "Fam",
                    :sub_family             => "Subf",
                    :genus                  => "Gen",
                    :species                => "spec",
                    :species_authority      => "sa",
                    :species_uncertainty    => "unc",
                    :sub_species            => "subsp",
                    :sub_species_authority  => "subsp a",
                    :subspecies_uncertainty => "unc",
                    :variety                => "var",
                    :variety_authority      => "var a",
                    :variety_uncertainty    => "unc",
                    :form                   => "form",
                    :form_authority         => "form a",
                    :form_uncertainty       => "unc")
      det.set_determining_at_level("genus")
      det.genus.should eq("Gen")
      det.species.should be_blank
      det.species_authority.should be_blank
      det.species_uncertainty.should be_blank
      det.sub_species.should be_blank
      det.sub_species_authority.should be_blank
      det.subspecies_uncertainty.should be_blank
      det.variety.should be_blank
      det.variety_authority.should be_blank
      det.variety_uncertainty.should be_blank
      det.form.should be_blank
      det.form_authority.should be_blank
      det.form_uncertainty.should be_blank
    end

    it "should blank out higher uncertainties when switching to a more specific determination" do
      det = Factory(:determination,
                    :determiners => [@person],
                    :family => "Fam",
                    :family_uncertainty => "unc",
                    :sub_family => "Subf",
                    :sub_family_uncertainty => "unc",
                    :tribe => "Tribe",
                    :tribe_uncertainty => "unc",
                    :genus => "Gen",
                    :genus_uncertainty => "unc")
      det.set_determining_at_level("name")
      det.family_uncertainty.should be_blank
      det.sub_family_uncertainty.should be_blank
      det.tribe_uncertainty.should be_blank
      det.genus_uncertainty.should be_blank
    end

    it "should not save changes until save called" do
      det = Factory(:determination,
                    :determiners => [@person],
                    :family => "Fam",
                    :sub_family => "Subf",
                    :tribe => "Tribe",
                    :genus => "Gen",
                    :species => "blah")
      det.set_determining_at_level("family")
      det.sub_family.should be_blank
      det.tribe.should be_blank
      det.genus.should be_blank
      det.species.should be_blank
      det.reload
      det.sub_family.should_not be_blank
      det.tribe.should_not be_blank
      det.genus.should_not be_blank
      det.species.should_not be_blank
    end
  end


  describe "Get current level should work out what level the determination is currently at" do
    before(:each) do
      @person = Factory(:person, :initials => "A.A.", :last_name => "Cake")
    end

    it "should return name if species is populated" do
      det = Factory(:determination, :determiners => [@person], :species => "blah")
      det.get_current_level.should eq("name")
    end
    it "should return genus if species blank but name is populated" do
      det = Factory(:determination, :determiners => [@person], :species => "", :genus => "blah")
      det.get_current_level.should eq("genus")
    end
    it "should return division if only division populated" do
      det = Factory(:determination, :determiners => [@person], :division => "blah")
      det.get_current_level.should eq("division")
    end
  end

  describe "Get fields to include for level" do
    it "should return the correct subset of fields" do
      Determination.get_fields_to_include_for_level("division").should eq(["division"])
      Determination.get_fields_to_include_for_level("class_name").should eq(["division", "class_name"])
      Determination.get_fields_to_include_for_level("order_name").should eq(["division", "class_name", "order_name"])
      Determination.get_fields_to_include_for_level("family").should eq(["division", "class_name", "order_name", "family"])
      Determination.get_fields_to_include_for_level("sub_family").should eq(["division", "class_name", "order_name", "family", "sub_family"])
      Determination.get_fields_to_include_for_level("tribe").should eq(["division", "class_name", "order_name", "family", "sub_family", "tribe"])
      Determination.get_fields_to_include_for_level("genus").should eq(["division", "class_name", "order_name", "family", "sub_family", "tribe", "genus"])
      Determination.get_fields_to_include_for_level("name").should eq(["division", "class_name", "order_name", "family", "sub_family", "tribe", "genus", "name"])
    end
  end

  describe "Get first and second infraspecific details for HISPID" do
    before(:each) do
      @person = Factory(:person, :initials => "A.A.", :last_name => "Cake")
    end

    it "should return nil if no supspecies, variety or form" do
      det = Factory(:determination,
                    :determiners => [@person],
                    :sub_species => "",
                    :variety => "",
                    :form => "")
      det.first_infraspecific_rank.should be_nil
      det.first_infraspecific_name.should be_nil
      det.first_infraspecific_authority.should be_nil
      det.second_infraspecific_rank.should be_nil
      det.second_infraspecific_name.should be_nil
      det.second_infraspecific_authority.should be_nil
    end

    describe "should return the highest level first and second highest second" do
      before(:each) do
        @person = Factory(:person, :initials => "A.A.", :last_name => "Lie")
      end

      it "has all 3 populated" do
        det = Factory(:determination,
                      :determiners => [@person],
                      :sub_species => "su",
                      :variety => "var",
                      :form => "fo",
                      :sub_species_authority => "su auth",
                      :variety_authority => "v auth",
                      :form_authority => "f auth")
        det.first_infraspecific_rank.should eq("subsp.")
        det.first_infraspecific_name.should eq("su")
        det.first_infraspecific_authority.should eq("su auth")
        det.second_infraspecific_rank.should eq("var.")
        det.second_infraspecific_name.should eq("var")
        det.second_infraspecific_authority.should eq("v auth")
      end

      it "has subsp and variety populated" do
        det = Factory(:determination,
                      :determiners => [@person],
                      :sub_species => "su",
                      :variety => "var",
                      :form => "",
                      :sub_species_authority => "su auth",
                      :variety_authority => "v auth",
                      :form_authority => "")
        det.first_infraspecific_rank.should eq("subsp.")
        det.first_infraspecific_name.should eq("su")
        det.first_infraspecific_authority.should eq("su auth")
        det.second_infraspecific_rank.should eq("var.")
        det.second_infraspecific_name.should eq("var")
        det.second_infraspecific_authority.should eq("v auth")
      end

      it "has subsp and form populated" do
        det = Factory(:determination,
                      :determiners => [@person],
                      :sub_species => "su",
                      :variety => "",
                      :form => "fo",
                      :sub_species_authority => "su auth",
                      :variety_authority => "",
                      :form_authority => "f auth")
        det.first_infraspecific_rank.should eq("subsp.")
        det.first_infraspecific_name.should eq("su")
        det.first_infraspecific_authority.should eq("su auth")
        det.second_infraspecific_rank.should eq("f.")
        det.second_infraspecific_name.should eq("fo")
        det.second_infraspecific_authority.should eq("f auth")
      end

      it "has subsp only" do
        det = Factory(:determination,
                      :determiners => [@person],
                      :sub_species => "su",
                      :variety => "",
                      :form => "",
                      :sub_species_authority => "su auth",
                      :variety_authority => "",
                      :form_authority => "")
        det.first_infraspecific_rank.should eq("subsp.")
        det.first_infraspecific_name.should eq("su")
        det.first_infraspecific_authority.should eq("su auth")
        det.second_infraspecific_rank.should be_nil
        det.second_infraspecific_name.should be_nil
        det.second_infraspecific_authority.should be_nil
      end

      it "has var and form" do
        det = Factory(:determination,
                      :determiners => [@person],
                      :sub_species => "",
                      :variety => "var",
                      :form => "fo",
                      :sub_species_authority => "",
                      :variety_authority => "v auth",
                      :form_authority => "f auth")
        det.first_infraspecific_rank.should eq("var.")
        det.first_infraspecific_name.should eq("var")
        det.first_infraspecific_authority.should eq("v auth")
        det.second_infraspecific_rank.should eq("f.")
        det.second_infraspecific_name.should eq("fo")
        det.second_infraspecific_authority.should eq("f auth")
      end

      it "has var only" do
        det = Factory(:determination,
                      :determiners => [@person],
                      :sub_species => "",
                      :variety => "var",
                      :form => "",
                      :sub_species_authority => "",
                      :variety_authority => "v auth",
                      :form_authority => "")
        det.first_infraspecific_rank.should eq("var.")
        det.first_infraspecific_name.should eq("var")
        det.first_infraspecific_authority.should eq("v auth")
        det.second_infraspecific_rank.should be_nil
        det.second_infraspecific_name.should be_nil
        det.second_infraspecific_authority.should be_nil
      end

      it "has form only" do
        det = Factory(:determination,
                      :determiners => [@person],
                      :sub_species => "",
                      :variety => "",
                      :form => "fo",
                      :sub_species_authority => "",
                      :variety_authority => "",
                      :form_authority => "f auth")
        det.first_infraspecific_rank.should eq("f.")
        det.first_infraspecific_name.should eq("fo")
        det.first_infraspecific_authority.should eq("f auth")
        det.second_infraspecific_rank.should be_nil
        det.second_infraspecific_name.should be_nil
        det.second_infraspecific_authority.should be_nil
      end

    end
  end
end
