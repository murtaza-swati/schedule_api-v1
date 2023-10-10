ENV["RACK_ENV"] ||= "development"

require "dotenv/tasks"
require "sinatra/activerecord/rake"
require "rspec/core/rake_task"
require "standard/rake"
require "./app"

# RSpec Rake task for running tests
RSpec::Core::RakeTask.new do
  ENV["RACK_ENV"] = "test"
end

task default: :spec
