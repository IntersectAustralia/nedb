require 'spec_helper'

describe Item do
  
  describe "Validations" do
    it { should validate_presence_of :specimen }
    it { should validate_presence_of :item_type }
  end
  
  describe "Associations" do
    it { should belong_to :specimen }
    it { should belong_to :item_type }
  end
end
