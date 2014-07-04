# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :herbarium do |f|
    f.sequence(:code) { |n| "H#{n}" }
    f.name "NCW Beadle Herbarium"
  end
end
