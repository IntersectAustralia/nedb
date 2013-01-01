# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :permission do |f|
  f.entity "MyEntity"
  f.action "MyAction"
end
