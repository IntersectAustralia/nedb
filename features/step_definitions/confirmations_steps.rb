When /^I click on the confirmers select box$/ do
  input = find("#confirmation_confirmer_id + div .select2-choice")
  input.click
end

When /^I click on the confirmer's herbarium select box$/ do
  input = find("#confirmation_confirmer_herbarium_id + div .select2-choice")
  input.click
end

When /^I select "([^"]*)" from the confirmers select$/ do |confirmer|
  select_confirmer(confirmer)
end

When /^I select "([^"]*)" from the confirmer's herbarium select$/ do |herbarium|
  select_confirmer_herbarium(herbarium)
end

When /^I fill in the confirmer search box with "([^"]*)"/ do |confirmer|
  search_confirmer(confirmer)
end

When /^I fill in the confirmer's herbarium search box with "([^"]*)"/ do |herbarium|
  search_confirmer_herbarium(herbarium)
end

When /^the specimen's determination has confirmation$/ do |table|
  param_hash = {}
  vals = table.raw
  person = nil
  vals.each do |row|
    key = row[0]
    val = row[1]
    if (key == "confirmers_herbarium")
      herb = Herbarium.where(:code => val).first
      param_hash[:confirmer_herbarium] = herb
    elsif (key == "confirmer")
      name = val.to_s.split(" ")
      person = Person.where(:initials => name[0], :last_name => name[1]).first
    else
      param_hash[key] = val
    end
  end
  @confirmation = Confirmation.new(param_hash)
  @confirmation.confirmer = person
  @created_specimen.determinations.first.confirmation = @confirmation
  @confirmation.specimen = @created_specimen.determinations.first.specimen
  @confirmation.save!
end


def select_confirmer(confirmer)
  input = find("#confirmation_confirmer_id + div .select2-results")
  input.click
  find(".select2-result", :text => confirmer).click
  sleep(0.5)
end

def select_confirmer_herbarium(herbarium)
  input = find("#confirmation_confirmer_herbarium_id + div .select2-results")
  input.click
  find(".select2-result", :text => herbarium).click
  sleep(0.5)
end

def search_confirmer(confirmer)

  input = find("#confirmation_confirmer_id + div .select2-search input[type=text]")
  input.set(confirmer)
  sleep(0.5)
end

def search_confirmer_herbarium(herbarium)
  input = find("#confirmation_confirmer_herbarium_id + div .select2-search input[type=text]")
  input.set(herbarium)
  sleep(0.5)
end