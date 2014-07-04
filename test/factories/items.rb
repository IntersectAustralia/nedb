# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do |f|
    f.association :specimen
    f.association :item_type
  end
end
