require 'spec_helper'
# encoding: UTF-8

describe "SpecimenPdfFormatter" do

  before(:each) do
    @specimen = Factory(:specimen)
    @renderer = LabelFormatter.new(@specimen)
    @det_attrs = {:determiners => [Factory(:person, :first_name => "Steve", :last_name => "Jacks", :initials => "S.J.")] ,:determination_date_year => '2010', :family => 'Rose', :referenced => true}
  end

  describe "Accession number rendering" do
    it "should append NE to the specimen id" do
      @renderer.accession_number.should eq("NE #{@specimen.id}")
    end
  end

  describe "Family and subfamily rendering" do

    it "should output <Family Name> subfam. <Subfamily name> when both exist" do
      @specimen.determinations.create!(@det_attrs.merge({:family =>"Rose", :sub_family => 'Some sub family'}))
      @renderer.family_sub_family.should eq("Rose subfam. Some sub family")
    end

    it "should output family without subfam. when sub-family is not present" do
      @specimen.determinations.create!(@det_attrs.merge({:family => 'Rose'}))
      @renderer.family_sub_family.should eq("Rose")
    end

    it "should return an empty string when family is not present" do
      @specimen.determinations.create!(@det_attrs.merge({:family => ""}))
      @renderer.family_sub_family.should eq("")
    end
  end

  describe "Genus and species rendering" do
    it "should bold and italicise genus and species" do
      @specimen.determinations.create!(@det_attrs.merge({:genus =>"Rose", :species => 'aspecies', :species_authority => "my auth"}))
      @renderer.genus_species_and_authority.should eq("<b><i>Rose</i></b> <b><i>aspecies</i></b> my auth ")
    end

    it "should not italicise species if contains sp." do
      @specimen.determinations.create!(@det_attrs.merge({:genus =>"Rose", :species => 'sp. aspecies', :species_authority => "my auth"}))
      @renderer.genus_species_and_authority.should eq("<b><i>Rose</i></b> sp. aspecies my auth ")
    end

    it "should add uncertainty info to species" do
      @specimen.determinations.create!(@det_attrs.merge({:genus =>"Rose", :species => 'aspecies', :species_uncertainty => "sens. strict.", :species_authority => "my auth"}))
      @renderer.genus_species_and_authority.should eq("<b><i>Rose</i></b> <b><i>aspecies</i></b> my auth <i>s. str.</i>")
    end

    it "should not add uncertainty info to species if species blank" do
      @specimen.determinations.create!(@det_attrs.merge({:genus =>"Rose", :species => "", :species_uncertainty => "sens. strict.", :species_authority => "my auth"}))
      @renderer.genus_species_and_authority.should eq("<b><i>Rose</i></b> ")
    end

    it "should handle missing species" do
      @specimen.determinations.create!(@det_attrs.merge({:genus =>"Rose", :species => "", :species_authority => ""}))
      @renderer.genus_species_and_authority.should eq("<b><i>Rose</i></b> ")
    end

    it "should handle missing everything" do
      @specimen.determinations.create!(@det_attrs.merge({:genus =>"", :species => "", :species_authority => ""}))
      @renderer.genus_species_and_authority.should eq(" ")
    end

    it "should not print tribe name on the same line as genus and species" do
      @specimen.determinations.create!(@det_attrs.merge({:tribe => "A Tribe", :genus =>"Rose", :species => 'aspecies', :species_authority => "my auth"}))
      @renderer.genus_species_and_authority.should eq("<b><i>Rose</i></b> <b><i>aspecies</i></b> my auth ")
    end
  end

  describe "Subspecies rendering" do
    it "should bold and italicise subspecies" do
      @specimen.determinations.create!(@det_attrs.merge({:sub_species =>"rose", :sub_species_authority => "my auth"}))
      @renderer.subspecies_and_authority.should eq("subsp. <b><i>rose</i></b> my auth")
    end

    it "should not show authority if subspecies is same as species" do
      @specimen.determinations.create!(@det_attrs.merge({:species => "rose", :sub_species =>"rose", :sub_species_authority => "my auth"}))
      @renderer.subspecies_and_authority.should eq("subsp. <b><i>rose</i></b>")
    end

    it "should add uncertainty info to subspecies if present" do
      @specimen.determinations.create!(@det_attrs.merge({:sub_species =>"rose", :subspecies_uncertainty => "aff.", :sub_species_authority => "my auth"}))
      @renderer.subspecies_and_authority.should eq("subsp. <i>aff.</i> <b><i>rose</i></b> my auth")
    end

    it "should not add uncertainty info to subspecies if subspecies blank" do
      @specimen.determinations.create!(@det_attrs.merge({:sub_species => "", :subspecies_uncertainty => "sens. strict.", :sub_species_authority => "my auth"}))
      @renderer.subspecies_and_authority.should eq("")
    end

    it "should show nothing if subspecies missing" do
      @specimen.determinations.create!(@det_attrs.merge({:sub_species =>"", :sub_species_authority => "auth"}))
      @renderer.subspecies_and_authority.should eq("")
    end
  end

  describe "Variety rendering" do
    it "should bold and italicise variety" do
      @specimen.determinations.create!(@det_attrs.merge({:variety =>"rose", :variety_authority => "my auth"}))
      @renderer.variety_and_authority.should eq("var. <b><i>rose</i></b> my auth")
    end

    it "should add uncertainty info to variety if present" do
      @specimen.determinations.create!(@det_attrs.merge({:variety =>"rose", :variety_uncertainty => "aff.", :variety_authority => "my auth"}))
      @renderer.variety_and_authority.should eq("var. <i>aff.</i> <b><i>rose</i></b> my auth")
    end

    it "should not add uncertainty info to variety if variety blank" do
      @specimen.determinations.create!(@det_attrs.merge({:variety => "", :variety_uncertainty => "sens. strict.", :variety_authority => "my auth"}))
      @renderer.variety_and_authority.should eq("")
    end

    it "should show nothing if variety missing" do
      @specimen.determinations.create!(@det_attrs.merge({:variety =>"", :variety_authority => "auth"}))
      @renderer.variety_and_authority.should eq("")
    end
  end

  describe "Form rendering" do
    it "should bold and italicise form" do
      @specimen.determinations.create!(@det_attrs.merge({:form =>"rose", :form_authority => "my auth"}))
      @renderer.form_and_authority.should eq("f. <b><i>rose</i></b> my auth")
    end

    it "should add uncertainty info if present" do
      @specimen.determinations.create!(@det_attrs.merge({:form =>"rose", :form_uncertainty => "aff.", :form_authority => "my auth"}))
      @renderer.form_and_authority.should eq("f. <i>aff.</i> <b><i>rose</i></b> my auth")
    end

    it "should not add uncertainty info if form blank" do
      @specimen.determinations.create!(@det_attrs.merge({:form => "", :form_uncertainty => "sens. strict.", :form_authority => "my auth"}))
      @renderer.form_and_authority.should eq("")
    end

    it "should show nothing if form missing" do
      @specimen.determinations.create!(@det_attrs.merge({:form =>"", :form_authority => "auth"}))
      @renderer.form_and_authority.should eq("")
    end
  end

  describe "Frequency and plant description rendering" do
    it "should be separated by a full stop" do
      @specimen.update_attributes({:frequency => 'Occassionally', :plant_description => 'A plant description'})
      @renderer.frequency_plant_description.should eq("Occassionally. A plant description.")
    end
  end

  describe "showing [COUNTRY]: [State]: [Botanical Division]: [Locality Description]" do
    it "should be separated by colons and end in a full stop" do
      @specimen.update_attributes({:country => 'Australia', :state => 'NSW', :botanical_division => 'Bot div', :locality_description => 'Loc desc'} )
      @renderer.locality_botanical_division_locality_description.should eq("<b>AUSTRALIA</b>: NSW: Bot div: Loc desc.")
    end
  end

  describe "Datum and altitude rendering" do
    it "should render both correctly" do
      @specimen.update_attributes(:datum => 'EHS11')
      @renderer.datum_altitude.should eq("1555 m    EHS11")
    end
  end

  describe "Topography rendering " do
    it "should output topography. aspect. substrate. vegetation." do
      @specimen.update_attributes({:topography => 'Rough', :aspect => 'W', :substrate => 'Very flat', :vegetation => 'Dense and green'})
      @renderer.topography_aspect_substrate_vegetation.should eq("Rough. W aspect. Very flat. Dense and green.")
    end
    it "should skip blank elements topography. aspect. substrate. vegetation." do
      @specimen.update_attributes({:topography => 'Rough', :aspect => '', :substrate => '', :vegetation => 'Dense and green'})
      @renderer.topography_aspect_substrate_vegetation.should eq("Rough. Dense and green.")
      @specimen.update_attributes({:topography => '', :aspect => 'W', :substrate => 'Very flat', :vegetation => ''})
      @renderer.topography_aspect_substrate_vegetation.should eq("W aspect. Very flat. ")
    end
  end
  
  describe "Collector and number rendering" do
    it "should show collector display name and number in bold" do
      person = Factory(:person, :initials => "F.B.", :last_name => "Argus")
      @specimen.update_attributes(:collector => person, :collector_number => '1234')
      @renderer.collector.should eq("Coll.: <b>F.B. Argus 1234</b>")
    end
  end

  describe "Collection date rendering" do
    it "should show the collection date" do
      @specimen.update_attributes(:collection_date_year => '2010', :collection_date_month => '12', :collection_date_day => '8')
      @renderer.collection_date.should eq("8 Dec. 2010")
    end
  end

  describe "showing replicates associated with the specimen" do
    it "should show them in alphabetical order, comma separated, prefixed by Reps: with a full stop at the end" do
      bol = Factory(:herbarium, :code => "BOL")
      eiu = Factory(:herbarium, :code => "EIU")
      sss = Factory(:herbarium, :code => "SSS")
      @specimen.replicates = [eiu, bol, sss]
      @renderer.replicates.should eq("Reps: BOL, EIU, SSS.")
    end

    it "should show prefix as Rep.: if there's only one" do
      bol = Factory(:herbarium, :code => "BOL")
      @specimen.replicates = [bol]
      @renderer.replicates.should eq("Rep.: BOL.")
    end

    it "should just show prefix of Rep.: if no replicates are present" do
      @renderer.replicates.should eq("Rep.:")
    end

    it "should put Stud. at the end if present and omit the extra full stop" do
      person = Factory(:person, :initials => "A.B", :last_name => "See")
      specimen            = Factory(:specimen, :collector => person)
      zol                 = Factory(:herbarium, :code => "ZOL")
      eiu                 = Factory(:herbarium, :code => "EIU")
      stud                = Factory(:herbarium, :code => "Stud.")
      @specimen.replicates = [stud, zol, eiu]
      @renderer.replicates.should eq("Reps: EIU, ZOL, Stud.")
    end

    it "should put omit the extra full stop when only Stud." do
      person = Factory(:person, :initials => "A.B", :last_name => "See")
      specimen            = Factory(:specimen, :collector => person)
      stud                = Factory(:herbarium, :code => "Stud.")
      @specimen.replicates = [stud]
      @renderer.replicates.should eq("Rep.: Stud.")
    end
  end

  describe "showing items associated with the specimen" do
    it "should show them in alphabetical order, comma separated, duplicates removed and without Specimen sheet" do
      type_1 = Factory(:item_type, :name => ItemType::TYPE_SPECIMEN_SHEET)
      type_2 = Factory(:item_type, :name => 'Fruit')
      type_3 = Factory(:item_type, :name => 'Phytochem')

      @specimen.items.create!(:item_type => type_1)
      @specimen.items.create!(:item_type => type_2)
      @specimen.items.create!(:item_type => type_3)
      @specimen.items.create!(:item_type => type_2)
      @specimen.items.create!(:item_type => type_1)

      @renderer.items.should eq("Fruit, Phytochem.")
    end
  end

  describe "determiners rendering" do
    it "should show each determiner comma separated" do
      herbarium1 = Factory(:herbarium, :code => "ABC")
      herbarium2 = Factory(:herbarium, :code => "DEF")
      det1 = Factory(:person, :initials => 'B.B.', :last_name => "Brown", :herbarium => herbarium1)
      det2 = Factory(:person, :initials => 'A.B.', :last_name => "Black", :herbarium => herbarium2)
      det3 = Factory(:person, :initials => 'H.E.', :last_name => "Bart", :herbarium => herbarium1)
      @specimen.determinations.create!(@det_attrs.merge({:family =>"Rose", :sub_family => 'Some sub family'})) 
      @specimen.determinations[0].determiners = [det1, det2, det3]
      @renderer.determiners.should eq("Det.: B.B. Brown (ABC), A.B. Black (DEF), H.E. Bart (ABC)")
    end

    it "should show one determiner if only one is present" do
      herbarium1 = Factory(:herbarium, :code => "ABC")
      det1 = Factory(:person, :initials => 'B.B.', :last_name => "Brown", :herbarium => herbarium1)
      @specimen.determinations.create!(@det_attrs.merge({:family =>"Rose", :sub_family => 'Some sub family'}))
      @specimen.determinations[0].determiners = [det1]
      @renderer.determiners.should eq("Det.: B.B. Brown (ABC)")
    end

    it "should not show the determiner and date if the collector and collection date match the determiner and determination date" do
      collector = Factory(:person, :initials => 'A.B.', :last_name => "Black")
      @specimen.update_attributes(:collection_date_year => '2010', :collection_date_month => '12', :collection_date_day => '12', :collector => collector)  
      herbarium1 = Factory(:herbarium, :code => "ABC")
      herbarium2 = Factory(:herbarium, :code => "DEF")
      det1 = Factory(:person, :initials => 'B.B.', :last_name => "Brown", :herbarium => herbarium1)
      det3 = Factory(:person, :initials => 'H.E.', :last_name => "Bart", :herbarium => herbarium1)
      @specimen.determinations.create!(@det_attrs.merge({:family =>"Rose", :sub_family => 'Some sub family', :determination_date_year => '2010', :determination_date_month => '12', :determination_date_day => '12'}))
      @specimen.determinations[0].determiners = [det1, collector, det3]
      @renderer.determiners.should eq("Det.: B.B. Brown (ABC), H.E. Bart (ABC)")
      @renderer.determination_date.should eq("")
    end
  end
  
  describe "Determination date rendering" do
    it "should show the determination date" do
      @specimen.determinations.create!(@det_attrs.merge({ :determination_date_year => '2010', :determination_date_month => '12', :determination_date_day => '12' }))
      @renderer.determination_date.should eq("12 Dec. 2010")
    end
  end

end