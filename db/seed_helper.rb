def create_countries
  Country.delete_all
  File.open(File.dirname(__FILE__) + '/seed_files/countries.csv').each_line do |line|
    country = line.split(",")[0]
    Country.create!(:name => country)
  end
end

def create_states
  State.delete_all
  File.open(File.dirname(__FILE__) + '/seed_files/states.csv').each_line do |line|
    country, state = line.chomp.split(",")
    c = Country.where(:name => country).first
    c.states.create!(:name => state)
  end
end

def create_botanical_divisions
  BotanicalDivision.delete_all
  File.open(File.dirname(__FILE__) + '/seed_files/botanical_divisions.csv').each_line do |line|
    state, bd = line.chomp.split(",")
    s = State.where(:name => state).first
    s.botanical_divisions.create!(:name => bd)
  end
end

def create_herbaria
  Herbarium.delete_all

  # this is a special case and must have code exactly as "Stud." for the special behaviour to work
  Herbarium.create!(:code => "Stud.", :name =>"UNE Student Herbarium")

  herbaria = read_hashes_from_csv('herbaria.csv')

  herbaria.each do |hash|
    Herbarium.create!(hash)
  end
end

def create_people
  Person.delete_all

  people = read_hashes_from_csv('people.csv')

  people.each do |hash|
    herbarium_code = hash["herbarium_code"]
    hash.delete("herbarium_code")

    if herbarium_code and !herbarium_code.empty?
      herbarium = Herbarium.where(:code => herbarium_code).first
      if herbarium
        Person.create!(hash.merge(:herbarium => herbarium))
      else
        Person.create!(hash)
        puts "Warning: person #{hash.display_name} was created with no herbarium as code #{herbarium_code} does not exist"
      end
    else
      Person.create!(hash)
    end

  end
end

def create_species
  Variety.delete_all
  Form.delete_all
  Subspecies.delete_all
  Species.delete_all

  species = read_hashes_from_csv('species.csv')

  species.each do |hash|
    s = Species.new(hash)
    if !s.valid?
      puts "Warning: species not valid: #{hash["name"]} due to #{s.errors}"
    else
      s.save!
    end
  end
end

def create_item_types
  ItemType.delete_all
  ItemType.create!(:name => "Specimen sheet", :create_labels => "1")
  ItemType.create!(:name => "Photo", :create_labels => "0")
  ItemType.create!(:name => "Bark", :create_labels => "0")
  ItemType.create!(:name => "Wood", :create_labels => "0")
  ItemType.create!(:name => "Pollen", :create_labels => "0")
  ItemType.create!(:name => "Fruit", :create_labels => "1")
  ItemType.create!(:name => "Seed", :create_labels => "0")
  ItemType.create!(:name => "Plants", :create_labels => "0")
  ItemType.create!(:name => "Cuttings", :create_labels => "0")
  ItemType.create!(:name => "Spirit", :create_labels => "0")
  ItemType.create!(:name => "Si gel", :create_labels => "0")
  ItemType.create!(:name => "CTAB", :create_labels => "0")
  ItemType.create!(:name => "Phytochem", :create_labels => "0")
end

def create_uncertainty_types
  UncertaintyType.delete_all
  UncertaintyType.create!(:uncertainty_type => "?")
  UncertaintyType.create!(:uncertainty_type => "sens. strict.")
  UncertaintyType.create!(:uncertainty_type => "sens. lat.")
  UncertaintyType.create!(:uncertainty_type => "vel. aff.")
  UncertaintyType.create!(:uncertainty_type => "aff.")
end

