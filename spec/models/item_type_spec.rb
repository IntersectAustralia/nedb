require 'spec_helper'

describe ItemType do

  before(:each) do
    ItemType.create!({:name => "Specimen Sheet", :create_labels => true})
  end

  describe "Validations" do
    it { should validate_presence_of :name }
    #it { should validate_presence_of :create_labels }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

end
