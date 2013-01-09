require 'spec_helper'
# encoding: UTF-8

describe "SpecimenNameFormatter" do

  describe "Appending uncertainties" do
    it "should add ? before the text" do
      SpecimenNameFormatter.append_uncertainty("SomeText", "?").should eq("?SomeText")
    end

    it "should add sens. strict. after the text with a space and in italics" do
      SpecimenNameFormatter.append_uncertainty("SomeText", "sens. strict.").should eq("SomeText <i>s. str.</i>")
    end

    it "should add sens. lat. after the text with a space and in italics" do
      SpecimenNameFormatter.append_uncertainty("SomeText", "sens. lat.").should eq("SomeText <i>s. lat.</i>")
    end

    it "should add vel. aff. after the text with a space and in italics" do
      SpecimenNameFormatter.append_uncertainty("SomeText", "vel. aff.").should eq("SomeText <i>vel. aff.</i>")
    end

    it "should add aff. before the text with a space and in italics" do
      SpecimenNameFormatter.append_uncertainty("SomeText", "aff.").should eq("<i>aff.</i> SomeText")
    end
  end

end