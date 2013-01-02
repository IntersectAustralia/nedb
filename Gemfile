source "http://rubygems.org"

gem "rails", "3.0.3"
gem "rake", "0.9.2"

# Prawn is for PDF generation
gem "prawn", ">= 0.11.1.pre"

# Deploy with Capistrano
gem "capistrano"
gem "capistrano-ext"

# Postgres adapter
gem "pg"

# sqlite3 for test
gem "sqlite3"

# Devise for authentication
gem "devise"

# For creating test data
gem "forgery"

# Pagination
gem "will_paginate", "~> 3.0.pre2"

# Autocomplete with JQuery
gem "rails3-jquery-autocomplete"

# Authorisation
gem "cancan"

gem "dynamic_form"

# Barcode generation
gem "barby"

# For image uploads
gem "paperclip"

# zipfile library
gem "rubyzip"

# For advanced_search
gem "meta_search"

# to fix URItoolarge in webrick, use mongrel
gem 'mongrel', '1.2.0.pre2'

group :development, :test do
  gem "rspec-rails", ">= 2.0.1"

  gem "factory_girl_rails"
  gem "shoulda"

  gem "escape_utils"

end

group :development do
  gem "rails3-generators"
end

group :test do
  gem "cucumber-rails", :require => false
  gem "capybara"
  gem "database_cleaner"
  gem "spork"
  gem "launchy"    # So you can do Then show me the page
  gem "email_spec"
  gem "simplecov", :require => false
end