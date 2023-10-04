require 'dotenv'
Dotenv.load
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/json'
require 'yaml'
require "zeitwerk"

loader = Zeitwerk::Loader.new
loader.push_dir(File.join(__dir__, 'models'))
loader.push_dir(File.join(__dir__, 'controllers'))
loader.push_dir(File.join(__dir__, 'config'))
loader.setup
loader.eager_load

# Load database configurations based on the environment.
# By default, Sinatra's environment is set to development.
# change `ENV['RACK_ENV']` to different ones when needed.
db_config = YAML.load_file('config/database.yml')[Sinatra::Base.environment.to_s]

set :database, db_config

# Start the application if this file is executed directly.
if __FILE__ == $0
  Router.run!
end
