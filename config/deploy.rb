set :stages, %w(qa staging production)
set :default_stage, "qa"
require 'capistrano/ext/multistage'

require 'bundler/capistrano'

set :application, "nedb"


set :scm, 'git'
set :repository, 'git@github.com:IntersectAustralia/nedb.git'
set :deploy_via, :copy
set :copy_exclude, [".git/*", "features/upload-files/*"]

set :deploy_to, "/home/devel/nedb"
set :user, "devel"

default_run_options[:pty] = true

namespace :deploy do

  # Passenger specifics: restart by touching the restart.txt file
  task :start, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # Remote bundle install
  task :rebundle do
    run "cd #{current_path} && bundle install"
    sudo "touch #{current_path}/tmp/restart.txt"
  end

  # Load the schema
  desc "Load the schema into the database (WARNING: destructive!)"
  task :schema_load, :roles => :db do
    run("cd #{current_path} && rake drop_views db:schema:load create_views", :env => {'RAILS_ENV' => "#{stage}"})
  end

  # Run the sample data populator
  desc "Run the test data populator script to load test data into the db (WARNING: destructive!)"
  task :populate, :roles => :db do
    run("cd #{current_path} && rake db:populate", :env => {'RAILS_ENV' => "#{stage}"})
  end

  # Seed the db
  desc "Run the seeds script to load seed data into the db (WARNING: destructive!)"
  task :seed, :roles => :db do
    run("cd #{current_path} && rake db:seed", :env => {'RAILS_ENV' => "#{stage}"})
  end

  # Set the revision
  desc "Set SVN revision on the server so that we can see it in the deployed application"
  task :set_svn_revision, :roles => :app do
    put("#{real_revision}", "#{release_path}/app/views/layouts/_revision.rhtml")
  end

  # Helper task which re-creates the database
  task :refresh_db, :roles => :db do
    schema_load
    seed
    populate
  end

end

after 'deploy:update_code' do
  generate_database_yml
  deploy.set_svn_revision
end

desc "After updating code we need to populate a new database.yml"
task :generate_database_yml, :roles => :app do
  require "yaml"
  set :production_database_password, proc { Capistrano::CLI.password_prompt("Database password: ") }

  buffer = YAML::load_file('config/database.yml')
  # get ride of uneeded configurations
  buffer.delete('test')
  buffer.delete('development')
  buffer.delete('cucumber')
  buffer.delete('spec')

  # Populate production password
  buffer['production']['password'] = production_database_password

  put YAML::dump(buffer), "#{release_path}/config/database.yml", :mode => 0664
end
