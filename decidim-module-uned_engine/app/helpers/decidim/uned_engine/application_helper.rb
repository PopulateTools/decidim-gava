# frozen_string_literal: true

module Decidim
  module UnedEngine
    # Custom helpers, scoped to the uned_engine engine.
    #
    module ApplicationHelper
      def uned_user_cookie
        cookie_value = cookies["usuarioUNEDv2"]

        cookie_value.present? ? CGI.escape(cookie_value) : nil
      end

      def check_uned_session
        # 2020-12-16 Disabled because UNED doesn't provide valid credentials for their SSO
        return
        # SSO is not accesible from staging
        return unless site_engine == UNED_ENGINE_ID && (Rails.env.development? || Rails.env.production?)

        if uned_user_cookie.blank?
          Decidim::UnedEngine::SsoClient.log("Skipping automatic login: emtpy cookie")

          if current_user
            Decidim::UnedEngine::SsoClient.log("Signing out user: emtpy cookie")
            sign_out(current_user)
          end

          return
        end

        sso_client = Decidim::UnedEngine::SsoClient.new
        response = sso_client.check_user(uned_user_cookie)

        if !response.login_authorized?
          Decidim::UnedEngine::SsoClient.log("Can't verify user - #{response.summary}")
          return
        elsif response.cookie_expired?
          Decidim::UnedEngine::SsoClient.log("Signing out user: cookie expired")
          sign_out(current_user)
          return
        end

        user = Decidim::User.find_by(nickname: response.user_nickname)

        if user.nil?
          Decidim::UnedEngine::SsoClient.log("User #{response.user_nickname} not found. Creating a new one.")
          user = create_uned_user(response)
        end

        Decidim::UnedEngine::SsoClient.log("Signing in user #{response.user_nickname}")

        sign_in(user)
      end

      def create_uned_user(sso_response)
        random_password = SecureRandom.hex(16)

        user = Decidim::User.create!(
          name: sso_response.user_nickname,
          email: sso_response.user_email,
          nickname: sso_response.user_nickname,
          organization: current_organization,
          password: random_password,
          password_confirmation: random_password,
          newsletter_notifications_at: Time.zone.now,
          accepted_tos_version: Time.zone.now,
          email_on_notification: true,
          confirmed_at: Time.zone.now,
          tos_agreement: true
        )

        Decidim::UnedEngine::SsoClient.log("Created user with #{user.nickname} / #{user.email}")

        user
      end
    end
  end
end
