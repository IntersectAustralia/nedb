require 'spec_helper'

describe 'ItemLabelFormatter' do

  before(:each) do
    @sheet = FactoryGirl.create(:item_type, :name => ItemType::TYPE_SPECIMEN_SHEET, :create_labels => true)
    @specimen = FactoryGirl.create(:specimen)
    @item = @specimen.items.create!(:item_type => @sheet)
    @item_label_formatter = ItemLabelFormatter.new(@specimen, @item)
  end

  describe "show ex? method" do
    it "should always be false for items" do
      @item_label_formatter.show_ex?.should eq false
    end
  end

  describe "barcode values and labels" do
    it "should include the accession number and item number" do
      @item_label_formatter.barcode_value.should eq("NE#{@specimen.id}.#{@item.id}")
      @item_label_formatter.barcode_label.should eq("Do not cite: #{@item.id} Specimen sheet")
    end
  end

  describe "sheet number rendering with multiple sheets" do
    before(:each) do
      @specimen = FactoryGirl.create(:specimen)
      fruit = FactoryGirl.create(:item_type, :name => 'Fruit', :create_labels => true)
      other = FactoryGirl.create(:item_type, :name => 'Bark', :create_labels => false)

      sheet_1  = @specimen.items.create!(:item_type => @sheet)
      fruit_1  = @specimen.items.create!(:item_type => fruit)
      sheet_2  = @specimen.items.create!(:item_type => @sheet)
      other_1  = @specimen.items.create!(:item_type => other)

      @item_label_formatter = ItemLabelFormatter.new(@specimen, sheet_1)
    end

    it "should count up numbered items correctly" do
      @item_label_formatter.total_number_of_numbered_sheets.should eq 2
    end

    it "should only number specimen sheet items" do
      @item_label_formatter.sheet(1).should eq "<b>Sheet 1 of 2</b>"
      @item_label_formatter.sheet(2).should eq "<b>Sheet 2 of 2</b>"
      @item_label_formatter.sheet(3).should eq ""
    end
  end

  describe "sheet number rendering with only one sheet" do
    it "should only number sheets if there's more than one" do
      @item_label_formatter.sheet(1).should eq("")
    end
  end
end