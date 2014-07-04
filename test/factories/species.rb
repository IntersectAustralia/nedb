# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :species do |f|
    f.sequence(:name) { |n| "species-#{n}" }
    f.sequence(:genus) { |n| "genus-#{n}" }
    f.authority("Auth")
  end
end
