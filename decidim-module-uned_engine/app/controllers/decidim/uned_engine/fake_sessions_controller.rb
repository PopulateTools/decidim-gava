# frozen_string_literal: true

module Decidim
  module UnedEngine
    class FakeSessionsController < ::ApplicationController
      def new
        head :not_found if Rails.env.production?

        if params[:cookie]
          cookies["usuarioUNEDv2"] = params[:cookie]
          Rails.logger.info("[SSO] Fake cookie set to #{cookies["usuarioUNEDv2"]}")
          head :ok
        else
          head :bad_request
        end
      end
    end
  end
end
