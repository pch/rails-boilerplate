require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Boilerplate
  class Application < Rails::Application
    config.load_defaults 7.1

    config.generators.helper = false
    config.app = config_for(:config).with_indifferent_access
    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.default_url_options = {host: Rails.configuration.app.fetch(:base_url)}

    config.generators do |generate|
      generate.orm :active_record, primary_key_type: :uuid
    end
  end
end
