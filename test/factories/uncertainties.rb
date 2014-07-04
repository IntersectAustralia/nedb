# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :uncertainty do |f|
    f.field "MyString"
    f.determination nil
    f.uncertainty_type nil
  end
end
