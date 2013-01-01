Given /^I have a user "([^"]*)"$/ do |email|
  Factory(:user, :email => email, :password => "Pas$w0rd", :status => 'A')
end

Given /^I have a user "([^"]*)" with profile "([^"]*)"$/ do |email, profile|
  user = Factory(:user, :email => email, :password => "Pas$w0rd", :status => 'A')
  profile = Profile.where(:name => profile).first
  user.profile_id = profile.id
  user.save!
end

Given /^I am logged in as "([^"]*)"$/ do |email|
  visit path_to("the login page")
  fill_in("user_email", :with => email)
  fill_in("user_password", :with => "Pas$w0rd")
  click_button("Log in")
end

Given /^I have no users$/ do
  User.delete_all
end

Then /^I should be able to log in with "([^"]*)" and "([^"]*)"$/ do |email, password|
  visit path_to("the logout page")
  visit path_to("the login page")
  fill_in("user_email", :with => email)
  fill_in("user_password", :with => password)
  click_button("Log in")
  page.should have_content('Logged in successfully.')
  current_path.should == path_to('the home page')
end
