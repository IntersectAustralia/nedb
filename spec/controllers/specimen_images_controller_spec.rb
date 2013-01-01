require 'spec_helper'

describe SpecimenImagesController do
  include Devise::TestHelpers

  before(:each) do
    @user = mock_model(User)
    sign_in @user
    @ability = mock(Ability).as_null_object
    Ability.stub(:new).with(@user) { @ability }
    Specimen.stub(:find).with("58") { mock_specimen }
    SpecimenImage.stub(:find).with("37") { mock_specimen_image }
  end

  def mock_specimen(stubs={})
    @mock_specimen ||= mock_model(Specimen, stubs).as_null_object
  end

  def mock_specimen_image(stubs={})
    @mock_specimen_image ||= mock_model(SpecimenImage, stubs).as_null_object
  end

  describe "GET download" do
    it "should be successful" do
      pending 'not sure how to stub download'
      get :download, :id => '37', :specimen_id => '58'
      response.should be_success
    end
  end

    
  describe "GET 'edit'" do
    it "should be successful" do
      get :edit, :id => "37", :specimen_id => "58"
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get :show, :id => "37", :specimen_id => "58"
      response.should be_success
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested image" do
      Specimen.should_receive(:find).with('58') {mock_specimen}
      mock_specimen.images.should_receive(:find).with('37') {mock_specimen_image}
      mock_specimen_image.should_receive(:destroy)
      delete :destroy, :id => '37', :specimen_id => '58'
    end

    it "redirects to the parent image" do
      Specimen.should_receive(:find).with("58") {mock_specimen}
      mock_specimen.items.should_receive(:find).with("37") {mock_specimen_image}
      delete :destroy, :id => "37", :specimen_id => "58"
      response.should redirect_to(specimen_url(mock_specimen))
    end
  end


  describe "POST create" do
    describe "with valid params" do
      it "redirects to the created specimen" do
        get :new, :specimen_id => '58'
        SpecimenImage.stub(:new) { mock_specimen_image(:save => true) }
        post :create, :specimen_id => '58'
        response.should redirect_to(specimen_url(mock_specimen))
      end
    end

    describe "with invalid params" do
      pending "re-renders the 'new' template" do
        get :new, :specimen_id => '58'
        SpecimenImage.stub(:new, :specimen_id => '58') { mock_specimen_image(:save => false) }
        @user.should_receive(:email)
        post :create, :specimen_id => '58'
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    describe "with valid params" do

      it "updates the requested specimen image" do
        Specimen.stub(:find).with("58") { mock_specimen }
        SpecimenImage.stub(:find).with("10") { mock_specimen_image }
        mock_specimen.specimen_images.should_receive(:find).with("10") { mock_specimen_image }
        mock_specimen_image.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "10", :specimen_image => {'these' => 'params'}, :specimen_id => "58"
      end

      it "assigns the requested specimen image as @specimen_image" do
        Specimen.stub(:find).with("58") { mock_specimen }
        SpecimenImage.stub(:find).with("10") { mock_specimen_image }
        mock_specimen.specimen_images.stub(:find) { mock_specimen_image(:update_attributes => true) }
        put :update, :specimen_id => "58", :id => "10"
        assigns(:specimen_image).should be(mock_specimen_image)
        assigns(:specimen).should be(mock_specimen)
      end

      it "redirects to the specimen image" do
        Specimen.stub(:find).with("58") { mock_specimen }
        SpecimenImage.stub(:find).with("37") { mock_specimen_image(:update_attributes => true) }
        mock_specimen.specimen_images.should_receive(:find).with("37") { mock_specimen_image }
        put :update, :specimen_id => '58', :id => '37'
        response.should redirect_to(specimen_specimen_image_url(mock_specimen, mock_specimen_image))
      end

    end

    describe "with invalid params" do

      it "re-renders the 'edit' template" do
        Specimen.stub(:find).with("58") { mock_specimen }
        mock_specimen.specimen_images.stub(:find) { mock_specimen_image(:update_attributes => false) }
        put :update, :specimen_id => '58', :id => '37'
        response.should render_template("edit")
      end

    end

  end
  
end
