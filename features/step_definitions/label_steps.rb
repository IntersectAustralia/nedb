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

Then /^accession number is displayed correctly for specimen "([^"]*)"$/ do |tag|
  accession_number = "#{Setting.instance.specimen_prefix} #{@specimens[tag].id}"
  check_file_content(accession_number, true)
end