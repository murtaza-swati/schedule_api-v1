require 'dotenv/tasks'
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'
require './app'
ENV['RACK_ENV'] = 'development'

# RSpec Rake task for running tests
RSpec::Core::RakeTask.new(:spec => "db:test:prepare") do
  ENV['RACK_ENV'] = 'test'
end

task default: :spec
