# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :specimen do |f|
    f.association :collector, :factory => :person
    f.collector_number "1234"
    f.collection_date_year 2010
    f.country "Australia"
    f.state "New South Wales"
    f.botanical_division "Central Tablelands"
    f.locality_description "Royal National Park"
    f.altitude "1555"
    f.point_data "GPS"
    f.datum "WGS-84"
    f.topography "topography"
    f.aspect "aspect"
    f.substrate "substrate"
    f.vegetation "vege"
    f.frequency "freq"
    f.plant_description "plant desc"
    f.needs_review false
    f.legacy false
  end
end
