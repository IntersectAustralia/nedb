require 'spec_helper'

describe User do
  
  describe "Associations" do
    it { should belong_to(:profile) }
  end

  describe "Named Scopes" do
    describe "Users Pending Approval Scope" do
      it "should return users that are unapproved ordered by email address" do
        u1 = FactoryGirl.create(:user, :status => 'U', :email => "fasdf1@intersect.org.au")
        u2 = FactoryGirl.create(:user, :status => 'A')
        u3 = FactoryGirl.create(:user, :status => 'U', :email => "asdf1@intersect.org.au")
        u2 = FactoryGirl.create(:user, :status => 'R')
        User.pending_approval.should eq([u3,u1])
      end
    end
    describe "Approved Users Scope" do
      it "should return users that are approved ordered by email address" do
        u1 = FactoryGirl.create(:user, :status => 'A', :email => "fasdf1@intersect.org.au")
        u2 = FactoryGirl.create(:user, :status => 'U')
        u3 = FactoryGirl.create(:user, :status => 'A', :email => "asdf1@intersect.org.au")
        u2 = FactoryGirl.create(:user, :status => 'R')
        User.approved.should eq([u3,u1])
      end
    end
  end
  
  describe "Approve Access Request" do
    it "should set the status flag to A" do
      user = FactoryGirl.create(:user, :status => 'U')
      user.approve_access_request
      user.status.should eq("A")
    end
  end
  
  describe "Reject Access Request" do
    it "should set the status flag to R" do
      user = FactoryGirl.create(:user, :status => 'U')
      user.reject_access_request
      user.status.should eq("R")
    end
  end
  
  describe "Status Methods" do
    context "Active" do
      it "should be active" do
        user = FactoryGirl.create(:user, :status => 'A')
        user.approved?.should be_true
      end
      it "should not be pending approval" do
        user = FactoryGirl.create(:user, :status => 'A')
        user.pending_approval?.should be_false
      end
    end
    
    context "Unapproved" do
      it "should not be active" do
        user = FactoryGirl.create(:user, :status => 'U')
        user.approved?.should be_false
      end
      it "should be pending approval" do
        user = FactoryGirl.create(:user, :status => 'U')
        user.pending_approval?.should be_true
      end
    end
    
    context "Rejected" do
      it "should not be active" do
        user = FactoryGirl.create(:user, :status => 'R')
        user.approved?.should be_false
      end
      it "should not be pending approval" do
        user = FactoryGirl.create(:user, :status => 'R')
        user.pending_approval?.should be_false
      end
    end
  end
  
  describe "Update password" do
    it "should fail if current password is incorrect" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "asdf", :password => "Pass.456", :password_confirmation => "Pass.456"})
      result.should be_false
      user.errors[:current_password].should eq ["is invalid"]
    end
    it "should fail if current password is blank" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "", :password => "Pass.456", :password_confirmation => "Pass.456"})
      result.should be_false
      user.errors[:current_password].should eq ["can't be blank"]
    end
    it "should fail if new password and confirmation blank" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "", :password_confirmation => ""})
      result.should be_false
      user.errors[:password].should eq ["can't be blank", "must be at least 6 characters long and contain at least one uppercase letter, one lowercase letter, one digit and one symbol"]
    end
    it "should fail if confirmation blank" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "Pass.456", :password_confirmation => ""})
      result.should be_false
      user.errors[:password].should eq ["doesn't match confirmation"]
    end
    it "should fail if confirmation doesn't match new password" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "Pass.456", :password_confirmation => "Pass.678"})
      result.should be_false
      user.errors[:password].should eq ["doesn't match confirmation"]
    end
    it "should fail if password doesn't meet rules" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "Pass4567", :password_confirmation => "Pass4567"})
      result.should be_false
      user.errors[:password].should eq ["must be at least 6 characters long and contain at least one uppercase letter, one lowercase letter, one digit and one symbol"]
    end
    it "should succeed if current password correct and new password ok" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "Pass.456", :password_confirmation => "Pass.456"})
      result.should be_true
    end
    it "should always blank out passwords" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "Pass.456", :password_confirmation => "Pass.456"})
      user.password.should be_nil
      user.password_confirmation.should be_nil
    end
  end
  
  describe "Has permission method" do
    it "should return true if the specified permission is in the list" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      user.profile = FactoryGirl.create(:profile)
      user.profile.permissions = [FactoryGirl.create(:permission, :entity => "Abc", :action => "def")]
      user.profile.has_permission("Abc", "def").should be_true
      user.profile.has_permission("Abc", "ghi").should be_false
      user.profile.has_permission("Abb", "def").should be_false
    end
    it "should return false if the permissions are empty" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      user.profile = FactoryGirl.create(:profile)
      user.profile.permissions = []
      user.profile.has_permission("Abc", "ghi").should be_false
    end
  end

  describe "Validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :status }
    
    #password rules: at least one lowercase, upppercase, number, symbol
    # too short < 6
    it { should_not allow_value("AB$9a").for(:password) }
    # too long > 20
    it { should_not allow_value("Aa0$56789012345678901").for(:password) }
    # missing upper
    it { should_not allow_value("aaa000$$$").for(:password) }
    # missing lower
    it { should_not allow_value("AAA000$$$").for(:password) }
    # missing digit
    it { should_not allow_value("AAAaaa$$$").for(:password) }
    # missing symbol
    it { should_not allow_value("AAA000aaa").for(:password) }
    # ok
    it { should allow_value("AB$9aa").for(:password) }
    
    # check each of the possible symbols we allow
    it { should allow_value("AAAaaa000!").for(:password) }
    it { should allow_value("AAAaaa000@").for(:password) }
    it { should allow_value("AAAaaa000#").for(:password) }
    it { should allow_value("AAAaaa000$").for(:password) }
    it { should allow_value("AAAaaa000%").for(:password) }
    it { should allow_value("AAAaaa000^").for(:password) }
    it { should allow_value("AAAaaa000&").for(:password) }
    it { should allow_value("AAAaaa000*").for(:password) }
    it { should allow_value("AAAaaa000(").for(:password) }
    it { should allow_value("AAAaaa000)").for(:password) }
    it { should allow_value("AAAaaa000-").for(:password) }
    it { should allow_value("AAAaaa000_").for(:password) }
    it { should allow_value("AAAaaa000+").for(:password) }
    it { should allow_value("AAAaaa000=").for(:password) }
    it { should allow_value("AAAaaa000{").for(:password) }
    it { should allow_value("AAAaaa000}").for(:password) }
    it { should allow_value("AAAaaa000[").for(:password) }
    it { should allow_value("AAAaaa000]").for(:password) }
    it { should allow_value("AAAaaa000|").for(:password) }
    it { should allow_value("AAAaaa000\\").for(:password) }
    it { should allow_value("AAAaaa000;").for(:password) }
    it { should allow_value("AAAaaa000:").for(:password) }
    it { should allow_value("AAAaaa000'").for(:password) }
    it { should allow_value("AAAaaa000\"").for(:password) }
    it { should allow_value("AAAaaa000<").for(:password) }
    it { should allow_value("AAAaaa000>").for(:password) }
    it { should allow_value("AAAaaa000,").for(:password) }
    it { should allow_value("AAAaaa000.").for(:password) }
    it { should allow_value("AAAaaa000?").for(:password) }
    it { should allow_value("AAAaaa000/").for(:password) }
    it { should allow_value("AAAaaa000~").for(:password) }
    it { should allow_value("AAAaaa000`").for(:password) }
    
  end
end
