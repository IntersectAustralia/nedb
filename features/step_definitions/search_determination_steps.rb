Given /^I search for species "([^\"]*)"/ do |term|
  select('Species', :from => 'level')
  fill_in('term', :with => term)
  first(:button, 'determination_submit').click
end