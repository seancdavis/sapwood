# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

require File.expand_path('../hash', __FILE__)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |g|
      g.fixture true
      g.fixture_replacement 'factory_bot'
      g.test_framework :rspec
      g.assets false
      g.view_specs false
      g.model_specs true
      g.controller_specs false
      g.helper_specs false
      g.routing_specs false
      g.request_specs false
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.skip_routes true
    end

    config.autoload_paths << Rails.root.join('lib')

    config.active_job.queue_adapter = :delayed_job

    config.active_support.escape_html_entities_in_json = false

    config.exceptions_app = self.routes
  end
end
