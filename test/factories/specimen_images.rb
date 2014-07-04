# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :specimen_image do |f|
    f.image_file_name "filename.jpg"
    f.description "desc1"
    f.association :specimen, :factory => :specimen
  end
end
