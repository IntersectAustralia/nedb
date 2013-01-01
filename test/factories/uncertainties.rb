# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :uncertainty do |f|
  f.field "MyString"
  f.determination nil
  f.uncertainty_type nil
end
