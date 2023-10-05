source "https://rubygems.org"
ruby "2.7.5" # or any other version you would like to use I just had this preinstaled
# Simple Sinatra API
gem "sinatra"
gem "puma"
gem "sinatra-activerecord"
gem "sqlite3"
gem "sinatra-json"
gem "zeitwerk"

gem "rake", "~> 13.0"

gem "dotenv", "~> 2.8"

group :development, :test do
  gem "debug", ">= 1.0.0"
  gem "standard", "~> 1.31"
end

group :development do
  gem "annotate", "~> 3.2"
end

group :test do
  gem "rspec", "~> 3.12"
  gem "database_cleaner-active_record"
end
