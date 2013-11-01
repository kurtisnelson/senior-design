require 'dotenv'
Dotenv.load
require 'zonebie'
Zonebie.set_random_timezone
require 'turnip/capybara'
Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new

  # Turn off the accessibility redirect popup
  profile["network.http.prompt-temp-redirect"] = false

  Capybara::Selenium::Driver.new(
    app, :browser => :firefox, :profile => profile
  )
end
Dir["spec/steps/**/*.rb"].each do |step_file|
    load step_file
end
