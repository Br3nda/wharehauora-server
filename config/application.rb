# frozen_string_literal: true

require File.expand_path('boot', __dir__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WharehauoraServer
  class Application < Rails::Application
    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins '*'
        resource '/api/*', headers: :any, methods: :any
        resource '/oauth/*', headers: :any, methods: %i[get post options]
      end
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # db/schema.rb cannot express database specific items such as triggers, sequences, stored procedures
    # or check constraints, etc.
    # While custom SQL statements can be run in migrations, these statements cannot be reconstituted by the
    # schema dumper. Using the :sql schema format will prevent loading the schema into a RDBMS other than
    # the one used to create it but will create a perfect copy of the database's structure.
    config.active_record.schema_format = :sql

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
