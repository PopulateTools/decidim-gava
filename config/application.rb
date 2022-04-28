# frozen_string_literal: true

require_relative "boot"
require_relative "../lib/middlewares/site_middleware"
require "decidim/rails"
require "action_cable"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DecidimBarcelona
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = "Europe/Madrid"

    # Locales
    config.i18n.available_locales = %w(ca es en)
    config.i18n.default_locale = :en
    config.i18n.enforce_available_locales = false
    config.i18n.fallbacks = {ca: [:en], es: [:en]}

    config.middleware.use(SiteMiddleware)

    required_files = [
      "#{Rails.root}/lib",
      "#{Rails.root}/decidim-module-gava_engine/app/services",
      "#{Rails.root}/decidim-module-gava_engine/lib",
      "#{Rails.root}/decidim-module-gava_engine/lib/census_rest_client",
      "#{Rails.root}/decidim-module-uned_engine/lib",
      "#{Rails.root}/decidim-module-uned_engine/lib/decidim",
      "#{Rails.root}/decidim-module-uned_engine/lib/decidim/uned_engine",
      "#{Rails.root}/decidim-module-uned_engine/app",
      "#{Rails.root}/decidim-module-uned_engine/app/services"
    ]
    config.autoload_paths += required_files
    config.eager_load_paths += required_files
  end
end

Decidim.configure do |config|
  # Max requests in a time period to prevent DoS attacks. Only applied on production.
  config.throttling_max_requests = 1000

  # Time window in which the throttling is applied.
  # config.throttling_period = 1.minute
end
