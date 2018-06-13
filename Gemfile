# frozen_string_literal: true

source 'https://rubygems.org'

# ------------------------------------------ Base

gem 'rails', '~> 5.2.0'
gem 'puma'
gem 'pg'

# ------------------------------------------ Assets

# stylesheets helpers
gem 'sass-rails'
gem 'uglifier'
# TODO: Replace this with Bootstrap eventually.
gem 'bourbon', '~> 4.2.6'
gem 'neat', '~> 1.7.2'
gem 'normalize-rails'

# javascripts helpers
# TODO: Backbone isn't necessary.
gem 'backbone-on-rails'
# TODO: Replace with es6
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'pickadate-rails'

# ------------------------------------------ Utilities

# TODO: If this is necessary, it can be development only.
gem 'active_record_query_trace'
# TODO: Replace with fragment caching (using memcached).
gem 'actionpack-action_caching'
# TODO: Is this really necessary?
gem 'ancestry'
# TODO: Will heartwood-uploader take care of this?
gem 'aws-sdk'
gem 'bootsnap'
# TODO: Replace with heartwood-uploader.
# gem 'carrierwave_direct'
# TODO: What is this for?
gem 'daemons'
# TODO: Can this be replaced with redis when deploying to Heroku?
gem 'delayed_job_active_record'
gem 'devise'
gem 'dotenv-rails', groups: [:development, :test]
gem 'heartwood-decorator', github: 'seancdavis/heartwood-decorator'
# TODO: What is this for?
gem 'highline'
gem 'imgix-rails'
gem 'jbuilder'
# TODO: heartwood-uploader will take care of this.
gem 'jquery-fileupload-rails'
gem 'kaminari'
gem 'pg_search'
# TODO: Unnecessary if we go to imgix, right?
gem 'rmagick'
gem 'rubocop', groups: [:development], require: false
gem 'simple_form'
# TODO: Can remove after slug becomes a field.
gem 'superslug'

group :development do
  # TODO: Do we still need this?
  gem 'bullet'

  # TODO: Add this back. Does it have to be forked to work with Rails 5+,
  # or is there a better approach rather than using a gem? This:
  # https://github.com/ryanb/letter_opener ???
  # gem 'mailcatcher'
end

group :production do
  gem 'sendgrid'
end

# ------------------------------------------ Console

# TODO: Which of these console tweaks are necessary?
gem 'rails-console-tweaks'

group :console do
  gem 'wirb'
  gem 'hirb'
  gem 'awesome_print'
end

# ------------------------------------------ Errors

# TODO: Which of these are necessary with Rails 5?
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'web-console'
end

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
