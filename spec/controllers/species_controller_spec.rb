require 'spec_helper'

describe SpeciesController do
  include Devise::TestHelpers

  before(:each) do
    @user = mock_model(User)
    sign_in @user
    @ability = mock(Ability).as_null_object
    Ability.stub(:new).with(@user) { @ability }
  end

  def mock_species(stubs={})
    @mock_species ||= Factory(:species)
  end

  describe "GET 'autocomplete_plant_name'" do
    it "search on name and return matches as JSON" do
      Species.should_receive(:autocomplete_plant_name).with("genus", "bear") { [mock_species] }
      get 'autocomplete_plant_name', :term => "bear", :level => "genus"
      response.should be_success
    end
  end

  describe "GET index" do
    it "does nothing if reset=true" do
      Species.stub(:paginate) { [mock_species] }
      get :index, :reset => "true"
      response.should render_template("index")
    end
    it "does a search if search term in session" do
      Species.should_receive(:free_text_search).with("saved-search") { [mock_species] }
      session[:species_search_term] = "saved-search"
      get :index
      response.should render_template("index")
      assigns(:species).should eq([mock_species])
    end
    it "does a search if search term in request" do
      Species.should_receive(:free_text_search).with("search-term") { [mock_species] }
      get :index, :search => "search-term"
      response.should render_template("index")
      assigns(:species).should eq([mock_species])
    end
  end

  describe "GET show" do
    it "assigns the requested species as @species" do
      Species.stub(:find).with("37") { mock_species }
      get :show, :id => "37"
      assigns(:species).should be(mock_species)
    end
  end

  describe "GET new" do
    pending "assigns a new species as @species" do
      Species.stub(:new) { mock_species }
      get :new
      assigns(:species).should be(mock_species)
    end
  end

  describe "GET edit" do
    it "assigns the requested species as @species" do
      Species.stub(:find).with("37") { mock_species }
      get :edit, :id => "37"
      assigns(:species).should be(mock_species)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      pending "assigns a newly created species as @species" do
        Species.stub(:new) { mock_species(:save => true) }
        post :create, :species => {'these' => 'params'}
        assigns(:species).should be(mock_species)
      end

      pending "redirects to the species details" do
        Species.stub(:new) { mock_species(:save => true) }
        post :create, :species => {}
        response.should redirect_to(species_url(mock_species))
      end
    end

    describe "with invalid params" do
      pending "assigns a newly created but unsaved species as @species" do
        Species.stub(:new) { mock_species(:save => false) }
        post :create, :species => {'these' => 'params'}
        assigns(:species).should be(mock_species)
      end

      pending "re-renders the 'new' template" do
        Species.stub(:new) { mock_species(:save => false) }
        post :create, :species => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested species" do
        Species.should_receive(:find).with("37") { mock_species }
        mock_species.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :species => {'these' => 'params'}
      end

      it "assigns the requested species as @species" do
        Species.stub(:find) { mock_species(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:species).should be(mock_species)
      end

      it "redirects to the species details" do
        Species.stub(:find) { mock_species(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(species_url(mock_species))
      end
    end

    describe "with invalid params" do
      it "assigns the species as @species" do
        Species.stub(:find) { mock_species(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:species).should be(mock_species)
      end

      pending "re-renders the 'edit' template" do
        Species.stub(:find) { mock_species(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  
end
