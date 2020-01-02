# frozen_string_literal: true

require "savon"

module Decidim
  module UnedEngine
    class SSOClient
      attr_accessor :client

      WDSL_URL = Rails.application.secrets[:uned][:sso_wsdl_url]
      APP_ID = Rails.application.secrets[:uned][:sso_app_id]
      SSO_URL = "https://sso.uned.es/sso/index.aspx"

      def self.log(message)
        Rails.logger.info("[SSO] #{message}")
      end

      class Response
        attr_accessor(
          :response_body,
          :user_attributes,
          :user_email,
          :user_nickname,
          :error
        )

        def initialize(response = nil)
          if response.nil?
            @response_body = {}
            @user_attributes = {}
            @error = nil
            return
          end

          @response_body = response.body
          @user_attributes = response_body[:autorizar_ext_response][:usuario]

          if user_attributes
            @user_nickname = user_attributes[:id]
            @user_email = user_attributes[:email]
            @error = user_attributes[:error]
          end
        end

        def success?
          response_body[:autorizar_ext_response] && response_body[:autorizar_ext_response][:autorizar_ext_result]
        end

        def student?
          user_attributes[:es_alumno]
        end

        def active?
          user_attributes[:aserciones] && user_attributes[:aserciones][:string].include?("ACTIVO:True")
        end

        def cookie_expired?
          error == "TIMEOUT"
        end

        def summary
          { success: success?, student: student?, active: active?, error: error, mantenimiento: user_attributes[:mantenimiento] }
        end

        def login_authorized?
          # HACK: force our test user to be authorized
          return true if user_nickname == "palvarez128"

          student? ? (success? && active?) : success?
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
      rescue Excon::Error::Socket, SocketError => e
        Rollbar.error("Can't connect to SSO webservice: #{e}")
        Response.new
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
