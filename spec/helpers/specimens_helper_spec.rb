require 'spec_helper'

describe SpecimensHelper do

  before(:each) do
    @person = Factory(:person)
    @specimen = Factory(:specimen, :collector => @person)
  end

  describe "determination short name is correct" do
    it "should include tribe, genus, species and authority" do
      determination = Factory(:determination,
                              :determiners => [@person],
                              :specimen => @specimen,
                              :tribe => 'tribe',
                              :genus => 'genus',
                              :species => 'species',
                              :species_authority => 'authority',
                              :sub_species => 'sub_species',
                              :sub_species_authority => 'sub_species_authority',
                              :variety => 'variety',
                              :variety_authority => 'variety_authority',
                              :form => 'form',
                              :form_authority => 'form_authority')

      expected_result = "tribe <b><i>genus</i></b> <b><i>species</i></b> authority "
      helper.determination_short_name(determination).should eq(expected_result)
    end

    it "Should not italicise species if it contains sp." do
      determination = Factory(:determination,
                              :determiners => [@person],
                              :specimen => @specimen,
                              :tribe => 'tribe',
                              :genus => 'genus',
                              :species => 'sp. blah',
                              :species_authority => 'authority',
                              :sub_species => 'sub_species',
                              :sub_species_authority => 'sub_species_authority',
                              :variety => 'variety',
                              :variety_authority => 'variety_authority',
                              :form => 'form',
                              :form_authority => 'form_authority')

      expected_result = "tribe <b><i>genus</i></b> sp. blah authority "
      helper.determination_short_name(determination).should eq(expected_result)
    end

    it "Should handle missing species" do
      determination = Factory(:determination,
                              :determiners => [@person],
                              :specimen => @specimen,
                              :tribe => 'tribe',
                              :genus => 'genus')

      expected_result = "tribe <b><i>genus</i></b> "
      helper.determination_short_name(determination).should eq(expected_result)
    end
  end
  
end

