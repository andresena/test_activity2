ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Adding methods to reuse the code

def zero_results () 
  expect_json(status: "ZERO_RESULTS")  
end

def ok () 
  expect_json(status: "OK")
end

def longitude (long) 
  expect_json('results.*.geometry.bounds.northeast', lng: regex("^#{long}"))
  expect_json('results.*.geometry.bounds.southwest', lng: regex("^#{long}"))
  expect_json('results.*.geometry.location', lng: regex("^#{long}"))
  expect_json('results.*.geometry.viewport.northeast', lng: regex("^#{long}"))
  expect_json('results.*.geometry.viewport.southwest', lng: regex("^#{long}"))
end

def latitude (lati) 
  expect_json('results.*.geometry.bounds.northeast', lat: regex("^#{lati}"))
  expect_json('results.*.geometry.bounds.southwest', lat: regex("^#{lati}"))
  expect_json('results.*.geometry.location', lat: regex("^#{lati}"))
  expect_json('results.*.geometry.viewport.northeast', lat: regex("^#{lati}"))
  expect_json('results.*.geometry.viewport.southwest', lat: regex("^#{lati}"))
end
