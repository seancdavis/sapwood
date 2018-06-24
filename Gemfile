# frozen_string_literal: true

source 'https://rubygems.org'

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To Remove / Replace

# TODO: Remove after slug becomes a field. (#248)
gem 'superslug'

# TODO: Remove and install heartwood-uploader (#244)
gem 'jquery-fileupload-rails'

# TODO: Replace this with Bootstrap? (#237)
gem 'bourbon', '~> 4.2.6'

# TODO: Replace backbone and use es6 when refactoring JS. (#272)
gem 'backbone-on-rails'
gem 'coffee-rails'

# TODO: Replaced with redis when deploying to Heroku. (#236)
gem 'daemons'
gem 'delayed_job_active_record'

# TODO: We may have to replace with fragment and low-level caching when moving
# to Heroku. (#236)
gem 'actionpack-action_caching'

# TODO: Replace with heartwood-uploader. (#244)
gem 'aws-sdk'

# ------------------------------------------ Base

gem 'rails', '~> 5.2.0'
gem 'puma'
gem 'pg'

# ------------------------------------------ Assets

# stylesheets
gem 'sass-rails'
gem 'uglifier'
gem 'neat', '~> 1.7.2'
gem 'normalize-rails'

# javascripts
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'pickadate-rails'

# ------------------------------------------ Utilities

gem 'active_record_query_trace', group: :development
gem 'bootsnap'
gem 'devise'
gem 'dotenv-rails', groups: [:development, :test]
gem 'encryptor'
gem 'hirb', group: :development
gem 'heartwood-decorator', github: 'seancdavis/heartwood-decorator'
gem 'heartwood-service', github: 'seancdavis/heartwood-service'
gem 'imgix-rails'
gem 'jbuilder'
gem 'kaminari'
gem 'letter_opener', group: :development
gem 'oj', '~> 2.16' # This is for Rollbar and JSON serialization
gem 'pg_search'
gem 'pry-rails'
gem 'rollbar'
gem 'rubocop', groups: [:development, :test], require: false
gem 'simple_form'
gem 'sendgrid', group: :production
gem 'web-console', group: [:development]

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
  gem 'parallel_tests'
end
