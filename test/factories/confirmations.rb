# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :confirmation do |f|
  f.association :specimen, :factory => :specimen
  f.confirmation_date_year 2010
  f.association :confirmer, :factory => :person
end
