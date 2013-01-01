# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :herbarium do |f|
  f.sequence(:code) { |n| "H#{n}" }
  f.name "NCW Beadle Herbarium"
end
