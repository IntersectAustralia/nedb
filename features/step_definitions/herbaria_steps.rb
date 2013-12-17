Given /^I have a Herbarium$/ do |table|
  table.hashes.each do |hash|
    Factory(:herbaria, hash)
  end
end

Given /^I have no herbaria$/ do
  Herbarium.delete_all
end

Then /^the herbaria table should contain$/ do |expected_table|
  compare_tables('herbaria_table', expected_table)
end

When /^I follow the edit link for herbarium "([^"]*)"$/ do |code|
  herbarium = Herbarium.find_by_code(code)
  click_link "edit_#{herbarium.id}"
end