require 'spec_helper'

describe SpecimensController do
  include Devise::TestHelpers 
  
  before(:each) do
    @user = mock_model(User)
    sign_in @user
    @ability = mock(Ability).as_null_object
    Ability.stub(:new).with(@user) { @ability }
  end

  def mock_specimen(stubs={})
    @mock_specimen ||= mock_model(Specimen, stubs).as_null_object
  end
  def mock_item_type(stubs={})
    @mock_item_type ||= mock_model(ItemType, stubs).as_null_object
  end

  describe "GET download_zip" do
    pending "works" do
      Specimen.stub(:find).with("37") { mock_specimen }

      get :download_zip, :id => '37'
    end
  end

  describe "GET show" do
    it "assigns the requested specimen as @specimen" do
      Specimen.stub(:find).with("37") { mock_specimen }
      get :show, :id => "37"
      assigns(:specimen).should be(mock_specimen)
    end
  end

  describe "GET new" do
    it "assigns a new specimen as @specimen" do
      Specimen.stub(:new) { mock_specimen }
      get :new
      assigns(:specimen).should be(mock_specimen)
    end
    
    it "assigns the list of all people as @all_people" do
      people = [Factory(:person, :last_name => "John"), Factory(:person, :last_name => "Steve")]
      Person.should_receive(:all).and_return(people)
      Specimen.stub(:new) { mock_specimen }
      get :new
      assigns(:all_people).should eq(people)
    end

    it "presets values if they are present in session" do
      session[:previous_values] = {:mock => "value"}
      # it actually receives new twice since cancan creates an empty object first
      Specimen.should_receive(:new) { mock_specimen }
      Specimen.should_receive(:new).with({:mock => "value"}) { mock_specimen }
      get :new
    end
  end

  describe "GET edit" do
    it "assigns the requested specimen as @specimen" do
      Specimen.stub(:find).with("37") { mock_specimen }
      get :edit, :id => "37"
      assigns(:specimen).should be(mock_specimen)
    end

    it "assigns the list of all people as @all_people" do
      people = [Factory(:person, :last_name => "John"), Factory(:person, :last_name => "Steve")]
      Person.should_receive(:all).and_return(people)
      Specimen.stub(:find).with("37") { mock_specimen }
      get :edit, :id => "37"
      assigns(:all_people).should eq(people)
    end
  end

  describe "GET edit replicates" do
    it "assigns the requested specimen as @specimen" do
      Specimen.stub(:find).with("37") { mock_specimen }
      get :edit_replicates, :id => "37"
      assigns(:specimen).should be(mock_specimen)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created specimen as @specimen" do
        Specimen.stub(:new) { mock_specimen(:save => true) }
        post :create, :specimen => {'these' => 'params'}
        assigns(:specimen).should be(mock_specimen)
      end

      it "redirects to the created specimen" do
        Specimen.stub(:new) { mock_specimen(:save => true) }
        post :create, :specimen => {}
        response.should redirect_to(specimen_url(mock_specimen))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved specimen as @specimen" do
        Specimen.stub(:new) { mock_specimen(:save => false) }
        post :create, :specimen => {'these' => 'params'}
        assigns(:specimen).should be(mock_specimen)
      end

      it "re-renders the 'new' template" do
        Specimen.stub(:new) { mock_specimen(:save => false) }
        post :create, :specimen => {'these' => 'params'}
        response.should render_template("new")
      end

      it "assigns the list of all people as @all_people" do
        people = [Factory(:person, :last_name => "John"), Factory(:person, :last_name => "Steve")]
        Person.should_receive(:all).and_return(people)
        Specimen.stub(:new) { mock_specimen(:save => false) }
        post :create, :specimen => {}
        assigns(:all_people).should eq(people)
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested specimen" do
        Specimen.should_receive(:find).with("37") { mock_specimen }
        mock_specimen.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :specimen => {'these' => 'params'}
      end

      it "assigns the requested specimen as @specimen" do
        Specimen.stub(:find) { mock_specimen(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:specimen).should be(mock_specimen)
      end

      it "redirects to the specimen" do
        Specimen.stub(:find) { mock_specimen(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(specimen_url(mock_specimen))
      end
    end

    describe "with invalid params" do
      it "assigns the specimen as @specimen" do
        Specimen.stub(:find) { mock_specimen(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:specimen).should be(mock_specimen)
      end

      it "re-renders the 'edit' template" do
        Specimen.stub(:find) { mock_specimen(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end

      it "assigns the list of all people as @all_people" do
        people = [Factory(:person, :last_name => "John"), Factory(:person, :last_name => "Steve")]
        Person.should_receive(:all).and_return(people)
        Specimen.stub(:find) { mock_specimen(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:all_people).should eq(people)
      end
    end

  end
  
  describe "PUT update_replicates" do

    it "updates the requested specimen" do
      Specimen.should_receive(:find).with("37") { mock_specimen }
      mock_specimen.should_receive(:replicate_ids=).with([1,2])
      put :update_replicates, :id => "37", :specimen => { :replicate_ids => [1,2] }
    end

    it "assigns the requested specimen as @specimen" do
      Specimen.stub(:find) { mock_specimen(:update_attributes => true) }
      put :update_replicates, :id => "1"
      assigns(:specimen).should be(mock_specimen)
    end

    it "redirects to the specimen" do
      Specimen.stub(:find) { mock_specimen(:update_attributes => true) }
      put :update_replicates, :id => "1"
      response.should redirect_to(specimen_url(mock_specimen))
    end
  end

  describe "GET search by id" do
    it "assigns the requested specimen as @specimen if it exists" do
      Specimen.stub(:exists?).with("37") { true }
      Specimen.stub(:find).with("37") { mock_specimen }
      get :search, {:quick_search => "37"}
      assigns(:specimen).should be(mock_specimen)
      response.should redirect_to(specimen_url(mock_specimen))
    end

    it "redirects back to home if id not found" do
      Specimen.stub(:exists?).with("37") { false }
      get :search, {:quick_search => "37"}
      response.should redirect_to(root_url)
    end

  end

  describe "GET search by string" do 
    it "returns all specimens if search string blank" do
      Specimen.stub_chain(:accessible_by, :order).and_return([mock_specimen, mock_specimen])
      get :search, {:quick_search => ""}
      response.should redirect_to(search_results_specimens_url)
      flash[:notice].should eq("Showing all 2 specimens.")
    end

    it "redirects back to home if no result found" do
      Specimen.stub(:free_text_search).with("search_str") { [] }
      get :search, {:quick_search => "search_str"}
      response.should redirect_to(root_url)
    end
    
    it "assigns the requested specimen as @specimen if only one exists" do
      Specimen.stub(:free_text_search).with("search_str") { [mock_specimen] }
      get :search, {:quick_search => "search_str"}
      assigns(:specimen).should be(mock_specimen)
      response.should redirect_to(specimen_url(mock_specimen))
    end
    
    it "shows a list of specimens if more that one match" do
      Specimen.stub(:free_text_search).with("search_str") { [mock_specimen, mock_specimen] }
      get :search, {:quick_search => "search_str"}
      session[:search_results].size.should be(2)
      response.should redirect_to(search_results_specimens_url)
      flash[:notice].should eq("Found 2 matching specimens.")
    end
  end

  describe "POST add_item" do

    describe "with valid params" do
      it "adds a new item to @specimen" do
        Specimen.stub(:find).with("37") { mock_specimen }
        ItemType.stub(:find).with("2") { mock_item_type }
        mock_specimen.items.should_receive(:create!).with(:item_type => mock_item_type)
        post :add_item, :id => "37", :item_type_id => "2"
      end

      it "redirects to the specimen" do
        Specimen.stub(:find).with("37") { mock_specimen }
        ItemType.stub(:find).with("2") { mock_item_type }
        post :add_item, :id => "37", :item_type_id => "2"
        response.should redirect_to(specimen_url(mock_specimen))
      end
    end

  end

  describe "GET search_results" do
    it "should return the correct page of results"
    it "should return all results when CSV requested"
  end

end
