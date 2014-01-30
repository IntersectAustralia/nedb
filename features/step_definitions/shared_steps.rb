Then /^I should see "([^"]*)" table with$/ do |table_id, expected_table|
  compare_tables(table_id, expected_table)
end

Then /^I should see field "([^"]*)" with value "([^"]*)"$/ do |field, value|
  # this assumes you're using the helper to render the field when sets the div id based on the field name
  div_id = field.tr(" ,", "_").downcase
  div_scope = "\"div#display_#{div_id}\""
  with_scope(div_scope) do
    page.should have_content(field)
    page.should have_content(value)
  end
end

Then /^I should see button "([^"]*)"$/ do |arg1|
  page.should have_xpath("//input[@value='#{arg1}']")
end

Then /^I should see image "([^"]*)"$/ do |arg1|
  page.should have_xpath("//img[contains(@src, #{arg1})]")
end

Then /^I should not see button "([^"]*)"$/ do |arg1|
  page.should have_no_xpath("//input[@value='#{arg1}']")
end

Then /^I should get a security error "([^"]*)"$/ do |message|
  page.should have_content(message)
  current_path = URI.parse(current_url).path
  current_path.should == path_to("the home page")
end

Then /^I should see link "([^"]*)"$/ do |link|
  # only look within the main content so we're not looking at the nav links
  with_scope("the main content") do
    page.should have_link(link)
  end
end

Then /^I should see link "([^"]*)" inside ([^"]*)$/ do |link, scope|
  with_scope(scope) do
    page.should have_link(link)
  end
end

Then /^I should not see link "([^"]*)"$/ do |link|
  # only look within the main content so we're not looking at the nav links
  with_scope("the main content") do
    page.should_not have_link(link)
  end
end

Then /^I should not see link "([^"]*)" inside ([^"]*)$/ do |link, scope|
  with_scope(scope) do
    page.should_not have_link(link)
  end
end

When /^(?:|I )deselect "([^"]*)" from "([^"]*)"(?: within "([^"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    unselect(value, :from => field)
  end
end

Then /^pause$/ do
  puts "Press Enter to continue"
  STDIN.getc
end

Then /^I should get a file with name "([^"]*)" and content type "([^"]*)"$/ do |name, type|
  page.response_headers['Content-Type'].should == type
  page.response_headers['Content-Disposition'].should include("filename=\"#{name}\"")
  page.response_headers['Content-Disposition'].should include("attachment")
end

Then /^I should download a file with name "([^"]*)" and content type "([^"]*)"$/ do |name, type|
  page.response_headers['Content-Type'].should == type
  page.response_headers['Content-Disposition'].should include("filename=#{name}")
  page.response_headers['Content-Disposition'].should include("attachment")
end

When /^I move the label of specimen "([^"]*)" to directory "([^"]*)"$/ do |tag, new_dir|
  dir_name = Rails.root.join(new_dir)
  Dir.mkdir(dir_name) unless File.exists?(dir_name)
  file = File.open("#{dir_name}/#{tag}_label.pdf", 'wb')
  file.write(page.source.force_encoding('UTF-8'))
  file.close
end

def check_file_content(partial_content, expect_match)
  regexp = regexp(partial_content.gsub(/\s+/, '\s+'))

  reader = PDF::Reader.new(StringIO.new(page.source))
  content = reader.pages.collect(&:text).join("\n")
    if expect_match
      content.should =~ regexp
    else
      content.should_not =~ regexp
    end
end

def regexp(string_or_regexp)
  Regexp === string_or_regexp ? string_or_regexp : Regexp.compile(string_or_regexp)
end

Then /^labels.pdf should contain string "([^"]*)"$/ do |string|
  check_file_content(string, true)
end

Then /^labels.pdf should contain:$/ do |content|
  check_file_content(content, true)
end

Then /^labels.pdf should not contain string "([^"]*)"$/ do |string|
  check_file_content(string, false)
end

Then /^labels.pdf should not contain:$/ do |content|
  check_file_content(content, false)
end

Then /^scientific names should be displayed correctly for specimen "([^"]*)"$/ do |tag|
  current_det = @specimens[tag].current_determination
  name = []
  name << SpecimenNameFormatter.family_subfamily(current_det.family, current_det.sub_family, current_det.family_uncertainty, current_det.sub_family_uncertainty)
  name << SpecimenNameFormatter.tribe(current_det.tribe, current_det.tribe_uncertainty)
  name << SpecimenNameFormatter.genus(current_det.genus, current_det.genus_uncertainty, current_det.naturalised)
  name << SpecimenNameFormatter.short_name(current_det.species, current_det.species_authority, current_det.species_uncertainty)
  name << SpecimenNameFormatter.subspecies_and_authority(current_det.sub_species, current_det.sub_species_authority, current_det.subspecies_uncertainty, current_det.species)
  name << SpecimenNameFormatter.variety_and_authority(current_det.variety, current_det.variety_authority, current_det.variety_uncertainty, current_det.species)
  name << SpecimenNameFormatter.form_and_authority(current_det.form, current_det.form_authority, current_det.form_uncertainty, current_det.species)
  check_file_content(ActionView::Base.full_sanitizer.sanitize(name.join(' ')), true)
end

