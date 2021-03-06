require File.join(Rails.root, 'db/seed_helper.rb')

Given /^I have access requests$/ do |table|
  table.hashes.each do |hash|
    FactoryGirl.create(:user, hash.merge(:status => 'U'))
  end
end

Given /^I have users$/ do |table|
  table.hashes.each do |hash|
    FactoryGirl.create(:user, hash.merge(:status => 'A'))
  end
end

Given /^I have profiles$/ do |table|
  table.hashes.each do |hash|
    FactoryGirl.create(:profile, hash)
  end
end

Given /^I have permissions$/ do |table|
  table.hashes.each do |hash|
    create_permission_from_hash(hash)
  end
end

def create_permission_from_hash(hash)
  create_permission(hash[:entity], hash[:action], hash[:profiles].split(", "))
end

Given /^"([^"]*)" has profile "([^"]*)"$/ do |email, profile|
  user = User.where(:email => email).first
  profile = Profile.where(:name => profile).first
  user.profile = profile
  user.save!(:validate => false)
end

When /^I follow "Approve" for "([^"]*)"$/ do |email|
  user = User.where(:email => email).first
  click_link("approve_#{user.id}")
end

When /^I follow "Reject" for "([^"]*)"$/ do |email|
  user = User.where(:email => email).first
  click_link("reject_#{user.id}")
end

When /^I follow "Reject as Spam" for "([^"]*)"$/ do |email|
  user = User.where(:email => email).first
  click_link("reject_as_spam_#{user.id}")
end

When /^I follow "View Details" for "([^"]*)"$/ do |email|
  user = User.where(:email => email).first
  click_link("view_#{user.id}")
end

When /^I follow "Edit Profile" for "([^"]*)"$/ do |email|
  user = User.where(:email => email).first
  click_link("edit_profile_#{user.id}")
end

Given /^"([^"]*)" is deactivated$/ do |email|
  user = User.where(:email => email).first
  user.deactivate
end

Given /^"([^"]*)" is pending approval$/ do |email|
  user = User.where(:email => email).first
  user.status = "U"
  user.save!
end

Given /^"([^"]*)" is rejected as spam$/ do |email|
  user = User.where(:email => email).first
  user.reject_access_request
end
