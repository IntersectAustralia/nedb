Given /^I search for species "([^\"]*)"/ do |term|
  select('Species', :from => 'level')
  fill_in('term', :with => term)
  click_button('determination_submit')
end