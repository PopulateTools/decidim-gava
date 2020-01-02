# frozen_string_literal: true

require_relative "../../decidim-module-gava_engine/app/services/census_authorization_handler"
require_relative "../../decidim-module-uned_engine/app/services/sso_client"
require_relative "../../decidim-module-uned_engine/lib/decidim/uned_engine"

Decidim.configure do |config|
  config.application_name = "Decidim Gavà"
  config.mailer_sender = Rails.application.secrets.mailer_sender
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
  auth.action_authorizer = "CensusAuthorizationHandler::ActionAuthorizer"

  auth.options do |options|
    options.attribute :maximum_age, type: :integer, required: false
    options.attribute :minimum_age, type: :integer, required: false
  end
end

## Monkeypatches

Decidim::Devise::SessionsController.class_eval do
  before_action :run_engine_hooks

  private

  def run_engine_hooks
    return unless request.env["site_engine"] == Decidim::UnedEngine::UNED_ENGINE_ID

    # TODO: when SSO works, uncomment this
    # redirect_to uned_sso_url if request.path.include?("/users/sign_in") && Rails.env.production?
  end

  def uned_sso_url
    "#{Decidim::UnedEngine::SSOClient::SSO_URL}?URL=#{root_url}"
  end
end
