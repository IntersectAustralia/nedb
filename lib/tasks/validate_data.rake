require File.dirname(__FILE__) + '/validator.rb'

begin
  namespace :db do
    desc "Checks that the data populated is valid according to the model validations"
    task :validate_data => :environment do
      do_validation
    end
  end
rescue LoadError
  puts "Forgery is missing: please run bundle install"
end

