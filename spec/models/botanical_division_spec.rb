require 'spec_helper'

describe BotanicalDivision do
  describe "Associations" do
    it { should belong_to :state }
  end
  
  describe "Validations" do
    it { should validate_presence_of :state }
    it { should validate_presence_of :name }
  end
end
