require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/json'
require "zeitwerk"

loader = Zeitwerk::Loader.new
loader.log!
loader.push_dir(File.join(__dir__, 'models'))
loader.push_dir(File.join(__dir__, 'controllers'))
loader.push_dir(File.join(__dir__, 'config'))
loader.setup
loader.eager_load

set :database, {adapter: "sqlite3", database: "db/development.sqlite3"}

Router.run!
