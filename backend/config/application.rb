require_relative "boot"

require "rails/all"

require 'active_support/all'
require_relative '../lib/util'
require_relative '../lib/magic'
require_relative '../lib/ingest'
require_relative '../lib/validator'
require_relative '../lib/uploader'
require_relative '../lib/helpers'
require_relative '../lib/Helpers/inning_helper'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.action_controller.default_protect_from_forgery = false

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
