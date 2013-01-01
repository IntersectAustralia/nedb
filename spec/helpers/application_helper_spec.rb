require 'spec_helper'

describe ApplicationHelper do
  describe "Format partial date" do
    it "should return the right value when only year filled in" do
      helper.format_partial_date(2001, nil, nil).should eq("2001")
    end
    it "should return the right value when only year and month filled in" do
      helper.format_partial_date(2001, 6, nil).should eq("June 2001")
    end
    it "should return the right value when year month and day all filled in" do
      helper.format_partial_date(2001, 8, 24).should eq("24 Aug. 2001")
    end

    describe "Format month" do
      it "should shorten long months to 3 characters" do
        helper.format_partial_date(2001, 1, nil).should eq("Jan. 2001")
        helper.format_partial_date(2001, 2, nil).should eq("Feb. 2001")
        helper.format_partial_date(2001, 4, nil).should eq("Apr. 2001")
        helper.format_partial_date(2001, 8, nil).should eq("Aug. 2001")
        helper.format_partial_date(2001, 10, nil).should eq("Oct. 2001")
      end
      it "should leave 4 character months as is" do
        helper.format_partial_date(2001, 6, nil).should eq("June 2001")
        helper.format_partial_date(2001, 7, nil).should eq("July 2001")
      end
      it "should leave 3 character months as is" do
        helper.format_partial_date(2001, 5, nil).should eq("May 2001")
      end
    end
  end
  
  describe "Format partial date for CSV" do
    it "should return the right value when only year filled in" do
      helper.format_partial_date_for_csv(2001, nil, nil).should eq("2001")
    end
    it "should return the right value when only year and month filled in" do
      helper.format_partial_date_for_csv(2001, 6, nil).should eq("Jun 2001")
    end
    it "should return the right value when year month and day all filled in" do
      helper.format_partial_date_for_csv(2001, 8, 24).should eq("24 Aug 2001")
    end

    describe "Format month" do
      it "should shorten long months to 3 characters" do
        helper.format_partial_date_for_csv(2001, 1, nil).should eq("Jan 2001")
        helper.format_partial_date_for_csv(2001, 2, nil).should eq("Feb 2001")
        helper.format_partial_date_for_csv(2001, 4, nil).should eq("Apr 2001")
        helper.format_partial_date_for_csv(2001, 8, nil).should eq("Aug 2001")
        helper.format_partial_date_for_csv(2001, 10, nil).should eq("Oct 2001")
        helper.format_partial_date_for_csv(2001, 6, nil).should eq("Jun 2001")
        helper.format_partial_date_for_csv(2001, 7, nil).should eq("Jul 2001")
      end
      it "should leave 3 character months as is" do
        helper.format_partial_date_for_csv(2001, 5, nil).should eq("May 2001")
      end
    end
    
  end
  
  describe "Render field method" do
    it "should build the correct string" do
      helper.render_field("Name", "This is a name that is rendered").should eq("<div class='field_bg inlineblock' id='display_name'><span class=\"label_view\">Name:</span><span class=\"field_value\">This is a name that is rendered</span></div>")
    end
  end
end

