require 'dotenv'
Dotenv.load
require 'turnip/capybara'
Dir["spec/steps/**/*.rb"].each do |step_file|
    load step_file
end
