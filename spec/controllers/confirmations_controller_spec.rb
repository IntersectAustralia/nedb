require 'spec_helper'

describe ConfirmationsController do
  include Devise::TestHelpers 
  
  before(:each) do
    @user = mock_model(User)
    sign_in @user
    @ability = mock(Ability).as_null_object
    Ability.stub(:new).with(@user) { @ability }
  end

  def mock_confirmation(stubs={})
    @mock_confirmation ||= mock_model(Confirmation, stubs).as_null_object
  end
  def mock_specimen(stubs={})
    @mock_specimen ||= mock_model(Specimen, stubs).as_null_object
  end
  def mock_determination(stubs={})
    @mock_determination ||= mock_model(Determination, stubs).as_null_object
  end

  describe "GET new" do
    it "assigns a new confirmation as @confirmation" do
      Specimen.stub(:find).with("58") { mock_specimen }
      Determination.stub(:find).with("10") { mock_determination }
      get :new, :specimen_id => "58", :determination_id => "10"
      assigns(:confirmation).should_not be_nil
      assigns(:specimen).should be(mock_specimen)
      assigns(:determination).should be(mock_determination)
    end
  end

  describe "GET edit" do
    it "assigns the requested confirmation as @confirmation" do
      Specimen.stub(:find).with("58") { mock_specimen }
      Determination.stub(:find).with("10") { mock_determination }
      mock_specimen.confirmations.stub(:find).with("37") { mock_confirmation }
      get :edit, :id => "37", :specimen_id => "58", :determination_id => "10"
      assigns(:confirmation).should be(mock_confirmation)
      assigns(:specimen).should be(mock_specimen)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created confirmation as @confirmation" do
        mock_specimen.stub(:current_determination) {mock_determination}
        mock_determination.stub(:create_confirmation).with({'these' => 'params'}){mock_confirmation(:save => false)}
        Specimen.stub(:find).with("58") { mock_specimen }
        Determination.stub(:find).with("10") { mock_determination }
        post :create, :confirmation => {'these' => 'params'}, :specimen_id => "58", :determination_id => "10"
        assigns(:confirmation).should be(mock_confirmation)
        assigns(:specimen).should be(mock_specimen)
      end

      it "redirects to the parent specimen" do
        mock_specimen.confirmations.stub(:new) { mock_confirmation(:save => true) }
        Specimen.stub(:find).with("58") { mock_specimen }
        Determination.stub(:find).with("10") { mock_determination }
        post :create, :confirmation => {}, :specimen_id => "58", :determination_id => "10"
        response.should redirect_to(specimen_url(mock_specimen))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved confirmation as @confirmation" do
        mock_specimen.stub(:current_determination) {mock_determination}
        mock_determination.stub(:create_confirmation).with({'these' => 'params'}){mock_confirmation(:save => false)}
        Specimen.stub(:find).with("58") { mock_specimen }
        Determination.stub(:find).with("10") { mock_determination }
        post :create, :confirmation => {'these' => 'params'}, :specimen_id => "58", :determination_id => "10"
        assigns(:confirmation).should be(mock_confirmation)
        assigns(:specimen).should be(mock_specimen)
      end

      it "re-renders the 'new' template" do
        mock_specimen.stub(:current_determination) {mock_determination}
        mock_determination.stub(:create_confirmation){mock_confirmation(:save => false)}
        Specimen.stub(:find).with("58") { mock_specimen } 
        Determination.stub(:find).with("10") { mock_determination }
        post :create, :confirmation => {}, :specimen_id => "58", :determination_id => "10"
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested confirmation" do
        Specimen.stub(:find).with("58") { mock_specimen }
        Determination.stub(:find).with("10") { mock_determination }
        mock_specimen.confirmations.should_receive(:find).with("37") { mock_confirmation }
        mock_confirmation.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :confirmation => {'these' => 'params'}, :specimen_id => "58", :determination_id => "10"
      end

      it "assigns the requested confirmation as @confirmation" do
        Specimen.stub(:find).with("58") { mock_specimen }
        Determination.stub(:find).with("10") { mock_determination }
        mock_specimen.confirmations.stub(:find) { mock_confirmation(:update_attributes => true) }
        put :update, :id => "1", :specimen_id => "58", :determination_id => "10"
        assigns(:confirmation).should be(mock_confirmation)
        assigns(:specimen).should be(mock_specimen)
      end

      it "redirects to the parent specimen" do
        Confirmation.stub(:find) { mock_confirmation(:update_attributes => true) }
        Specimen.stub(:find).with("58") { mock_specimen }
        Determination.stub(:find).with("10") { mock_determination }
        put :update, :id => "1", :specimen_id => "58", :determination_id => "10"
        response.should redirect_to(specimen_url(mock_specimen))
      end
    end

    describe "with invalid params" do
      it "assigns the confirmation as @confirmation" do
        Specimen.stub(:find).with("58") { mock_specimen }
        Determination.stub(:find).with("10") { mock_determination }
        mock_specimen.confirmations.stub(:find) { mock_confirmation(:update_attributes => false) }
        put :update, :id => "1", :specimen_id => "58", :determination_id => "10"
        assigns(:confirmation).should be(mock_confirmation)
        assigns(:specimen).should be(mock_specimen)
      end

      it "re-renders the 'edit' template" do
        Specimen.stub(:find).with("58") { mock_specimen }
        Determination.stub(:find).with("10") { mock_determination }
        mock_specimen.confirmations.stub(:find) { mock_confirmation(:update_attributes => false) }
        put :update, :id => "1", :specimen_id => "58", :determination_id => "10"
        response.should render_template("edit")
      end
    end

  end

end
