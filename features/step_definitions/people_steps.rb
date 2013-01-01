Given /^I have people$/ do |table|
  table.hashes.each do |hash|
    Factory(:person, hash)
  end
end

Given /^I have a Person$/ do |table|
  table.hashes.each do |hash|
    Factory(:person, hash)
  end
end

Given /^I have no people$/ do
  Person.delete_all
end

Given /^the person "([^"]*)" has a specimen$/ do |email|
  person = Person.find_by_email(email)
  Factory(:specimen, :collector => person)
end

Given /^the person "([^"]*)" has a confirmation/ do |email|
  person = Person.find_by_email(email)
  determination = Determination.create!(:specimen => Factory(:specimen, :collector => person), :determination_date_year => 2010, :determiners => [person])
  person.confirmations.create!(:determination => determination, :confirmation_date_year => 2010, :specimen => Factory(:specimen, :collector => person))
end

Given /^the person "([^"]*)" has a determination/ do |email|
  person = Person.find_by_email(email)
  Determination.create!(:specimen => Factory(:specimen, :collector => person), :determination_date_year => 2010, :determiners => [person])

end

When /^I do a quick search for person "([^"]*)"$/ do |search_term|
  term = search_term
  fill_in "people_search", :with => term
  click_button "search_people_button"
end

Then /^the people table should contain$/ do |expected_table|
  compare_tables('people_table', expected_table)
end

When /^I follow the view link for person "([^"]*)"$/ do |email|
  person = Person.find_by_email(email)
  click_link "view_#{person.id}"
  end

When /^I follow the edit link for person "([^"]*)"$/ do |email|
  person = Person.find_by_email(email)
  click_link "edit_#{person.id}"
end

When /^I follow the delete link for person "([^"]*)"$/ do |email|
  person = Person.find_by_email(email)
  click_link "delete_#{person.id}"
end