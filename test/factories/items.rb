# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :item do |f|
  f.association :specimen
  f.association :item_type
end
