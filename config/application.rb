# frozen_string_literal: true

require_relative "boot"
require_relative "../lib/middlewares/site_middleware"
require "rails/all"

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
    config.i18n.default_locale = :ca
    config.i18n.enforce_available_locales = false

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
