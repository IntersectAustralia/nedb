# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require File.dirname(__FILE__) + '/seed_helper.rb'

create_countries
create_states
create_botanical_divisions
create_herbaria
create_item_types
create_uncertainty_types
create_people
create_species
create_profiles_and_permissions

# Create one user so we can log in and approve other users
User.delete_all
user = User.new(:email => "georgina@intersect.org.au", :first_name => "Georgina", :last_name => "Edwards", :password => "Pass.123")
user.activate
user.save!
profile = Profile.where(:name => "Superuser").first
user.profile = profile
user.save!