Then /^accession number is displayed correctly for specimen "([^"]*)"$/ do |tag|
  accession_number = "#{Setting.instance.specimen_prefix} #{@specimens[tag].id}"
  check_file_content(accession_number, true)
end

Then /^locality is displayed correctly for specimen "([^"]*)"$/ do |tag|
  locality = []
  locality << @specimens[tag].country.upcase unless @specimens[tag].country.blank?
  locality << @specimens[tag].state unless @specimens[tag].state.blank?
  locality << @specimens[tag].botanical_division unless @specimens[tag].botanical_division.blank?
  locality << @specimens[tag].locality_description unless @specimens[tag].locality_description.blank?
  check_file_content(locality.join(": "), true)
end

Then /^latitude, longitude, altitude and datum are displayed correctly for specimen "([^"]*)"$/ do |tag|
  latitude_longitude = "#{@specimens[tag].latitude_printable} #{@specimens[tag].longitude_printable}"
  check_file_content(latitude_longitude, true)

  datum_altitude = "#{@specimens[tag].altitude_with_unit} #{@specimens[tag].datum}"
  check_file_content(datum_altitude, true)
end

Then /^topography, aspect, substrate and vegetation are displayed correctly for specimen "([^"]*)"$/ do |tag|
  line = ""
  line << "#{@specimens[tag].topography}. "    unless @specimens[tag].topography.blank?
  line << "#{@specimens[tag].aspect} aspect. " unless @specimens[tag].aspect.blank?
  line << "#{@specimens[tag].substrate}. "     unless @specimens[tag].substrate.blank?
  line << "#{@specimens[tag].vegetation}."     unless @specimens[tag].vegetation.blank?
  check_file_content(line, true)
end

Then /^frequency and plant description are displayed correctly for specimen "([^"]*)"$/ do |tag|
  line = ""
  line << "#{@specimens[tag].frequency}. "        unless @specimens[tag].frequency.blank?
  line << "#{@specimens[tag].plant_description}." unless @specimens[tag].plant_description.blank?
  check_file_content(line, true)
end

Then /^items are displayed correctly for specimen "([^"]*)"$/ do |tag|
  check_file_content("#{@specimens[tag].items_comma_separated_excluding_specimen_sheet}.", true)
end

def collection_date(tag)
  collection_date = format_partial_date(@specimens[tag].collection_date_year, @specimens[tag].collection_date_month, @specimens[tag].collection_date_day)
  if collection_date.empty?
    ""
  else
    "#{collection_date}"
  end
end

Then /^collector and collection date are displayed correctly for specimen "([^"]*)"$/ do |tag|
  check_file_content("Coll.: #{@specimens[tag].collector.display_name} #{@specimens[tag].collector_number}", true)
  check_file_content(collection_date(tag), true)
end

Then /^secondary collectors are displayed correctly for specimen "([^"]*)"$/ do |tag|
  secondary_collectors = @specimens[tag].secondary_collectors.collect { |c| c.display_name }
  check_file_content(secondary_collectors.join(", "), true)
end

Then /^determiners and determination date are displayed correctly for specimen "([^"]*)"$/ do |tag|
  det_date = format_partial_date(@specimens[tag].current_determination.determination_date_year, @specimens[tag].current_determination.determination_date_month, @specimens[tag].current_determination.determination_date_day)
  determiners = @specimens[tag].current_determination.determiners_name_herbarium_id(@specimens[tag].collector.display_name, collection_date(tag).eql?(det_date)).compact
  determiners = determiners.join(", ")
  check_file_content("Det.: #{determiners.gsub(/\(/, '\(').gsub(/\)/, '\)')}", true)
  check_file_content(det_date, true)
end

Then /^replicates are displayed correctly for specimen "([^"]*)"$/ do |tag|
  reps = @specimens[tag].replicates_comma_separated
  if reps.blank?
    check_file_content("Rep.:", true)
  else
    # only put full stop at the end if there isn't already one there
    suffix = reps[-1,1] == "." ? "" : "."
    if reps.index(",") != nil
      check_file_content("Reps: #{reps}#{suffix}", true)
    else
      check_file_content("Rep.: #{reps}#{suffix}", true)
    end
  end
end

def compare_tables(table_id, expected_table)
  actual = table_contents(table_id)
  chatty_diff_table!(expected_table, actual)
end

def chatty_diff_table!(expected_table, actual, opts={})
  begin
    expected_table.diff!(actual, opts)
  rescue Cucumber::Ast::Table::Different
    puts "Tables were as follows:"
    puts expected_table
    raise
  end
end

def table_contents(table_id)
  find("table##{table_id}").all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
end

def select_from_select2(parent_div, value)
  within(parent_div) do
    # click the link that expands the options
    find('a.select2-choice').click
    # allow time to expand
    sleep(0.2)
    # find the items with the text we want and click it
    find("li.select2-result", :text => value).click
  end
end

When /^I wait for a while$/ do
  sleep(5)
end

When /^I wait for a second$/ do
  sleep(1)
end

When /^pending$/ do
  #do nothing
end

Then /^I should see the choice "([^"]*)" in the autocomplete menu$/ do |value|
  field = page.find(".ui-menu-item > .ui-corner-all", text: value)
  field.should_not be_nil
end