require File.expand_path('../boot', __FILE__)

require 'rails/all'

require File.expand_path('../hash', __FILE__)
require File.expand_path('../sapwood', __FILE__)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application

    config.generators do |g|
      g.fixture true
      g.fixture_replacement "factory_girl"
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

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths << Rails.root.join('lib')

    config.active_job.queue_adapter = :delayed_job

    config.active_support.escape_html_entities_in_json = false
  end
end
