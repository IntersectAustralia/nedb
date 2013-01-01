Then /^I should get the following security outcomes$/ do |table|
  table.hashes.each do |hash|
    page_to_visit = hash[:page]
    outcome = hash[:outcome]
    message = hash[:message]
    visit path_to(page_to_visit)
    if outcome == "error"
      page.should have_content(message)
      current_path = URI.parse(current_url).path
      current_path.should == path_to("the home page")
    else
      current_path = URI.parse(current_url).path
      current_path.should == path_to(page_to_visit)
    end

  end
end

Given /^I have the usual profiles and permissions$/ do
  Factory(:profile, :name => "Superuser")
  Factory(:profile, :name => "Student")
  Factory(:profile, :name => "Administrator")

  create_permission("Specimen", "view_deaccessioned", "Superuser")
  create_permission("Specimen", "view_deaccessioned", "Superuser")
  create_permission("Specimen", "request_deaccession", "Superuser, Student")
  create_permission("Specimen", "approve_deaccession", "Superuser")
  create_permission("Specimen", "unflag_deaccession", "Superuser")
  create_permission("Specimen", "read", "Superuser, Student, Administrator")
  create_permission("Specimen", "create", "Superuser, Student")
  create_permission("Specimen", "update", "Superuser, Student")
  create_permission("Specimen", "update_replicates", "Superuser, Student")
  create_permission("Specimen", "update_specimen_images", "Superuser, Student")
  create_permission("Specimen", "add_item", "Superuser, Student")
  create_permission("SpecimenImage", "read", "Superuser, Student, Administrator")
  create_permission("SpecimenImage", "create", "Superuser, Student, Administrator")
  create_permission("SpecimenImage", "update", "Superuser, Student, Administrator")
  create_permission("SpecimenImage", "display_image", "Superuser, Student, Administrator")
  create_permission("SpecimenImage", "destroy", "Superuser, Student, Administrator")
  create_permission("Determination", "read",   "Superuser, Student")
  create_permission("Determination", "create", "Superuser, Student")
  create_permission("Determination", "update", "Superuser, Student")
  create_permission("Confirmation", "read",   "Superuser, Student")
  create_permission("Confirmation", "create", "Superuser, Student")
  create_permission("Confirmation", "update", "Superuser, Student")
  create_permission("Item", "destroy", "Superuser, Student")
  create_permission("Person", "read", "Superuser, Administrator")
  create_permission("Person", "create", "Superuser")
  create_permission("Person", "update", "Superuser")
  create_permission("Person", "destroy", "Superuser")
  create_permission("Herbarium", "read", "Superuser, Administrator")
  create_permission("Herbarium", "create", "Superuser")
  create_permission("Herbarium", "update", "Superuser")
  create_permission("Species", "read", "Superuser, Administrator")
  create_permission("Species", "create", "Superuser")
  create_permission("Species", "update", "Superuser")
  create_permission("Species", "destroy", "Superuser")
  create_permission("Variety", "read", "Superuser, Administrator")
  create_permission("Variety", "create", "Superuser")
  create_permission("Variety", "update", "Superuser")
  create_permission("Variety", "destroy", "Superuser")
  create_permission("Form", "read", "Superuser, Administrator")
  create_permission("Form", "create", "Superuser")
  create_permission("Form", "update", "Superuser")
  create_permission("Form", "destroy", "Superuser")
  create_permission("Subspecies", "read", "Superuser, Administrator")
  create_permission("Subspecies", "create", "Superuser")
  create_permission("Subspecies", "update", "Superuser")
  create_permission("Subspecies", "destroy", "Superuser")
  create_permission("User", "read", "Superuser, Administrator")
  create_permission("User", "update_profile", "Superuser")
  create_permission("User", "activate_deactivate", "Superuser")
  create_permission("User", "view_access_requests", "Superuser")
  create_permission("User", "reject", "Superuser")
  create_permission("User", "approve", "Superuser")

end

