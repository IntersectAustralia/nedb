require 'spec_helper'

describe Species do
  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:genus) }
    it { should validate_presence_of(:authority) }

    it "should reject duplicate combination of genus+name" do
      Species.create!({:genus => "Abc", :name => "def", :authority => "auth1"})
      duplicate = Species.new({:genus => "Abc", :name => "def", :authority => "auth2"})
      duplicate.should_not be_valid
    end

    it "should reject duplicate combination of genus+name ignoring case" do
      Species.create!({:genus => "Abc", :name => "def", :authority => "auth1"})
      duplicate = Species.new({:genus => "Abc", :name => "dEf", :authority => "auth2"})
      duplicate.should_not be_valid
    end

    it "should allow duplicate genus with different name" do
      Species.create!({:genus => "Abc", :name => "def", :authority => "auth1"})
      duplicate = Species.new({:genus => "Abc", :name => "xyz", :authority => "auth1"})
      duplicate.should be_valid
    end

    it "should allow duplicate name with different genus" do
      Species.create!({:genus => "Abc", :name => "def", :authority => "auth1"})
      duplicate = Species.new({:genus => "Bcd", :name => "def", :authority => "auth1"})
      duplicate.should be_valid
    end

  end

  describe "Find by name and genus" do
    before do
      Factory(:species, :name => "Bear", :genus => "Ursus")
      Factory(:species, :name => "abc", :genus => "Ursus")
      Factory(:species, :name => "bear", :genus => "Abc")
    end
    it "should return the species if there's a match" do
      Species.find_by_name_and_genus("Bear", "Ursus").name.should eq "Bear"
    end
    it "should match case" do
      Species.find_by_name_and_genus("Bear", "Ursus").name.should eq "Bear"
      Species.find_by_name_and_genus("bear", "Ursus").should be_nil
      Species.find_by_name_and_genus("bear", "Abc").name.should eq "bear"
      Species.find_by_name_and_genus("Bear", "Abc").should be_nil
    end
    it "should convert the input genus to titlecase before attempting to search" do
      Species.find_by_name_and_genus("Bear", "urSus").name.should eq "Bear"
    end
    it "should return nil if no match" do
      Species.find_by_name_and_genus("bear", "zz").should be_nil
      Species.find_by_name_and_genus("zz", "Ursus").should be_nil
      Species.find_by_name_and_genus("zz", "zz").should be_nil
    end
  end

  describe "Autocomplete search " do
    before do
      Factory(:species, :genus => "Bear", :division => "D1", :class_name => "C1", :order_name => "O1", :family => "F1", :sub_family => "Sub1", :tribe => "Tr1")
      Factory(:species, :genus => "Bear", :division => "D1", :class_name => "C1", :order_name => "O1", :family => "F1", :sub_family => "Sub1", :tribe => "Tr1")
      Factory(:species, :genus => "Cat", :division => "D2", :class_name => "C2", :order_name => "O2", :family => "F2", :sub_family => "SUB2", :tribe => "Tr2")
      Factory(:species, :genus => "Chicken", :division => "D1", :class_name => "C1", :order_name => "O1", :family => "F1", :sub_family => "Sub1", :tribe => "Tr1")
      Factory(:species, :genus => "Cheetah", :division => "D1", :class_name => "C1", :order_name => "O1", :family => "F1", :sub_family => "Sub1", :tribe => "Tr1")
    end
    describe "Genus" do
      it "should return matches that start with the same letters" do
        Species.autocomplete_plant_name("genus", "C").collect {|s| s.genus }.should eq ["Cat", "Cheetah", "Chicken"]
      end
      it "should return matches regardless of case of search term" do
        Species.autocomplete_plant_name("genus", "cH").collect {|s| s.genus }.should eq ["Cheetah", "Chicken"]
      end
      it "should return only distinct matches" do
        Species.autocomplete_plant_name("genus", "be").collect {|s| s.genus }.should eq ["Bear"]
      end
    end

    describe "Other fields" do
      it "should work on division" do
        Species.autocomplete_plant_name("division", "D1").collect {|s| s.division }.should eq ["D1"]
      end
      it "should work on class" do
        Species.autocomplete_plant_name("class_name", "C1").collect {|s| s.class_name }.should eq ["C1"]
      end
      it "should work on order" do
        Species.autocomplete_plant_name("order_name", "O1").collect {|s| s.order_name }.should eq ["O1"]
      end
      it "should work on family" do
        Species.autocomplete_plant_name("family", "F1").collect {|s| s.family }.should eq ["F1"]
      end
      it "should work on sub family" do
        Species.autocomplete_plant_name("sub_family", "S").collect {|s| s.sub_family }.should eq ["Sub1", "Sub2"]
      end
      it "should work on tribe" do
        Species.autocomplete_plant_name("tribe", "T").collect {|s| s.tribe }.should eq ["Tr1", "Tr2"]
      end
    end

  end

  describe "Autocomplete search on name" do
    before do
      Factory(:species, :name => "bear")
      Factory(:species, :name => "bear")
      Factory(:species, :name => "cat")
      Factory(:species, :name => "chicken")
      Factory(:species, :name => "cheetah")
    end
    it "should return matches that start with the same letters" do
      Species.autocomplete_plant_name("name", "c").collect {|s| s.name }.should eq ["cat", "cheetah", "chicken"]
    end
    it "should return matches regardless of case of search term" do
      Species.autocomplete_plant_name("name", "CH").collect {|s| s.name }.should eq ["cheetah", "chicken"]
    end
    it "should return only distinct matches" do
      Species.autocomplete_plant_name("name", "be").collect {|s| s.name }.should eq ["bear"]
    end
  end

  describe "Autocomplete search on name with genus" do
    before do
      Factory(:species, :name => "bear", :genus => "Abc")
      Factory(:species, :name => "bear", :genus => "Def")
      Factory(:species, :name => "cat", :genus => "Abc")
      Factory(:species, :name => "chicken", :genus => "Abc")
      Factory(:species, :name => "cheetah", :genus => "Abc")
      Factory(:species, :name => "chook", :genus => "Def")
    end
    it "should return matches that start with the same letters" do
      Species.autocomplete_name_with_genus("Abc", "c").collect {|s| s.name }.should eq ["cat", "cheetah", "chicken"]
    end
    it "should return matches regardless of case of search term" do
      Species.autocomplete_name_with_genus("Abc", "CH").collect {|s| s.name }.should eq ["cheetah", "chicken"]
    end
    it "should return only distinct matches" do
      Species.autocomplete_name_with_genus("Abc", "be").collect {|s| s.name }.should eq ["bear"]
    end
  end

  describe "Free text search" do
    before do
      Factory(:species, :name => "bear", :genus => "Ursus")
      Factory(:species, :name => "abc", :genus => "Ursus")
      Factory(:species, :name => "bear", :genus => "Abc")
    end
    it "should return the species if the species name matches" do
      Species.free_text_search("bear").length.should eq(2)
    end
    it "should return the species if the species name partially matches" do
      Species.free_text_search("ea").length.should eq(2)
    end
    it "should return the species if the species name matches ignoring case" do
      Species.free_text_search("BE").length.should eq(2)
    end
    it "should return the species if the genus matches" do
      Species.free_text_search("Ursus").length.should eq(2)
    end
    it "should return the species if the genus partially matches" do
      Species.free_text_search("sus").length.should eq(2)
    end
    it "should return the species if the genus matches ignoring case" do
      Species.free_text_search("RS").length.should eq(2)
    end
  end

  describe "Search in field" do
    before do
      Factory(:species, :division => "D1", :class_name => "C1", :order_name => "O1", :family => "", :sub_family => "", :tribe => "", :genus => "G1", :name => "bear", :authority => "auth")
      Factory(:species, :division => "D1", :class_name => "C2", :order_name => "O2", :family => "", :sub_family => "", :tribe => "", :genus => "G2", :name => "abc", :authority => "auth")
      Factory(:species, :division => "D2", :class_name => "C2", :order_name => "O3", :family => "", :sub_family => "", :tribe => "", :genus => "G3", :name => "bear", :authority => "auth")
      Factory(:species, :division => "D3", :class_name => "C3", :order_name => "O4", :family => "", :sub_family => "", :tribe => "", :genus => "G3", :name => "def", :authority => "auth")
      Factory(:species, :division => "D3", :class_name => "C4", :order_name => "O5", :family => "", :sub_family => "", :tribe => "", :genus => "G3", :name => "o'shanesii", :authority => "auth")
    end

    it "should be able to search on division" do
      result = Species.search_in_field("division", "d1")
      result.length.should eq(1)
      result[0].division.should eq("D1")
    end

    it "should be able to search on class" do
      result = Species.search_in_field("class_name", "C2")
      result.length.should eq(2)
      result[0].division.should eq("D1")
      result[0].class_name.should eq("C2")
      result[1].division.should eq("D2")
      result[1].class_name.should eq("C2")
    end

    #TODO: more tests for other fields

    it "should handle single quotes in search string" do
      result = Species.search_in_field("name", "o'sh")
      result.length.should eq(1)
      result[0].name.should eq("o'shanesii")
    end

    it "should return partial matches in the requested field regardless of case and position" do
      result = Species.search_in_field("name", "B")
      result.length.should eq(3)
      result[0].name.should eq("bear")
      result[1].name.should eq("abc")
      result[2].name.should eq("bear")
    end
  end

  describe "Forcing correct case" do
    it "should set case correctly before save" do
      species = Species.create!(:division => "diV",
                                :class_name => "cLasS",
                                :order_name => "oRdER",
                                :family => "fAM",
                                :sub_family => "sub FAMILY",
                                :tribe => "tribe",
                                :genus => "gENUS abc",
                                :name => "NAmE",
                                :authority => "Auth. FBC.")
      #reload from db
      species = Species.find(species.id)

      species.division.should eq("Div")
      species.class_name.should eq("Class")
      species.order_name.should eq("Order")
      species.family.should eq("Fam")
      species.sub_family.should eq("Sub family")
      species.tribe.should eq("Tribe")
      species.genus.should eq("Genus abc")
      species.name.should eq("NAmE") # we leave name alone
      species.authority.should eq("Auth. FBC.")
    end

    it "should handle empty attributes" do
      species = Species.create!(:division => "",
                                :class_name => "",
                                :order_name => "",
                                :family => "",
                                :sub_family => "",
                                :tribe => "",
                                :genus => "gENUS abc",
                                :name => "NAmE BlaH",
                                :authority => "asdf")
      #reload from db
      species = Species.find(species.id)

      species.division.should eq("")
      species.class_name.should eq("")
      species.order_name.should eq("")
      species.family.should eq("")
      species.sub_family.should eq("")
      species.tribe.should eq("")
      species.genus.should eq("Genus abc")
      species.name.should eq("NAmE BlaH") # we leave name alone
      species.authority.should eq("asdf")
    end

    it "should handle missing attributes" do
      species = Species.create!(:genus => "gENUS abc",
                                :name => "NAmE BlaH",
                                :authority => "asdf")
      #reload from db
      species = Species.find(species.id)

      species.division.should be_nil
      species.class_name.should be_nil
      species.order_name.should be_nil
      species.family.should be_nil
      species.sub_family.should be_nil
      species.tribe.should be_nil
      species.genus.should eq("Genus abc")
      species.name.should eq("NAmE BlaH")  # we leave name alone
      species.authority.should eq("asdf")
    end
  end


end
