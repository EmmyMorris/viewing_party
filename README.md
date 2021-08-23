# Viewing Party


### About

Viewing Party allows users to explore movies via The Movie Database API and create viewing parties. Users can host their own parties and invite their friends on the app or attend parties hosted by other users.

[👀 Visit the app on Heroku](https://rocky-retreat-38535.herokuapp.com/)

## Local Setup

1. Fork and Clone the repo
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:create`
4. Run migrations: ` rails db:migrate`
4. Install the Figaro gem: `bundle exec figaro install`
5. Create an account with [The Movie Database](https://www.themoviedb.org/signup) and request an API key
6. Add your API key to the `application.yml` created by Figaro: 
  ```rb
  MOVIE_DB_KEY: your_api_key
  ```

## Using the App

### Database Design

<img width="400" alt="database schema diagram" src="https://user-images.githubusercontent.com/26797256/125482889-0357bbc1-45e7-4018-829e-cebfdc18d446.png">

## Important Gems
Testing
* [rspec-rails](https://github.com/rspec/rspec-rails)
* [capybara](https://github.com/teamcapybara/capybara)
* [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
* [simplecov](https://github.com/simplecov-ruby/simplecov)
* [webmock](https://github.com/bblimke/webmock)

API Consumption
* [faraday](https://github.com/lostisland/faraday)
* [figaro](https://github.com/laserlemon/figaro)

## Testing
* RSpec and Capybara were used for unit and integration testing and project development adhered to TDD principles.
* WebMock was used to stub out API requests and actual requests are blocked from the test environment.
* Simplecov was used to track total test coverage.
* To run our test suite, RSpec, enter `$ bundle exec rspec` in the terminal.
* To see a coverage report enter `$ open coverage/index.html`
- SimpleCov test coverage is at 100.00%:


<img width="400" alt="Viewing-Party Test Coverage" src="https://user-images.githubusercontent.com/77904287/130531068-d5fbfbd1-3170-465f-9d4d-5ea6ca36605b.png">

[![Build Status](https://app.travis-ci.com/EmmyMorris/viewing_party.svg?branch=main)](https://app.travis-ci.com/EmmyMorris/viewing_party)

## Versions

- Ruby 2.7.2

- Rails 5.2.5

<!-- screenshots of final app -->

## Authors

- Molly Krumholz - [mkrumholz](https://github.com/mkrumholz)
- Emmy Morris - [emmymorris](https://github.com/EmmyMorris)
