require "cancan/matchers"
require 'spec_helper'

describe Ability do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.profile = FactoryGirl.create(:profile)
    @user.profile.permissions = []
  end
  
  def new_permission(entity, action)
    FactoryGirl.create(:permission, :entity => entity, :action => action)
  end

  describe "Translates permissions into abilities" do
    it "should translate permissions from user directly to abilities" do
      @user.profile.permissions << new_permission("Determination", "create")
      @user.profile.permissions << new_permission("Determination", "read")

      ability = Ability.new(@user)
      ability.should be_able_to(:create, Determination)
      ability.should be_able_to(:read, Determination)
      ability.should_not be_able_to(:xyz, Determination)
    end
  end
  
  describe "Aliases edit_replicates to update_replicates" do
    it "should translate permissions from user directly to abilities" do
      @user.profile.permissions << new_permission("Specimen", "update_replicates")
      ability = Ability.new(@user)
      ability.should be_able_to(:edit_replicates, Specimen)
      ability.should be_able_to(:update_replicates, Specimen)
    end
  end
  
  describe "Has no abilities if no permissions" do
    it "should have no abilities if profile null" do
      @user.profile = nil
      ability = Ability.new(@user)
      ability.should_not be_able_to(:read, Determination)
    end
    it "should have no abilities if profile null" do
      @user.profile.permissions = []
      ability = Ability.new(@user)
      ability.should_not be_able_to(:read, Determination)
    end
  end
  
  describe "Should add special condition to specimen permissions if user doesn't have permission to see de-accessioned" do
    
    context "Does have permissions to see de-accessioned" do 
      before (:each) do
        @user.profile.permissions << new_permission("Specimen", "read")
        @user.profile.permissions << new_permission("Specimen", "view_deaccessioned")
      end
      
      it "should be able to do stuff to normal specimens" do
        ability = Ability.new(@user)
        ability.should be_able_to(:read, FactoryGirl.create(:specimen))
      end
      
      it "should be able to generally do stuff at class level" do
        ability = Ability.new(@user)
        ability.should be_able_to(:read, Specimen)
      end
      
      it "should be able to do stuff to de-accessioned specimens" do
        ability = Ability.new(@user)
        ability.should be_able_to(:read, FactoryGirl.create(:specimen, :status => "DeAcc"))
      end
    end
    
    context "Does not have permissions to see de-accessioned" do 
      it "should be able to do stuff to normal specimens" do
        @user.profile.permissions << new_permission("Specimen", "read")
        ability = Ability.new(@user)
        ability.should be_able_to(:read, FactoryGirl.create(:specimen))
      end
      
      it "should be able to generally do stuff at class level" do
        @user.profile.permissions << new_permission("Specimen", "read")
        ability = Ability.new(@user)
        ability.should be_able_to(:read, Specimen)
      end
      
      it "should NOT be able to do stuff to de-accessioned specimens" do
        @user.profile.permissions << new_permission("Specimen", "read")
        ability = Ability.new(@user)
        ability.should_not be_able_to(:read, FactoryGirl.create(:specimen, :status => "DeAcc"))
      end
    end
  end
end