Given /^I have no specimens$/ do
  Specimen.delete_all
end

Then /^I should have ([0-9]+) specimen$/ do |count|
  Specimen.count.should == count.to_i
end

Given /^I have a specimen$/ do
  @created_specimen = Factory(:specimen)
end

Given /^I have (\d+) specimens$/ do |number|
  number.to_i.times do |n|
    Factory(:specimen, :botanical_division => "BotDiv #{n+1}.")
  end
end

Given /^I have a specimen that needs review$/ do
  @created_specimen = Factory(:specimen, :needs_review => true)
end

Given /^I have item types (.+)$/ do |types|
  types.split(', ').each do |type|
    labellable_types = ['Fruit', 'Specimen sheet']
    labellable = labellable_types.include?(type)
    ItemType.create!(:name => type, :create_labels => labellable)
  end
end

Given /^I have specimens$/ do |table|

  table.hashes.each do |hash|
    hash.delete('tag')
    Factory(:specimen, hash)
    @specimens[hash['tag']] = @specimen if hash['tag']
  end
end

Given /^I have herbaria$/ do |table|
  table.hashes.each do |hash|
    Herbarium.create!(hash)
  end
end

Given /^I have countries$/ do |table|
  table.hashes.each do |hash|
    Country.create!(hash)
  end
end

Given /^I have states$/ do |table|
  table.hashes.each do |hash|
    country = hash[:country]
    state = hash[:name]
    c = Country.where(:name => country).first
    c.states.create!(:name => state)
  end
end

Given /^I have botanical divisions$/ do |table|
  table.hashes.each do |hash|
    state = hash[:state]
    bd = hash[:name]
    s = State.where(:name => state).first
    s.botanical_divisions.create!(:name => bd)
  end
end

Then /^I should see items table$/ do |expected_table|
  compare_tables('items_table', expected_table)
end

When /^I do a quick search by id for specimen "([^"]*)"$/ do |tag|
  quick_search(@specimens[tag].id.to_s)
end

When /^I do a quick search for "([^"]*)"$/ do |search_term|
  term = search_term

  #allow subsititution of current specimen id
  if (search_term.include?("%current_specimen%"))
    term = search_term.gsub("%current_specimen%", @created_specimen.id.to_s)
  end
  quick_search(term)
end

When /^I search for "([^"]*)" by id$/ do |tag|
  quick_search(@specimens[tag].id.to_s)
end

def quick_search(term)
  fill_in('Quick Search', :with => term)
  click_button 'search_button'
end

Then /^the country dropdown should contain$/ do |table|
  with_scope('the country select') do
    # click the link that expands the options
    find('a.select2-choice').click
    # allow time to expand
    sleep(0.2)
    table.hashes.each do |hash|
      page.should have_content(hash[:name])
    end
  end
end

Then /^the selected country should be "([^"]*)"$/ do |arg1|
  pending
end

Then /^I should see a determination table with$/ do |expected_table|
  compare_tables('determination_table', expected_table)
end

Given /^the specimen has a determination with string "([a-zA-Z]*)"$/ do |value|
  attr = {:determiners => [Factory(:person)], :determination_date_year => '2010', :species => value}
  @determination = @created_specimen.determinations.create!(attr.merge({:sub_family => ''}))
end

Given /^"([^"]*)" has a determination with string "([^"]*)"$/ do |tag, value|
  attr = {:determiners => [Factory(:person)], :determination_date_year => '2010', :species => value}
  @specimens[tag].determinations.create!(attr.merge({:sub_family => ''}))
end

Given /^"([^"]*)" has a legacy determination with string "([^"]*)"$/ do |tag, value|
  attr = {:determiners => [Factory(:person)], :determination_date_year => '2010', :species => value, :legacy => true}
  @specimens[tag].determinations.create!(attr.merge({:sub_family => ''}))
end

Given /^"([^"]*)" has a confirmation$/ do |tag|
  attr = {:confirmer => Factory(:person), :confirmation_date_year => '2010', :determination => @specimens[tag].determinations.first}
  @specimens[tag].confirmations.create!(attr)
end

Given /^"([^"]*)" has a legacy confirmation$/ do |tag|
  attr = {:confirmer => Factory(:person), :confirmation_date_year => '2010', :determination => @specimens[tag].determinations.first, :legacy => true}
  @specimens[tag].confirmations.create!(attr)
end

Given /^the specimen has a determination with string "([a-zA-Z]*)" on "(\d\d)\/(\d\d)\/(\d\d\d\d)"$/ do |value, day, month, year|
  attr = {:determiners => [Factory(:person)], :determination_date_day => day, :determination_date_month => month, :determination_date_year => year, :species => value}
  @determination = @created_specimen.determinations.create!(attr.merge({:sub_family => ''}))
end

Given /^"([^"]*)" has a determination with string "([a-zA-Z]*)" on "(\d\d)\/(\d\d)\/(\d\d\d\d)"$/ do |tag, value, day, month, year|
  attr = {:determiners => [Factory(:person)], :determination_date_day => day, :determination_date_month => month, :determination_date_year => year, :species => value}
  @determination = @specimens[tag].determinations.create!(attr.merge({:sub_family => ''}))
end

Then /^the search result table should contain$/ do |expected_table|
  compare_tables('search_results_table', expected_table)
end

Then /^the advanced search result table should contain$/ do |expected_table|
  compare_tables('adv_search_results_table', expected_table)
end

Then /^the advanced search result table should not contain$/ do |expected_table|
  !(expected_table.diff!(tableish('table#adv_search_results_table tr', 'td,th')))
