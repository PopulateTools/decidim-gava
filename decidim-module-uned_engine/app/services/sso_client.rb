# frozen_string_literal: true

require "savon"

module Decidim
  module UnedEngine
    class SSOClient
      attr_accessor :client

      WDSL_URL = Rails.application.secrets[:uned][:sso_wsdl_url]
      APP_ID = Rails.application.secrets[:uned][:sso_app_id]

      def self.log(message)
        Rails.logger.info("[SSO] #{message}")
      end

      class Response
        def initialize(response)
          @response_body = response.body
          @user_attributes = @response_body[:autorizar_ext_response][:usuario] if @response_body[:autorizar_ext_response][:usuario]
        end

        def success?
          @response_body[:autorizar_ext_response][:autorizar_ext_result]
        end

        def user_email
          @user_attributes[:email]
        end

        def user_nickname
          @user_attributes[:id]
        end

        def student?
          @user_attributes[:es_alumno]
        end

        def summary
          { success: success?, student: student?, error: @user_attributes[:error], mantenimiento: @user_attributes[:mantenimiento] }
        end
      end

      def initialize
        @client = Savon.client(wsdl: WDSL_URL)
      end

      def check_user(cookie_value)
        message = build_message(cookie_value)

        log("message: #{message}") unless Rails.env.production?

        response = client.call(:autorizar_ext, message: message)

        log("response_body: #{response.body}") unless Rails.env.production?

        Response.new(response)
      end

      private

      def build_message(cookie_value)
        { "idAplicacion" => APP_ID, "cookie" => cookie_value }
      end

      def log(message)
        self.class.log(message)
      end
    end
  end
end
