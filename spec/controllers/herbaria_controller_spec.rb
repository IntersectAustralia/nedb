require 'spec_helper'

describe HerbariaController do
  include Devise::TestHelpers 
  
  before(:each) do
    @user = mock_model(User)
    sign_in @user
    @ability = mock(Ability).as_null_object
    Ability.stub(:new).with(@user) { @ability }
  end


  def mock_herbarium(stubs={})
    @mock_herbarium ||= mock_model(Herbarium, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all herbaria as @herbaria" do
      Herbarium.stub(:ordered_by_code) { [mock_herbarium] }
      get :index
      assigns(:herbaria).should eq([mock_herbarium])
    end
  end

  describe "GET new" do
    it "assigns a new herbarium as @herbarium" do
      Herbarium.stub(:new) { mock_herbarium }
      get :new
      assigns(:herbarium).should be(mock_herbarium)
    end
  end

  describe "GET edit" do
    it "assigns the requested herbarium as @herbarium" do
      Herbarium.stub(:find).with("37") { mock_herbarium }
      get :edit, :id => "37"
      assigns(:herbarium).should be(mock_herbarium)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created herbarium as @herbarium" do
        Herbarium.stub(:new) { mock_herbarium(:save => true) }
        post :create, :herbarium => {'these' => 'params'}
        assigns(:herbarium).should be(mock_herbarium)
      end

      it "redirects to the list" do
        Herbarium.stub(:new) { mock_herbarium(:save => true) }
        post :create, :herbarium => {}
        response.should redirect_to(herbaria_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved herbarium as @herbarium" do
        Herbarium.stub(:new) { mock_herbarium(:save => false) }
        post :create, :herbarium => {'these' => 'params'}
        assigns(:herbarium).should be(mock_herbarium)
      end

      it "re-renders the 'new' template" do
        Herbarium.stub(:new) { mock_herbarium(:save => false) }
        post :create, :herbarium => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested herbarium" do
        Herbarium.should_receive(:find).with("37") { mock_herbarium }
        mock_herbarium.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :herbarium => {'these' => 'params'}
      end

      it "assigns the requested herbarium as @herbarium" do
        Herbarium.stub(:find) { mock_herbarium(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:herbarium).should be(mock_herbarium)
      end

      it "redirects to the list" do
        Herbarium.stub(:find) { mock_herbarium(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(herbaria_url)
      end
    end

    describe "with invalid params" do
      it "assigns the herbarium as @herbarium" do
        Herbarium.stub(:find) { mock_herbarium(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:herbarium).should be(mock_herbarium)
      end

      it "re-renders the 'edit' template" do
        Herbarium.stub(:find) { mock_herbarium(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "GET 'autocomplete_plant_name'" do
    it "search on name and return matches as JSON" do
      Herbarium.should_receive(:autocomplete_herbarium_name).with("NSW") { [mock_herbarium] }
      get 'autocomplete_herbarium_name', :term => "NSW"
      response.should be_success
    end
  end


end
