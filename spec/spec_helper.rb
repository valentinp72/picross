require 'simplecov'

# Code coverage of unit tests

SimpleCov.start

# Here, we just have to list all .rb files that we want to run unit tests
# all files needs a name_spec.rb with rspec unit test inside

require_relative '../src/Cell'
require_relative '../src/Grid'
