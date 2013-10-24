def populate_data

  Confirmation.delete_all
  Determination.delete_all
  Item.delete_all
  Specimen.delete_all

  create_test_users
  create_test_species
  create_test_specimens
end

def create_test_users
  User.delete_all
  create_user(:email => "georgina@intersect.org.au", :first_name => "Georgina", :last_name => "Edwards", :initials => "G.C.")
  create_user(:email => "matthew@intersect.org.au", :first_name => "Matthew", :last_name => "Hillman", :initials => "M.H")
  create_user(:email => "charles@intersect.org.au", :first_name => "Charles", :last_name => "Shao", :initials => "C.S")
  create_user(:email => "admin@intersect.org.au", :first_name => "Admin", :last_name => "User", :initials => "A.U")
  create_user(:email => "student@intersect.org.au", :first_name => "Student", :last_name => "User", :initials => "S.U")
  create_user(:email => "fayette@intersect.org.au", :first_name => "Fayette", :last_name => "Fung", :initials => "F.F")
  create_unapproved_user(:email => "unapproved1@intersect.org.au", :first_name => "Unapproved", :last_name => "One", :initials => "U.O")
  create_unapproved_user(:email => "unapproved2@intersect.org.au", :first_name => "Unapproved", :last_name => "Two", :initials => "U.T")

  set_profile("georgina@intersect.org.au", "Superuser")
  set_profile("matthew@intersect.org.au", "Superuser")
  set_profile("charles@intersect.org.au", "Superuser")
  set_profile("admin@intersect.org.au", "Administrator")
  set_profile("fayette@intersect.org.au", "Administrator")
  set_profile("student@intersect.org.au", "Student")
end

def set_profile(email, profile)
  user = User.where(:email => email).first
  profile = Profile.where(:name => profile).first
  user.profile = profile
  user.save!
end

def create_user(attrs)
  u = User.new(attrs.merge(:password => "Pass.123"))
  u.activate
  u.save!
end

def create_unapproved_user(attrs)
  u = User.create!(attrs.merge(:password => "Pass.123"))
end

def create_test_species
  species_params = {}
  species_params[:authority] = "Clint Eastwood"
  species_params[:class_name] = "CE Class name"
  species_params[:division] = "CE Division"
  species_params[:family]= "CE Family"
  species_params[:genus] ="Ce genus"
  species_params[:name] = "ce Name2"
  species_params[:order_name] = "CE Order Name"
  species_params[:sub_family] = "CESub Family"
  species_params[:tribe] = "CE Tribe"

  species = Species.create!(species_params)

  Subspecies.create!(:species => species, :subspecies => "Subspecies Primera", :authority => "Don Siegel")
  Subspecies.create!(:species => species, :subspecies => "Subspecies Segunda", :authority => "Ted Post")
  Subspecies.create!(:species => species, :subspecies => "Subspecies Tercera", :authority => "James Fargo")

  Variety.create!(:species => species, :variety => "Variety Cuarenta", :authority => "Clint Eastwood")
  Variety.create!(:species => species, :variety => "Variety Cinquenta", :authority => "Clint Eastwood")
  Variety.create!(:species => species, :variety => "Variety Sesenta", :authority => "Buddy Van Horn")

  Form.create!(:species => species, :form => "Form Septima", :authority => "Matt Braxton")
  Form.create!(:species => species, :form => "Form Octava", :authority => "Harry Callahan")
  Form.create!(:species => species, :form => "Form Novena", :authority => "Tyne Daly")

end

def create_test_specimens
  all_species = Species.all
  50.times do
    spec_id = random_number(0..all_species.size-1)
    create_specimen(all_species[spec_id])
  end
end

def create_specimen(species)
  specimen = Specimen.create!(:collector => Person.first,
                              :collector_number => random_number(1000.10000).to_i.to_s,
                              :collection_date_year => random_number(1900..2010),
                              :collection_date_month => random_number(1..12),
                              :collection_date_day => random_number(1..28),
                              :country => "Australia",
                              :state => "New South Wales",
                              :botanical_division => "Central Coast",
                              :locality_description => "Royal National Park. Mt Bass Fire Trail.",
                              :latitude_degrees => 34,
                              :latitude_minutes => 6,
                              :latitude_seconds => 21,
                              :latitude_hemisphere => "S",
                              :longitude_degrees => 151,
                              :longitude_minutes => 4,
                              :longitude_seconds => 47,
                              :longitude_hemisphere => "E",
                              :altitude => random_number(0..10000),
                              :point_data => "GPS",
                              :datum => "WGS-84",
                              :topography => "Upper slope, almost level area of broad hill top",
                              :aspect => "W",
                              :substrate => "Grey sand on sandstone",
                              :vegetation => "Acacia, Sprengelia, Epacris heath--Cyperaceae herbfield with Darwinia fascicularis",
                              :frequency => "Occasional",
                              :plant_description => "Rhizomatous, tussock perennial. Plants to c. 100 cm.",
                              :legacy => false,
                              :needs_review => false)

  specimen.determinations.create!(:determiners => [random_person],
                                  :determination_date_year => random_number(1900..2010),
                                  :determination_date_month => random_number(1..12),
                                  :determination_date_day => random_number(1..28),
                                  :determiner_herbarium => random_herbarium,
                                  :division => species.division,
                                  :family => species.family,
                                  :order_name => species.order_name,
                                  :genus => species.genus,
                                  :species => species.name,
                                  :class_name => species.class_name,
                                  :family => species.family,
                                  :sub_family => species.sub_family,
                                  :species_authority => species.authority,
                                  :sub_species_authority => 'Some sub species authority',
                                  :sub_species => 'Some sub species',
                                  :variety => 'Some variety',
                                  :variety_authority => 'Some variety authority',
                                  :form => 'Some form',
                                  :form_authority => 'Some form authority',
                                  :naturalised => 'false',
                                  :legacy => false)

end


def random_person
  ppl = Person.all
  ppl[random_number(0..ppl.length-1)]
end

def random_number(range)
  Random.new.rand(range)
end

def random_herbarium
  herbs = Herbarium.all
  herbs[random_number(0..herbs.length-1)]
end