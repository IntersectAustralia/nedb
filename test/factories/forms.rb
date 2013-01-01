# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :form do |f|
  f.form "Form"
  f.authority "Form Authority"
  f.association :species, :factory => :species
end
