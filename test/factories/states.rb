# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :state do |f|
    f.country_id 1
    f.name "MyString"
  end
end
