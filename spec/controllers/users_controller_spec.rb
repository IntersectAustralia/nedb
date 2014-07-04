require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers 
  
  before(:each) do
    @user = mock_model(User)
    sign_in @user
    @ability = mock(Ability).as_null_object
    Ability.stub(:new).with(@user) { @ability }
  end

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end

  def mock_profile(stubs={})
    @mock_profile ||= mock_model(Profile, stubs).as_null_object
  end

  describe "GET access_requests" do
    it "assigns all outstanding access requests as @users" do
      User.stub(:pending_approval) { [mock_user] }
      get :access_requests
      assigns(:users).should eq([mock_user])
    end
  end
  
  describe "GET show" do
    it "assigns the user to @user" do
      User.stub(:find).with("37") { mock_user }
      get :show, :id => "37"
      assigns(:user).should be(mock_user)
    end
  end
  
  describe "PUT reject" do
    it "rejects the requested user" do
      User.should_receive(:find).with("37") { mock_user }
      mock_user.should_receive(:reject_access_request)
      mock_user.should_receive(:destroy)
      put :reject, :id => "37"
    end

    it "redirects to the access requests page" do
      User.should_receive(:find).with("37") { mock_user }
      put :reject, :id => "37"
      response.should redirect_to(access_requests_users_url)
    end
  end
  
  describe "PUT reject as spam" do
    it "rejects the requested user" do
      User.should_receive(:find).with("37") { mock_user }
      mock_user.should_receive(:reject_access_request)
      put :reject_as_spam, :id => "37"
    end

    it "redirects to the access requests page" do
      User.should_receive(:find).with("37") { mock_user }
      put :reject_as_spam, :id => "37"
      response.should redirect_to(access_requests_users_url)
    end
  end
  
  describe "PUT deactivate" do
    it "deactivates the requested user" do
      User.should_receive(:find).with("37") { mock_user }
      mock_user.should_receive(:deactivate)
      put :deactivate, :id => "37"
    end
    
    it "redirects to the users page" do
      User.should_receive(:find).with("37") { mock_user }
      put :deactivate, :id => "37"
      response.should redirect_to(mock_user)
    end
  end

  describe "PUT activate" do
    it "deactivates the requested user" do
      User.should_receive(:find).with("37") { mock_user }
      mock_user.should_receive(:activate)
      put :activate, :id => "37"
    end
    
    it "redirects to the users page" do
      User.should_receive(:find).with("37") { mock_user }
      put :activate, :id => "37"
      response.should redirect_to(mock_user)
    end
  end

  describe "GET edit profile" do
    it "assigns the requested user as @user" do
      User.stub(:find).with("37") { mock_user }
      get :edit_profile, :id => "37"
      assigns(:user).should be(mock_user)
    end
    it "assigns the list of all profiles as @profiles" do
      User.stub(:find).with("37") { mock_user }
      Profile.stub(:by_name) { [mock_profile] }
      get :edit_profile, :id => "37"
      assigns(:profiles).should eq([mock_profile])
    end
  end

  describe "GET edit approval" do
    it "assigns the requested user as @user" do
      User.stub(:find).with("37") { mock_user }
      get :edit_approval, :id => "37"
      assigns(:user).should be(mock_user)
    end
    it "assigns the list of all profiles as @profiles" do
      User.stub(:find).with("37") { mock_user }
      Profile.stub(:by_name) { [mock_profile] }
      get :edit_approval, :id => "37"
      assigns(:profiles).should eq([mock_profile])
    end
  end

  describe "PUT update profile" do
    it "updates the requested user" do
      User.should_receive(:find).with("37") { mock_user }
      mock_user.should_receive(:profile_id=).with("1")
      put :update_profile, :id => "37", :user => { :profile_id => 1 }
    end

    it "redirects to the user page" do
      User.stub(:find) { mock_user(:update_attributes => true) }
      put :update_profile, :id => "1", :user => { :profile_id => 1 }
      response.should redirect_to(user_path(mock_user))
    end
  end

  describe "PUT approve" do
    it "approves the requested user and updates the profile" do
      User.should_receive(:find).with("37") { mock_user }
      mock_user.should_receive(:profile_id=).with("1")
      mock_user.should_receive(:approve_access_request)
      put :approve, :id => "37", :user => { :profile_id => 1 }
    end

    it "redirects to the access requests page" do
      User.stub(:find) { mock_user(:update_attributes => true) }
      put :approve, :id => "1", :user => { :profile_id => 1 }
      response.should redirect_to(access_requests_users_path)
    end
  end

end