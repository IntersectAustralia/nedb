require 'spec_helper'

describe ItemsController do
  include Devise::TestHelpers 
  
  before(:each) do
    @user = mock_model(User)
    sign_in @user
    @ability = mock(Ability).as_null_object
    Ability.stub(:new).with(@user) { @ability }
  end

  def mock_item(stubs={})
    @mock_item ||= mock_model(Item, stubs).as_null_object
  end
  def mock_specimen(stubs={})
    @mock_specimen ||= mock_model(Specimen, stubs).as_null_object
  end

  describe "DELETE destroy" do
    it "destroys the requested item" do
      Specimen.should_receive(:find).with("22") { mock_specimen }
      mock_specimen.items.should_receive(:find).with("37") { mock_item }
      mock_item.should_receive(:destroy)
      delete :destroy, :id => "37", :specimen_id => "22"
    end

    it "redirects to the parent specimen" do
      Specimen.should_receive(:find).with("22") { mock_specimen }
      mock_specimen.items.should_receive(:find).with("37") { mock_item }
      delete :destroy, :id => "37", :specimen_id => "22"
      response.should redirect_to(specimen_url(mock_specimen))
    end
  end

end
