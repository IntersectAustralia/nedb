source "http://rubygems.org"

gem "rails", "3.0.19"
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
gem "devise", "1.5.4"

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

# for database settings
gem 'acts_as_singleton'

group :development, :test do
  gem "rspec-rails", ">= 2.0.1"

  gem "factory_girl_rails"
  gem "shoulda"

  gem "escape_utils"
  gem 'selenium-webdriver'

end

group :development do
  gem "rails3-generators"
end

group :test do
  gem "cucumber-rails", :require => false
  gem "capybara", "~> 2.1.0"
  gem "database_cleaner"
  gem "launchy"    # So you can do Then show me the page
  gem "email_spec"
  gem "simplecov", :require => false
  gem "simplecov-rcov", :require => false
  gem "zeus"
end
