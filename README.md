https://app.travis-ci.com/DominikAlberski/schedule_api.svg?branch=main
# Scheduler API

Simple API for scheduling appointments with doctors. Written in Ruby and Sinatra.

## Installation

Before installing, [download and install Ruby](https://www.ruby-lang.org/en/documentation/installation/).
Database is done in SQLite3. For mac you can install it with `brew install sqlite3`.

Dependencies are managed with [Bundler](https://bundler.io/).
Install gems with `bundle install`.
Setup database with `bundle exec rake db:create`.
Migrate the database with `bunde exec rake db:migrate`.
And seed it `bundle exec rake db:seed` (WIP)
Or you can run `bundle exec rake db:setup` to do all of the above.

## Usage

To run the server, run `ruby app` in the root directory of the project.
The server will be running on `localhost:4567`.
Here is a PostMan collection with the endpoints: [![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/0b5b3b6b6b6b6b6b6b6b)


## Tests

Tests are written with RSpec. To run them, run `bundle exec rake` in the root directory of the project.
If You encounter database errors, run `RACK_ENV=test bundle exec rake db:create db:migrate` and then run the tests again.

## License

This project is licensed under the MIT license.
