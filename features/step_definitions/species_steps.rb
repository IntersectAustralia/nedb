Given /^I have species/ do |table|
  table.hashes.each do |hash|
    species = Factory(:species, hash)
  end
end

Given /^species "([^"]*)" has varieties$/ do |species_name, table|
  species = Species.where(:name => species_name).first
  table.hashes.each do |hash|
    Factory(:variety, hash.merge(:species => species))
  end
end

Given /^species "([^"]*)" has subspecies$/ do |species_name, table|
  species = Species.where(:name => species_name).first
  table.hashes.each do |hash|
    Factory(:subspecies, hash.merge(:species => species))
  end
end

Given /^species "([^"]*)" has forms$/ do |species_name, table|
  species = Species.where(:name => species_name).first
  table.hashes.each do |hash|
    Factory(:form, hash.merge(:species => species))
  end
end

When /^I follow "([^"]*)" for species "([^"]*)"$/ do |link, spec|
  species = Species.where(:name => spec).first
  link_id = "#{link.downcase}_#{species.id}"
  click_link link_id
end

When /^I follow "([^"]*)" for variety "([^"]*)"$/ do |link, var|
  variety = Variety.where(:variety => var).first
  link_id = "#{link.downcase}_#{variety.id}"
  click_link link_id
end

When /^I follow "([^"]*)" for form "([^"]*)"$/ do |link, form|
  f = Form.where(:form => form).first
  link_id = "#{link.downcase}_#{f.id}"
  click_link link_id
end

When /^I follow "([^"]*)" for subspecies "([^"]*)"$/ do |link, subsp|
  subspecies = Subspecies.where(:subspecies => subsp).first
  link_id = "#{link.downcase}_#{subspecies.id}"
  click_link link_id
end

Then /^I should have no forms$/ do
  Form.all.count.should eq(0)
end

Then /^I should have no varieties$/ do
  Variety.all.count.should eq(0)
end

Then /^I should have no subspecies$/ do
  Subspecies.all.count.should eq(0)
end

Given /^I have no species$/ do
  Species.delete_all
end

When /^I have ([^"]*) species starting with "([^\"]*)"$/ do |count, text|
  num_species = count.to_i
  (1..num_species).each do |counter|
    Factory(:species, :name => "#{text}-#{"%02d" % counter}", :genus => "Genus-#{"%02d" % counter}")
  end
end

When /^I do a species search for "([^"]*)"$/ do |term|
  with_scope('the main content') do
    fill_in 'Search', :with => term
    click_button 'Search'
  end
end