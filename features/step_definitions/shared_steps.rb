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
