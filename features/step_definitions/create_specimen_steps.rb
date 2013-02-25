Given /^I add a new specimen$/ do
  visit path_to('the home page')
  click_link('Add')
  select_from_select2('#collector_field', 'G.R. Adams')
  fill_in('Collector number', :with => '5')
  fill_in('specimen_collection_date_day', :with => '25')
  fill_in('specimen_collection_date_month', :with => '3')
  fill_in('specimen_collection_date_year', :with => '2010')
  select_from_select2('#country_field', 'Australia')
  select_from_select2('#state_field', 'New South Wales')
  select_from_select2('#botanical_division_field', 'BD2')
  fill_in('Locality description', :with => 'location')
  fill_in('specimen_latitude_degrees', :with => '1')
  fill_in('specimen_latitude_minutes', :with => '2')
  fill_in('specimen_latitude_seconds', :with => '3')
  select('N', :from => 'specimen_latitude_hemisphere')
  fill_in('specimen_longitude_degrees', :with => '4')
  fill_in('specimen_longitude_minutes', :with => '5')
  fill_in('specimen_longitude_seconds', :with => '6')
  select('W', :from => 'specimen_longitude_hemisphere')
  fill_in('Altitude', :with => '100')
  choose('specimen_point_data_gps')
  fill_in('Datum', :with => 'datum')
  fill_in('Topography', :with => 'topography')
  fill_in('Aspect', :with => 'aspect')
  fill_in('Substrate', :with => 'substrate')
  fill_in('Vegetation', :with => 'vegetation')
  fill_in('Frequency', :with => 'frequency')
  fill_in('Plant description', :with => 'plant_description')
  click_button('Create Specimen')
end

Given /^I attempt to create a second specimen$/ do
  with_scope('the nav bar') { step 'Add'}
end

Given /^the values of the first specimen are remembered$/ do
  specimen_should_contain('specimen_collection_date_day', '25')
  specimen_should_contain('specimen_collection_date_month', '3')
  specimen_should_contain('specimen_collection_date_year', '2010')
  specimen_should_contain('country_field', 'Australia')
  specimen_should_contain('state_field', 'New South Wales')
  specimen_should_contain('Locality description', 'location')
  specimen_should_contain('specimen_latitude_degrees', '1')
  specimen_should_contain('specimen_latitude_minutes', '2')
  specimen_should_contain('specimen_latitude_seconds', '3')
  specimen_should_contain('specimen_latitude_hemisphere', 'N')
  specimen_should_contain('specimen_longitude_degrees', '4')
  specimen_should_contain('specimen_longitude_minutes', '5')
  specimen_should_contain('specimen_longitude_seconds', '6')
  specimen_should_contain('specimen_longitude_hemisphere', 'W')
  specimen_should_contain('Altitude', '100')
  specimen_should_contain('Datum', 'datum')
  specimen_should_contain('Topography', 'topograpgy')
  specimen_should_contain('Aspect', 'aspect')
  specimen_should_contain('Substrate', 'substrate')
  specimen_should_contain('Vegetation', 'vegetation')
end

def specimen_should_contain(field, expected_value)
  field = find_field(field)
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  if expected_value.blank?
    field_value.should be_blank
  else
    field_value.should =~ /#{expected_value}/
  end
end