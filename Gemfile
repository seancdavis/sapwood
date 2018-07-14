# frozen_string_literal: true

source 'https://rubygems.org'

# ------------------------------------------ Base

gem 'rails', '~> 5.2.0'
gem 'puma'
gem 'pg'

# ------------------------------------------ Assets

# stylesheets
gem 'sass-rails'
gem 'uglifier'

# javascripts
gem 'jquery-rails'

# ------------------------------------------ Utilities

gem 'bootsnap'
gem 'devise'
gem 'dotenv-rails', groups: [:development, :test]
gem 'hirb', group: :development
gem 'letter_opener', group: :development
gem 'oj', '~> 2.16' # This is for Rollbar and JSON serialization
gem 'pry-rails'
gem 'rollbar'
gem 'rubocop', groups: [:development, :test], require: false
gem 'sendgrid', group: :production

# ------------------------------------------ Testing

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'capybara-screenshot'
end
