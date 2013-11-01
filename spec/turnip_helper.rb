require 'dotenv'
Dotenv.load
require 'zonebie'
Zonebie.set_random_timezone
require 'turnip/capybara'
Capybara.javascript_driver = :webkit
Dir["spec/steps/**/*.rb"].each do |step_file|
    load step_file
end
