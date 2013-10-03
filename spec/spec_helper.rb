# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'coveralls'
Coveralls.wear! 'rails'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec'
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each {|f| require f}

# Load the .env file
Dotenv.load
Zonebie.set_random_timezone
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner[:redis, port: 6379]
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include Capybara::DSL
end
