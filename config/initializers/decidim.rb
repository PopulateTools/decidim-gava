# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = "Decidim Gava"
  config.mailer_sender = Rails.application.secrets.mailer_sender
  config.maximum_attachment_size = 150.megabytes

  config.available_locales = %i(ca es en)

  if Rails.application.secrets.geocoder
    config.geocoder = {
      static_map_url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview",
      here_api_key: Rails.application.secrets.geocoder[:here_api_key]
    }
  end
end

Decidim::Verifications.register_workflow(:census_authorization_handler) do |auth|
  auth.form = "CensusAuthorizationHandler"
  auth.action_authorizer = "CensusAuthorizationHandler::ActionAuthorizer"

  auth.options do |options|
    options.attribute :maximum_age, type: :integer, required: false
    options.attribute :minimum_age, type: :integer, required: false
  end
end
