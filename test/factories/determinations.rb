# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :determination do |f|
    f.association :specimen, :factory => :specimen
    f.determiners { [FactoryGirl.create(:person)] }
    f.determination_date_year 2010
    f.determination_date_month 8
    f.determination_date_day 31
    f.referenced true
  end
end
