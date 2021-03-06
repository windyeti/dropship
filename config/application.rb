require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dropship
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.active_job.queue_adapter = :delayed_job

    config.load_defaults 5.2

    config.autoload_paths += %W(#{config.root}/app #{config.root}/app/services)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
