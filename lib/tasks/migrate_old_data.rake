require File.dirname(__FILE__) + '/migrator.rb'
begin
  namespace :db do
    desc "Populate the database with real data from the old system"
    task :migrate_old_data => :environment do
      do_migration
    end
  end
rescue LoadError
  puts "Forgery is missing: please run bundle install"
end