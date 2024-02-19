ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors, with: :threads)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  SimpleCov.start
  
  if ENV['RAILS_ENV'] == 'test'
    require 'simplecov'
    SimpleCov.start 'rails'
    puts "required simplecov"
  end
end
