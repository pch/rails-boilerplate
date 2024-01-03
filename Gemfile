source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "pg", "~> 1.5"
gem "puma", "~> 5.0"
gem "rails", "~> 7.1"
gem "redis", "~> 4.0"
gem "sidekiq"
gem "sidekiq-failures"

gem "uuid7"
gem "based_uuid"

# JavaScript & assets
gem "cssbundling-rails"
gem "jsbundling-rails"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"

# Security
gem "bcrypt", "~> 3.1.7"
gem "pwned"


# Geocoding
gem "geocoder"
gem "maxminddb"

# Other
gem "amazing_print"
gem "browser"

group :development do
  gem "rack-mini-profiler"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "mocha"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :development, :test do
  gem "dotenv-rails"
  gem "erb_lint", require: false
  gem "factory_bot_rails"
  gem "standard"
end
