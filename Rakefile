# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'active_record'

Nedb::Application.load_tasks

task :create_views =>  :environment do
  ActiveRecord::Base.establish_connection(Rails.env.to_sym)
  sql = "create view determination_dates as " +
        "   select COALESCE(determination_date_year*10000,0)+COALESCE(determination_date_month*100,0)+COALESCE(determination_date_day,0) as det_date, * " +
        "   from determinations;" +
        "create view latest_determination as " +
        "   select * from determination_dates " +
        "   where (specimen_id,det_date) in " +
        "         (select specimen_id, max(det_date) from determination_dates group by specimen_id);" +
        "create view specimen_dates as " +
        "   select id as id, COALESCE(collection_date_year*10000,null)+COALESCE(collection_date_month*100,null)+COALESCE(collection_date_day,null) as collection_date" +
        "   from specimens " +
        "   where collection_date_year is not null " +
        "   and collection_date_year is not null " +
        "   and collection_date_year is not null;" +
        "create view det_dates as " +
        "   select specimen_id as id, COALESCE(determination_date_year*10000,null)+COALESCE(determination_date_month*100,null)+COALESCE(determination_date_day,null) as date" +
        "   from determinations " +
        "   where determination_date_year is not null " +
        "   and determination_date_month is not null " +
        "   and determination_date_day is not null;" +
        "create view specimen_coordinates as" +
        "   select id as id, COALESCE(round(latitude_degrees+((latitude_minutes*60 + latitude_seconds)/3600), 13),null) as latitude," +
        "    COALESCE(round(longitude_degrees+((longitude_minutes*60 + longitude_seconds)/3600),13),null) as longitude" +
        "   from specimens " +
        "   where latitude_degrees is not null " +
        "   and latitude_minutes is not null " +
        "   and latitude_seconds is not null " +
        "   and longitude_degrees is not null " +
        "   and longitude_minutes is not null " +
        "   and longitude_seconds is not null;"
  ActiveRecord::Base.connection.execute(sql)
end

task :drop_views =>  :environment do
  ActiveRecord::Base.establish_connection(Rails.env.to_sym)
  sql = "drop view if exists latest_determination; drop view if exists determination_dates; drop view if exists specimen_dates; drop view if exists det_dates; drop view if exists specimen_coordinates;"
  ActiveRecord::Base.connection.execute(sql)
end
