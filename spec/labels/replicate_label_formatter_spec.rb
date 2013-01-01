require 'spec_helper'

describe 'ReplicateLabelFormatter' do

  before(:each) do
    @specimen = Factory(:specimen)
    @rep = Factory(:herbarium, :code => 'ABC')
    @specimen.replicates << @rep
    @rep_label_formatter = ReplicateLabelFormatter.new(@specimen, @rep)
  end

  describe "show ex? method" do
    it "should return true if not from student herbarium" do
      @rep_label_formatter.show_ex?.should be_true
    end

    it "should return false if from student herbarium" do
      @rep.code = Herbarium::STUDENT_HERBARIUM_CODE
      @rep.save!
      @rep_label_formatter.show_ex?.should be_false
    end
  end

  describe "barcode values and labels" do
    it "should include accession number and rep code" do
      @rep_label_formatter.barcode_value.should eq("NE#{@specimen.id}.ABC")
      @rep_label_formatter.barcode_label.should eq("Do not cite: NE#{@specimen.id}.ABC")
    end
  end

  describe "sheet number rendering" do
    it "should never number replicates" do
      fruit = Factory(:item_type, :name => 'Fruit', :create_labels => true)
      sheet = Factory(:item_type, :name => ItemType::TYPE_SPECIMEN_SHEET, :create_labels => true)
      other = Factory(:item_type, :name => 'Bark', :create_labels => false)

      sheet_1  = @specimen.items.create!(:item_type => sheet)
      fruit_1  = @specimen.items.create!(:item_type => fruit)
      sheet_2  = @specimen.items.create!(:item_type => sheet)
      other_1  = @specimen.items.create!(:item_type => other)

      @rep_label_formatter.sheet(1).should eq("")
    end
  end

end