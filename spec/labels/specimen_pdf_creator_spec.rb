# encoding: utf-8
require 'spec_helper'

describe "SpecimenPdfCreator" do
  
  before(:each) do
    @sheet = FactoryGirl.create(:item_type, :name => ItemType::TYPE_SPECIMEN_SHEET, :create_labels => true)
    @specimen = FactoryGirl.create(:specimen)
    @item = @specimen.items.create!(:item_type => @sheet)
    @item_label_formatter = ItemLabelFormatter.new(@specimen, @item)
    @det_attrs = {:determiners => [FactoryGirl.create(:person, :first_name => "Steve", :last_name => "Jacks", :initials => "S.J.")] ,:determination_date_year => '2010', :family => 'Rose', :referenced => true}
  end

  describe "generate_label with utf8 string" do
    it "should not throw an exception" do
      @specimen.determinations.create!(@det_attrs.merge({:genus =>"Rose", :species => 'aspecies', :species_authority => "Ruíz & Pav"}))
      pdf = Prawn::Document.new(page_size: 'A4')
      pdf_creator = SpecimenPdfCreator.new
      pdf_creator.generate_label(pdf, 0, @item_label_formatter)
    end
  end

end
