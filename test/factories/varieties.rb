# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :variety do |f|
    f.variety "Variety"
    f.authority "Variety Authority"
    f.association :species, :factory => :species
  end
end