def create_profiles_and_permissions
  Permission.delete_all
  Profile.delete_all

  Profile.create!(:name => "Superuser")
  Profile.create!(:name => "Administrator")
  Profile.create!(:name => "Student")
  Profile.create!(:name => "ReadOnly")

  create_permission("Specimen", "request_deaccession", ["Superuser", "Administrator"])
  create_permission("Specimen", "approve_deaccession", ["Superuser"])
  create_permission("Specimen", "unflag_deaccession",  ["Superuser"])
  create_permission("Specimen", "view_deaccessioned",  ["Superuser"])
  create_permission("Specimen", "download_zip",  ["Superuser", "Administrator", "Student", "ReadOnly"])
  create_permission("Specimen", "create_not_needing_review",  ["Superuser", "Administrator"])
  create_permission("Specimen", "mark_as_reviewed",  ["Superuser"])
  create_permission("Specimen", "view_needing_review",  ["Superuser", "Administrator"])

  create_permission("Specimen", "read",                   ["Superuser", "Administrator", "Student", "ReadOnly"])
  create_permission("Specimen", "create",                 ["Superuser", "Administrator", "Student"])
  create_permission("Specimen", "update",                 ["Superuser", "Administrator", "Student"])
  create_permission("Specimen", "update_replicates",      ["Superuser", "Administrator", "Student"])
  create_permission("Specimen", "update_specimen_images", ["Superuser", "Administrator", "Student"])
  create_permission("Specimen", "add_item",               ["Superuser", "Administrator", "Student"])

  create_permission("Determination", "read",   ["Superuser", "Administrator", "Student", "ReadOnly"])
  create_permission("Determination", "create", ["Superuser", "Administrator", "Student"])
  create_permission("Determination", "update", ["Superuser", "Administrator", "Student"])

  create_permission("SpecimenImage", "read",          ["Superuser", "Administrator", "Student", "ReadOnly"])
  create_permission("SpecimenImage", "create",        ["Superuser", "Administrator", "Student"])
  create_permission("SpecimenImage", "update",        ["Superuser", "Administrator", "Student"])
  create_permission("SpecimenImage", "download",        ["Superuser", "Administrator", "Student"])
  create_permission("SpecimenImage", "display_image", ["Superuser", "Administrator", "Student", "ReadOnly"])
  create_permission("SpecimenImage", "destroy",       ["Superuser"])

  create_permission("Confirmation", "read",   ["Superuser", "Administrator", "Student", "ReadOnly"])
  create_permission("Confirmation", "create", ["Superuser", "Administrator", "Student"])
  create_permission("Confirmation", "update", ["Superuser", "Administrator", "Student"])

  create_permission("Item", "destroy", ["Superuser", "Administrator", "Student"])

  create_permission("Person", "read", ["Superuser", "Administrator"])
  create_permission("Person", "create", ["Superuser"])
  create_permission("Person", "update", ["Superuser"])
  create_permission("Person", "destroy", ["Superuser"])

  create_permission("Herbarium", "read", ["Superuser", "Administrator"])
  create_permission("Herbarium", "create", ["Superuser"])
  create_permission("Herbarium", "update", ["Superuser"])

  create_permission("Species", "read", ["Superuser", "Administrator"])
  create_permission("Species", "create", ["Superuser"])
  create_permission("Species", "update", ["Superuser"])
  create_permission("Species", "destroy", ["Superuser"])

  create_permission("Variety", "read", ["Superuser", "Administrator"])
  create_permission("Variety", "create", ["Superuser"])
  create_permission("Variety", "update", ["Superuser"])
  create_permission("Variety", "destroy", ["Superuser"])

  create_permission("Form", "read", ["Superuser", "Administrator"])
  create_permission("Form", "create", ["Superuser"])
  create_permission("Form", "update", ["Superuser"])
  create_permission("Form", "destroy", ["Superuser"])

  create_permission("Subspecies", "read", ["Superuser", "Administrator"])
  create_permission("Subspecies", "create", ["Superuser"])
  create_permission("Subspecies", "update", ["Superuser"])
  create_permission("Subspecies", "destroy", ["Superuser"])

  create_permission("User", "read", ["Superuser", "Administrator"])
  create_permission("User", "update_profile", ["Superuser"])
  create_permission("User", "activate_deactivate", ["Superuser"])
  create_permission("User", "view_access_requests", ["Superuser", "Administrator"])
  create_permission("User", "reject", ["Superuser"])
  create_permission("User", "approve", ["Superuser"])

end

def create_permission(entity, action, profiles)
  permission = Permission.new(:entity => entity, :action => action)
  permission.save!
  profiles.each do |profile_name|
    profile = Profile.where(:name => profile_name).first
    profile.permissions << permission
    profile.save!
  end
end

def read_hashes_from_csv(file_name)
  csv_data = CSV.read (File.dirname(__FILE__) + '/seed_files/' + file_name)
  headers = csv_data.shift.map {|i| i.to_s }
  string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
  string_data.map {|row| Hash[*headers.zip(row).flatten] }
end


