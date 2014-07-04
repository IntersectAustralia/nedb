# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_type do |f|
    f.sequence(:name) { |n| "item-type-#{n}" }
  end
end
