# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission do |f|
    f.entity "MyEntity"
    f.action "MyAction"
  end
end
