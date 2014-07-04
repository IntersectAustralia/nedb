# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :botanical_division do |f|
    f.state_id 1
    f.name "MyString"
  end
end
