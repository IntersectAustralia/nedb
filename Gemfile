source "http://rubygems.org"

gem "rails", "~> 3.2.18"
gem "rake", "0.9.2"

# Prawn is for PDF generation
gem "prawn", "~> 1.1.0"
gem "prawnto_2", :require => "prawnto"

# Deploy with Capistrano
gem "capistrano"
gem "capistrano-ext"
gem "capistrano_colors"
gem "rvm-capistrano"
gem "colorize"


# Postgres adapter
gem "pg", "~> 0.17.1"

# sqlite3 for test
gem "sqlite3"

# Devise for authentication
gem "devise", "~> 1.5.3"

# For creating test data
gem "forgery"

# Pagination
gem "will_paginate", "~> 3.0.5"

# Autocomplete with JQuery
gem "rails3-jquery-autocomplete"

# Authorisation
gem "cancan"

gem "dynamic_form"

# Barcode generation
gem "barby", "~> 0.4.2"

# For image uploads
gem "paperclip"

# zipfile library
gem "rubyzip"

# For advanced_search
gem "meta_search", "~> 1.1.3"

# to fix URItoolarge in webrick, use mongrel
gem 'mongrel', '1.2.0.pre2'

# for database settings
gem 'acts_as_singleton', '~> 0.0.8'

# set up Whoops
gem 'whoops_rails_logger', :git=> 'https://github.com/IntersectAustralia/whoops_rails_logger.git'

group :development, :test do
  gem "rspec-rails", "~> 2.12.0"

  gem "factory_girl_rails"
  gem "shoulda"

  gem "escape_utils"
  gem 'selenium-webdriver'

  gem 'zeus'
end

group :development do
  gem "rails3-generators"
  gem 'pry-rails'
  # set up Deployment Tracker
  gem "create_deployment_record", git: 'https://github.com/IntersectAustralia/create_deployment_record.git'
  gem 'thin'
end

group :test do
  gem "cucumber-rails", :require => false
  gem "capybara", "~> 2.2" # we're not ready for 2.0
  gem "database_cleaner"
  gem "launchy"    # So you can do Then show me the page
  gem "email_spec"
  gem "simplecov", :require => false
  gem "simplecov-rcov", :require => false
  gem "pdf-inspector"
end
