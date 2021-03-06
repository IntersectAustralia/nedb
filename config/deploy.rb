require "rvm/capistrano"
require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'capistrano_colors'
require 'colorize'
require 'deploy/create_deployment_record'

set :rvm_ruby_string, :local   

set :stages, %w(qa staging production production_student)
set :default_stage, "qa"

set :application, "nedb"

# Fix an issue related to net-ssh, see https://github.com/net-ssh/net-ssh/issues/145
set :ssh_options, {
   config: false
}

set :scm, 'git'
set :repository, 'git@github.com:IntersectAustralia/nedb.git'
set :deploy_via, :copy
set :copy_exclude, [".git/*", "features/upload-files/*"]

set :deploy_to, "/home/devel/nedb"
set :user, "devel"

set(:rails_env) { stage }

default_run_options[:pty] = true

set :branch do
  default_tag = 'HEAD'

  puts "Available tags:".yellow
  puts `git tag`
  tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the branch/tag first) or HEAD?: [#{default_tag}] ".yellow
  tag = default_tag if tag.empty?
  tag
end


namespace :backup do
  namespace :db do
    desc "make a database backup"
    task :dump do
      run "cd #{current_path} && bundle exec rake db:backup", :env => {'RAILS_ENV' => stage}
    end

    desc "trim database backups"
    task :trim do
      run "cd #{current_path} && bundle exec rake db:trim_backups", :env => {'RAILS_ENV' => stage}
    end
  end
end

namespace :deploy do

  # Passenger specifics: restart by touching the restart.txt file
  task :start, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
  task :stop do
    ;
  end
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  # Remote bundle install
  task :rebundle do
    run "cd #{current_path} && bundle install"
    sudo "touch #{current_path}/tmp/restart.txt"
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
    schema_load
    seed
    populate
  end

  task :new_secret, :roles => :app do
    run("cd #{current_path} && bundle exec rake app:generate_secret", :env => {'RAILS_ENV' => "#{stage}"})
  end

  desc "Safe redeployment"
  task :safe do # TODO roles?
    require 'colorize'
    update

    cat_migrations_output = capture("cd #{current_path} && bundle exec rake db:cat_pending_migrations 2>&1", :env => {'RAILS_ENV' => stage}).chomp
    puts cat_migrations_output.blue

    unless cat_migrations_output[/0 pending migration\(s\)/]
      print "    There are pending migrations. Are you sure you want to continue? [NO/yes] ".red
      abort "    Exiting because you didn't type 'yes'" unless STDIN.gets.chomp == 'yes'
    end

    backup.db.dump
    backup.db.trim
    run("cd #{current_path} && bundle exec rake db:migrate", :env => {'RAILS_ENV' => "#{stage}"})
  end

end

after 'deploy:update_code' do
  generate_database_yml
  deploy.set_revision
end

after 'deploy:update' do
  deploy.new_secret
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

  # Populate passwords
  buffer[stage.to_s]['password'] = production_database_password

  put YAML::dump(buffer), "#{release_path}/config/database.yml", :mode => 0664
end

def fail_if_non_destructive_env(stage)
  if stage.eql?(:production) || stage.eql?(:production_student) || stage.eql?(:staging)
    raise "Cannot run destructive action in staging or production"
  end
end
