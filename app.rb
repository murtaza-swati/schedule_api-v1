require "dotenv"
Dotenv.load
require "sinatra"
require "sinatra/activerecord"
require "sinatra/json"
require "yaml"
require "erb"
require "zeitwerk"
require "securerandom"
require "pry" if ENV["RACK_ENV"] != "production"

loader = Zeitwerk::Loader.new
loader.push_dir(File.join(__dir__, "models"))
loader.push_dir(File.join(__dir__, "controllers"))
loader.push_dir(File.join(__dir__, "config"))
loader.push_dir(File.join(__dir__, "services"))
loader.setup
loader.eager_load

# Load database configurations based on the environment.
# By default, Sinatra's environment is set to development.
# change `ENV['RACK_ENV']` to different ones when needed.
erb_content = ERB.new(File.read("config/database.yml")).result
db_config = YAML.safe_load(erb_content)[Sinatra::Base.environment.to_s]

set :database, db_config

# Start the application if this file is executed directly.
if __FILE__ == $0
  Router.run!
end
