require 'spec_helper'

describe SearchTermParser do

  describe "is blank" do
    it "returns true if search term nil" do
      parser = SearchTermParser.new(nil)
      parser.is_blank?.should be_true
    end
    it "returns true if search term blank" do
      parser = SearchTermParser.new("")
      parser.is_blank?.should be_true
    end
    it "returns true if search term only contains spaces" do
      parser = SearchTermParser.new("  ")
      parser.is_blank?.should be_true
    end
  end

  describe "accession number parsing" do
    context "plain number" do
      before(:each) do
        @parser = SearchTermParser.new("1234")
      end

      it "should be an accession number search" do
        @parser.accession_number_search?.should be_true
      end

      it "should return correct accession number" do
        @parser.accession_number.should eq("1234")
      end
    end

    context "number with NE prefix" do
      before(:each) do
        @parser = SearchTermParser.new("NE1234")
      end

      it "should be an accession number search" do
        @parser.accession_number_search?.should be_true
      end

      it "should return correct accession number" do
        @parser.accession_number.should eq("1234")
      end
    end

    context "number with NE prefix and item number suffix" do
      before(:each) do
        @parser = SearchTermParser.new("NE1234.5678")
      end

      it "should be an accession number search" do
        @parser.accession_number_search?.should be_true
      end

      it "should return correct accession number" do
        @parser.accession_number.should eq("1234")
      end
    end

    context "number with NE prefix and replicate code suffix" do
      before(:each) do
        @parser = SearchTermParser.new("NE1234.AnC")
      end

      it "should be an accession number search with correct accession number" do
        @parser.accession_number_search?.should be_true
      end

      it "should return correct accession number" do
        @parser.accession_number.should eq("1234")
      end
    end

    context "Free text starting with NE" do
      before(:each) do
        @parser = SearchTermParser.new("NE1234a")
      end

      it "should not be an accession number search" do
        @parser.accession_number_search?.should be_false
      end

      it "should return correct accession number" do
        @parser.accession_number.should be_nil
      end
    end

    context "Free text" do
      before(:each) do
        @parser = SearchTermParser.new("1234a")
      end

      it "should not be an accession number search" do
        @parser.accession_number_search?.should be_false
      end

      it "should return correct accession number" do
        @parser.accession_number.should be_nil
      end
    end
  end

  describe "Text search" do
    it "should return the stripped search term" do
      parser = SearchTermParser.new(" abcd  ")
      parser.text_search.should eq("abcd")
    end
  end
end
