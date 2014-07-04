# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person do |f|
    f.first_name "Fred"
    f.middle_name "Bob"
    f.last_name "Smith"
    f.sequence(:initials) { |n| "#{n}" }
    f.association :herbarium
  end
end
