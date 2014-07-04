# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl'
require 'shoulda/matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include(Shoulda::Matchers)

  config.include Devise::TestHelpers, :type => :controller

  # DatabaseCleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    Setting.instance.update_attributes(:app_title => "N.C.W. Beadle Herbarium",
                                       :specimen_prefix => "NE",
                                       :breadcrumb_title1 => "UNE Home",
                                       :breadcrumb_title2 => "Herbarium",
                                       :breadcrumb_link1 => "http://www.une.edu.au",
                                       :breadcrumb_link2 => "http://www.une.edu.au/herbarium",
                                       :institution => "University of New England",
                                       :institution_address => "Armidale NSW 2351 Australia",
                                       :institution_code => "UNE",
                                       :citation => "Please cite use of this database in papers, theses, reports, etc. as follows:\n\"NE-db (year). N.C.W. Beadle Herbarium (NE) database (NE-db). Version 1, Dec 2010 [and more or less continuously updated since] www.une.edu.au/herbarium/nedb, accessed [day month year].\"\nAnd/or acknowledge use of the data as follows:\n\"I/we acknowledge access and use of data from the N.C.W. Beadle Herbarium (NE) database (NE-db).\"")
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

class Warden::SessionSerializer
  def serialize(record)
    record
  end

  def deserialize(keys)
    keys
  end
end
