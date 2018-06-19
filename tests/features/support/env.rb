require 'rspec/expectations'
require 'capybara'
require 'capybara/mechanize'
require 'capybara/cucumber'
require 'test/unit/assertions'
require 'mechanize'
World(Test::Unit::Assertions)
#Capybara.default_driver = :mechanize
#Capybara.app_host = "http://localhost"
#World(Capybara)
Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.app_host = 'http://localhost' # change url
end
