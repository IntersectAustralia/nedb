# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do |f|
    f.sequence(:name) { |n| "profile-#{n}" }
  end
end
