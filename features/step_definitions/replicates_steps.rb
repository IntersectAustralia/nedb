Given /^the specimen has replicates$/ do |table|
  reps = []
  table.hashes.each do |hash|
    herbarium = Herbarium.where(:code => hash[:code]).first
    reps << herbarium
  end
  @created_specimen.replicates = reps
end

Then /^I should only see replicates$/ do |table|
  # first check that there's the correct number of items in the list
  all('#reps span.rep').count.should eq(table.hashes.size)
  # then check the list items are as expected
  table.hashes.each do |hash|
    with_scope('the replicates') do
      page.should have_content(hash[:code])
      page.should have_content(hash[:name])
    end
  end
end

Then /^I should see no replicates$/ do
  all('#reps span.rep').count.should eq(0)
end