end


When /^I create a new specimen$/ do
  visit path_to("the new specimen page")
  select("G.R. Adams", :from => "Collector")
  fill_in("specimen_collector_number", :with => "100")
  select("New South Wales", :from => "State")
  select("BD2", :from => "specimen_botanical_division")
  fill_in("Locality description", :with => "LD")
  fill_in("Altitude", :with => "100")
  choose('specimen_point_data_gps')
  fill_in("Datum", :with => "D")
  fill_in("Topography", :with => "T")
  fill_in("Aspect", :with => "A")
  fill_in("Substrate", :with => "S")
  fill_in("Vegetation", :with => "V")
  fill_in("Frequency", :with => "F")
  fill_in("Plant description", :with => "PD")
  fill_in("specimen_collection_date_day", :with => "10")
  fill_in("specimen_collection_date_month", :with => "10")
  fill_in("specimen_collection_date_year", :with => "2010")
  click_button("Create Specimen")
end

Given /^I have legacy specimen "([^"]*)"$/ do |tag|
  herbarium = Factory(:herbarium, :code => "ABC") #a code thats not been taken
  person = Factory(:person, :herbarium => herbarium)
  @specimens ||= {}
  @specimens[tag] = Factory(:specimen, :collector => person, :legacy => true)
end

Then /^the specimen needs review/ do
  page.should have_content("Needs Review: ")
end

Then /^the specimen is marked as not needing review$/ do
  page.should_not have_content("Needs Review: ")
end

Given /^I have specimen "([^"]*)" with status "([^"]*)"$/ do |tag, status|
  @specimens ||= {}
  @specimens[tag] = Factory(:specimen, :status => status)
end

Given /^I have specimen "([^"]*)"$/ do |tag|
  @specimens ||= {}
  @specimens[tag] = Factory(:specimen)
end

When /^I have an uncertainty type "([^\"]*)"$/ do |uncertainty_type|
  @created_uncertainties ||= []
  @created_uncertainties << Factory(:uncertainty_type, :uncertainty_type => uncertainty_type)
end

Then /^the determination has species uncertainty "([^\"]*)"$/ do |uncertainty_type|
  determination = Determination.find(@determination.id)
  determination.species_uncertainty.should eq(uncertainty_type)
end

Then /^the determination does not have species uncertainty "([^\"]*)"$/ do |uncertainty_type|
  determination = Determination.find(@determination.id)
  determination.species_uncertainty.should_not eq(uncertainty_type)
end

Given /^the determination species uncertainty is "([^\"]*)"$/ do |uncertainty_type|
  determination = Determination.find(@determination.id)
  determination.species_uncertainty= uncertainty_type
end

When /^I sleep for "([^"]*)" seconds$/ do |time|
  sleep time.to_i
end

Given /^I have enough static data to create specimens$/ do
  Factory(:person, :initials => "J.J.", :last_name => "Adams")

  aus = Factory(:country, :name => "Australia")
  Factory(:country, :name => "Belize")

  nsw = Factory(:state, :name => "New South Wales", :country => aus)
  Factory(:state, :name => "Tasmania", :country => aus)

  Factory(:botanical_division, :name => "BD1", :state => nsw)
  Factory(:botanical_division, :name => "BD2", :state => nsw)

  Factory(:item_type, :name => "Specimen sheet")
end

Given /^"([^"]*)" has an item$/ do |tag|
  specimen = @specimens[tag]
  item_type = ItemType.first
  specimen.items.create!(:item_type => item_type)
end

Given /^"([^"]*)" has an item of type "([^"]*)"$/ do |tag, item_type|
  specimen = @specimens[tag]
  item_type = ItemType.find_by_name(item_type)
  specimen.items.create!(:item_type => item_type)
end

When /^the specimen title should include "([^\"]*)"$/ do |title|
  within('#specimen_name') do
    page.should have_content(title)
  end
end

When /^"([^\"]*)" has an image$/ do |tag|
  specimen = @specimens[tag]
  specimen.specimen_images.create!(:description => "Test description", :image_file_name => "test/picture.jpg", :user => Factory(:user))
end

#When /^I am on the specimen page for "([^\"]*)"$/ do |collection_number|
#  specimen = Specimen.find_all_by_collector_number(collection_number)
#  visit path_to(specimen)
#end

When /^I select "([^"]*)" from the collector select$/ do |value|
  select_from_select2('#collector_field', value)
end

When /^I select "([^"]*)" from the country select$/ do |value|
  select_from_select2('#country_field', value)
end

When /^I select "([^"]*)" from the state select$/ do |value|
  select_from_select2('#state_field', value)
end

When /^I select "([^"]*)" from the botanical division select$/ do |value|
  select_from_select2('#botanical_division_field', value)
end

When /^(?:|I )fill in "([^"]*)" with an existing accession number$/ do |field|
  # make sure there is at least on specimen
  # options = {"collector_id"=>"1554", "collection_date_year"=>"2010", "latitude_hemisphere"=>"S", "longitude_hemisphere"=>"E"}
  # specimen = Specimen.new options
  # specimen.save
  value = Specimen.first.id
  fill_in(field, :with => value)
end

When /^(?:|I )fill in "([^"]*)" with an available accession number$/ do |field|
  value = Specimen.first.id
  Specimen.first.destroy
  fill_in(field, :with => value)
end

When /^(?:|I )fill in "([^"]*)" with an accession number that's out of range$/ do |field|
  value = Specimen.last.id + 10
  fill_in(field, :with => value)
end