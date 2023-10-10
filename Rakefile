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

namespace :organization do
  desc "Create a new organization"
  task :create, [:name, :email] do |t, args|
    api_key = ApiKeyService.new.generate_api_key
    org = Organization.new(name: args[:name], api_key: api_key, email: args[:email])
    if org.save
      puts "Organization created with API key:\n #{api_key}"
    else
      puts "Organization not created error:\n #{org.errors.full_messages}"
    end
  end
end
