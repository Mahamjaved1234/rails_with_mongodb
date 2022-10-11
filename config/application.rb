require_relative "boot"
# require 'dotenv'
require "rails"

# Pick the frameworks you want:
require "active_model/railtie"
# require "active_record/railtie"
# require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"

# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"
# GOOGLE CLOUD STORAGE
require "google/cloud/storage"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
module Eshop
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    # Configuration for the application, engines, and railties goes here.
    # if ['development', 'test'].include? ENV['RAILS_ENV']
    #   Dotenv::Railtie.load
    # end
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.action_controller.perform_caching = true
    # config.cache_store = :redis_cache_store, { url: 'redis://127.0.0.1:6379/1' }
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.paths.add File.join('app ', 'api'), glob: File.join('**', '*.rb')
    # config.autoload_paths += Dir[Rails.root.join('app','api', '*')]
    # config.active_job.queue_adapter = :sidekiq
#     Bundler.require(*Rails.groups)

# Dotenv::Railtie.load

# HOSTNAME = ENV['HOSTNAME']
    end
end
