require 'spec_helper'

describe DeterminationsController do
  include Devise::TestHelpers 
  
  before(:each) do
    @user = mock_model(User)
    sign_in @user
    @ability = mock(Ability).as_null_object
    Ability.stub(:new).with(@user) { @ability }
  end

  def mock_determination(stubs={})
    @mock_determination ||= mock_model(Determination, stubs).as_null_object
  end
  def mock_specimen(stubs={})
    @mock_specimen ||= mock_model(Specimen, stubs).as_null_object
  end
  def mock_person(stubs={})
    @mock_person ||= mock_model(Person, stubs).as_null_object
  end
  def mock_species(stubs={})
    @mock_species ||= mock_model(Species, stubs).as_null_object
  end
  def mock_subspecies(stubs={})
    @mock_subspecies ||= mock_model(Subspecies, stubs).as_null_object
  end
  def mock_varieties(stubs={})
    @mock_varieties ||= mock_model(Variety, stubs).as_null_object
  end
  def mock_forms(stubs={})
    @mock_form ||= mock_model(Form, stubs).as_null_object
  end

  describe "GET show" do
    it "assigns the requested determination as @determination" do
      Specimen.stub(:find).with("58") { mock_specimen }
      mock_specimen.determinations.stub(:find).with("37") { mock_determination }
      get :show, :id => "37", :specimen_id => "58"
      assigns(:determination).should be(mock_determination)
      assigns(:specimen).should be(mock_specimen)
    end
  end

  describe "GET new" do
    it "assigns a new determination as @determination" do
      Specimen.stub(:find).with("58") { mock_specimen }
      #Determination.stub(:new) { mock_determination }
      get :new, :specimen_id => "58"
      assigns(:determination).should_not be_nil
      assigns(:specimen).should be(mock_specimen)
    end
  end

  describe "GET edit" do
    it "assigns the requested determination as @determination" do
      Specimen.stub(:find).with("58") { mock_specimen }
      Species.stub(:find_by_name_and_genus) { mock_species }
      mock_species.stub(:subspecies) { mock_subspecies }
      mock_species.stub(:varieties) { mock_varieties }
      mock_species.stub(:forms) { mock_forms }
      mock_specimen.determinations.stub(:find).with("37") { mock_determination }

      get :edit, :id => "37", :specimen_id => "58"
      assigns(:determination).should be(mock_determination)
      assigns(:specimen).should be(mock_specimen)
#      assigns(:subspecies).should be(mock_subspecies)
#      assigns(:varieties).should be(mock_varieties)
#      assigns(:forms).should be(mock_forms)

    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created determination as @determination" do
        Specimen.stub(:find).with("58") { mock_specimen }
        #Determination.stub(:new) {mock_determination(:save => true)}
        mock_specimen.determinations.stub(:new) { mock_determination(:save => true) }
        post :create, :determination => {'these' => 'params'}, :specimen_id => "58"
        assigns(:determination).should be(mock_determination)
        assigns(:specimen).should be(mock_specimen)
      end

      it "redirects to the parent specimen" do
        Specimen.stub(:find).with("58") { mock_specimen }
        Determination.stub(:new) { mock_determination(:save => true) }
        post :create, :determination => {}, :specimen_id => "58"
        response.should redirect_to(specimen_url(mock_specimen))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved determination as @determination" do
        mock_specimen.determinations.stub(:new) { mock_determination(:save => false) }
        Specimen.stub(:find).with("58") { mock_specimen }
        post :create, :determination => {'these' => 'params'}, :specimen_id => "58"
        assigns(:determination).should be(mock_determination)
        assigns(:specimen).should be(mock_specimen)
      end

      it "re-renders the 'new' template" do
        Specimen.stub(:find).with("58") { mock_specimen }
        mock_specimen.determinations.stub(:new) {mock_determination(:save => false)}
        post :create, :determination => {}, :specimen_id => "58"
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      pending "updates the requested determination" do
        Specimen.stub(:find).with("58") { mock_specimen }
        mock_specimen.determinations.should_receive(:find).with("37") { mock_determination }
        Person.stub(:find).with("97") { mock_person }
        mock_determination.should_receive(:update_attributes).with({"determiners" => [mock_person], 'these' => 'params'})
        put :update, :id => "37", :determination => {'these' => 'params'}, :determiner_ids => ["97"], :specimen_id => "58"
      end

      pending "assigns the requested determination as @determination" do
        Specimen.stub(:find).with("58") { mock_specimen }
        mock_specimen.determinations.stub(:find) { mock_determination(:update_attributes => true) }
        Person.stub(:find).with("97") { mock_person }
        put :update, :id => "1", :determination => {'these' => 'params'}, :determiner_ids => ["97"], :specimen_id => "58"
        assigns(:determination).should be(mock_determination)
        assigns(:specimen).should be(mock_specimen)
      end

      pending "redirects to the specimen" do
        Specimen.stub(:find).with("58") { mock_specimen }
        mock_specimen.determinations.stub(:find) { mock_determination(:update_attributes => true) }
        Person.stub(:find).with("97") { mock_person }
        put :update, :id => "1", :determination => {'these' => 'params'}, :determiner_ids => ["97"], :specimen_id => "58"
        response.should redirect_to(specimen_url(mock_specimen))
      end
    end

    describe "with invalid params" do
      pending "assigns the determination as @determination" do
        Specimen.stub(:find).with("58") { mock_specimen }
        mock_specimen.determinations.stub(:find) { mock_determination(:update_attributes => false) }
        Person.stub(:find).with("97") { mock_person }
        put :update, :id => "1", :determination => {'these' => 'params'}, :determiner_ids => ["97"], :specimen_id => "58"
        assigns(:determination).should be(mock_determination)
        assigns(:specimen).should be(mock_specimen)
      end

      pending "re-renders the 'edit' template" do
        Specimen.stub(:find).with("58") { mock_specimen }
        mock_specimen.determinations.stub(:find) { mock_determination(:update_attributes => false) }
        Person.stub(:find).with("97") { mock_person }
        put :update, :id => "1", :determination => {'these' => 'params'}, :determiner_ids => ["97"], :specimen_id => "58"
        response.should render_template("edit")
      end
    end

  end

end
