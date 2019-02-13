# frozen_string_literal: true
require_relative "../../app/services/census_authorization_handler"

Decidim.configure do |config|
  config.application_name = "Decidim Gavà"
  config.mailer_sender    = Rails.application.secrets.email
  config.authorization_handlers = [CensusAuthorizationHandler]
  config.maximum_attachment_size = 150.megabytes

  # TODO: investigate why Faker fails if en is not available
  if Rails.env.development?
    config.available_locales = %i(ca es en)
  else
    config.available_locales = %i(ca es)
  end

  if Rails.application.secrets.geocoder
    config.geocoder = {
      static_map_url: "https://image.maps.cit.api.here.com/mia/1.6/mapview",
      here_app_id: Rails.application.secrets.geocoder[:here_app_id],
      here_app_code: Rails.application.secrets.geocoder[:here_app_code]
    }
  end


end


Decidim::Verifications.register_workflow(:census_authorization_handler) do |auth|
  auth.form = "CensusAuthorizationHandler"
end
