require 'spec_helper'

describe Country do
  describe "Validations" do
    it { should validate_presence_of :name }
  end
  
  describe "Associations" do
    it { should have_many :states }
  end
end
