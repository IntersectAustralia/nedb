require 'spec_helper'

describe State do
  describe "Validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :country }
  end
  
  describe "Associations" do
    it { should belong_to :country }
    it { should have_many :botanical_divisions }
  end
end
