require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'capistrano_colors'
require 'colorize'

# Extra capistrano tasks
load 'lib/intersect_capistrano_tasks'

set :application, "nedb"
set :stages, %w(qa staging production production_student)
set :default_stage, "qa"

set :scm, 'git'
set :repository, 'git@github.com:IntersectAustralia/nedb.git'
set :deploy_via, :copy
set :copy_exclude, [".git/*", "features/upload-files/*"]

set :deploy_to, "/home/devel/nedb"
set :user, "devel"

set :branch do
  default_tag = 'HEAD'

  puts "Availible tags:".yellow
  puts `git tag`
  tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the branch/tag first) or HEAD?: [#{default_tag}] ".yellow
  tag = default_tag if tag.empty?
  tag
end

default_run_options[:pty] = true

namespace :deploy do

  # Passenger specifics: restart by touching the restart.txt file
  task :start, :roles => :app, :except => { :no_release => true } do
    restart
  end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # Remote bundle install
  task :rebundle do
    run "cd #{current_path} && bundle install"
    restart
  end

  # Load the schema
  desc "Load the schema into the database (WARNING: destructive!)"
  task :schema_load, :roles => :db do
    fail_if_non_destructive_env(stage)
    run("cd #{current_path} && bundle exec rake drop_views db:schema:load create_views", :env => {'RAILS_ENV' => "#{stage}"})
  end

  # Run the sample data populator
  desc "Run the test data populator script to load test data into the db (WARNING: destructive!)"
  task :populate, :roles => :db do
    fail_if_non_destructive_env(stage)
    run("cd #{current_path} && bundle exec rake db:populate", :env => {'RAILS_ENV' => "#{stage}"})
  end

  # Seed the db
  desc "Run the seeds script to load seed data into the db (WARNING: destructive!)"
  task :seed, :roles => :db do
    fail_if_non_destructive_env(stage)
    run("cd #{current_path} && bundle exec rake db:seed", :env => {'RAILS_ENV' => "#{stage}"})
  end

  # Set the revision
  desc "Set revision on the server so that we can see it in the deployed application"
  task :set_revision, :roles => :app do
    put("#{real_revision}", "#{release_path}/app/views/layouts/_revision.rhtml")
  end

  # Helper task which re-creates the database
  task :refresh_db, :roles => :db do
    require 'colorize'

    # Prompt to refresh_db on unless we're in QA
    if stage.eql?(:qa)
      input = "yes"
    else
      puts "This step (deploy:refresh_db) will erase all data and start from scratch.\nYou probably don't want to do it. Are you sure?' [NO/yes]".colorize(:red)
      input = STDIN.gets.chomp
    end

    if input.match(/^yes/)
      schema_load
      seed
      populate
    else
      puts "Skipping database nuke"
    end
  end

  desc "Safe redeployment"
  task :safe do # TODO roles?
    require 'colorize'
    update
    rebundle

    cat_migrations_output = capture("cd #{current_path} && bundle exec rake db:cat_pending_migrations 2>&1", :env => {'RAILS_ENV' => stage}).chomp
    puts cat_migrations_output

    unless cat_migrations_output[/0 pending migration\(s\)/]
      print "There are pending migrations. Are you sure you want to continue? [NO/yes] ".colorize(:red)
      abort "Exiting because you didn't type 'yes'" unless STDIN.gets.chomp == 'yes'
    end

    backup.db.dump
    backup.db.trim
    migrate
    restart
  end

end

after 'deploy:update_code' do
  generate_database_yml
  deploy.set_revision
end

def fail_if_non_destructive_env(stage)
  if stage.eql?(:production) || stage.eql?(:production_student) || stage.eql?(:staging)
    raise "Cannot run destructive action in staging or production"
  end
end


after 'multistage:ensure' do
  set(:rails_env) { "#{defined?(rails_env) ? rails_env : stage.to_s}" }
end