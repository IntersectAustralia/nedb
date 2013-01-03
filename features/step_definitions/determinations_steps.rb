And /^I should see uncertainty radio buttons for "([^"]*)"$/ do |field, table|
  table.hashes.each do |hash|
    with_scope("\"#display_#{field}_uncertainty\"") do
      page.should have_content(hash[:uncertainty])
    end
  end
end

When /^I check the (\d+)(st|nd|rd|th) checkbox with the value "([^"]*)"$/ do |index, junk,   value|
  page.all("input[value='#{value}']")[index.to_i-1].check
end

When /^the specimen has determination$/ do |table|
  param_hash = {}
  vals = table.raw
  person = nil
  vals.each do |row|
    key = row[0]
    val = row[1]
    if (key == "determiner_herbarium_code")
      herb = Herbarium.where(:code => val).first
      param_hash[:determiner_herbarium] = herb
    elsif (key == "determiner")
      name = val.to_s.split(" ")
      person = Person.where(:initials => name[0], :last_name => name[1]).first
    else
      param_hash[key] = val
    end
  end
  @det = @created_specimen.determinations.new(param_hash)
  @det.determiners = [person]
  @det.save!
end

Then /^the determination record should have$/ do |table|
  det = Determination.find(@det.id)
  vals = table.raw
  vals.each do |row|
    key = row[0]
    val = row[1]
    det.send(key).should eq(val)
  end
end

Given /^I am at step 2 of adding a determination$/ do
  visit path_to("the specimen page")
  click_link("Add Determination")
  fill_in("determination_determination_date_year", :with => "2010")

  select_determiner('G.R. Adams')
  select_determiner('F.G. Wells')

  click_button("Continue")
end


Given /^I am at step 2 of editing a determination$/ do
  visit path_to("the specimen page")
  click_link("Edit determination")
  fill_in("determination_determination_date_year", :with => "1979")
  fill_in("determination_determination_date_month", :with => "")
  fill_in("determination_determination_date_day", :with => "")
  select_determiner('G.R. Adams')
  select_determiner('F. Wells')
  unselect_determiner("H.C. Smith")
  select("NSW - NSW Botanical Gardens", :from => "Determiner herbarium")
  click_button("Continue")
end

Then /^the "Subspecies" select should be set to "([^\"]*)"$/ do |text|
  select = find(:xpath, XPath::HTML.select("Subspecies"))
  select_val = select.value
  subsp = Subspecies.find(select_val)
  subsp.display_name.should eq(text)
end

Then /^the "Variety" select should be set to "([^\"]*)"$/ do |text|
  select = find(:xpath, XPath::HTML.select("Variety"))
  select_val = select.value
  var = Variety.find(select_val)
  var.display_name.should eq(text)
end

Then /^the "Form" select should be set to "([^\"]*)"$/ do |text|
  select = find(:xpath, XPath::HTML.select("Form"))
  select_val = select.value
  form = Form.find(select_val)
  form.display_name.should eq(text)
end

When /^I select "([^"]*)" from the determiners select$/ do |determiner|
  select_determiner(determiner)
end

When /^I deselect "([^"]*)" from the determiners select$/ do |determiner|
  unselect_determiner(determiner)
end

def select_determiner(determiner)
  input = find(".select2-search-field input[type=text]")
  input.click
  input.set(determiner)
  sleep(0.5)
  find(".select2-result", :text => determiner).click
  sleep(0.5)
end

def unselect_determiner(determiner)
  parent = find(".select2-search-choice", :text => determiner)
  parent.find(".select2-search-choice-close").click
end

When /^I select the first result in the species search results$/ do
  with_scope('"#search_results"') do
    links = all("a")
    links.first.click
  end
end

When /^I check the species uncertainty checkbox with the value "([^"]*)"$/ do |label|
  with_scope('species uncertainty checkboxes') do
    # for some reason check(label) doesn't work
    label_element = find("label", :text => label)
    checkbox = find("input##{label_element[:for]}")
    checkbox.set(true)
  end
end