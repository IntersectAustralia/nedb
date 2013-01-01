# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :subspecies do |f|
  f.subspecies "Subspecies"
  f.authority "Subspecies Authority"
  f.association :species, :factory => :species
end
