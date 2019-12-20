# frozen_string_literal: true

require_relative "../../../../lib/decidim/uned_engine/query_helper"

module Decidim
  module UnedEngine
    # Custom helpers, scoped to the uned_engine engine.
    #
    module ApplicationHelper
      def uned_user_cookie
        cookies["usuarioUNEDv2"]
      end

      def check_uned_session
        return unless @site_engine == UNED_ENGINE_ID

        if uned_user_cookie.blank?
          Decidim::UnedEngine::SSOClient.log("Skipping automatic login: emtpy cookie")
          return
        end

        sso_client = Decidim::UnedEngine::SSOClient.new
        response = sso_client.check_user(uned_user_cookie)

        if response.cookie_expired?
          Decidim::UnedEngine::SSOClient.log("Signing out user: cookie expired")
          sign_out(current_user)
          return
        elsif !response.success? || !response.student?
          Decidim::UnedEngine::SSOClient.log("Can't verify user - #{response.summary}")
          return
        end

        user = Decidim::User.find_by(nickname: response.user_nickname)

        if user.nil?
          Decidim::UnedEngine::SSOClient.log("User #{response.user_nickname} not found. Creating a new one.")
          user = create_uned_user(response)
        end

        Decidim::UnedEngine::SSOClient.log("Signing in user #{response.user_nickname}")

        sign_in(user)
      end

      def create_uned_user(sso_response)
        random_password = SecureRandom.hex(16)

        user = Decidim::User.create!(
          email: sso_response.user_email,
          nickname: sso_response.user_nickname,
          organization: current_organization,
          password: random_password,
          password_confirmation: random_password,
          newsletter_notifications: true,
          email_on_notification: true,
          confirmed_at: Time.zone.now,
          tos_agreement: true
        )

        Decidim::UnedEngine::SSOClient.log("Created user with #{user.nickname} / #{user.email}")

        user
      end

      def care_proposals
        Decidim::UnedEngine::QueryHelper.care_proposals(current_organization)
      end

      def care_proposals_count
        Decidim::UnedEngine::QueryHelper.care_proposals_count(current_organization)
      end
    end
  end
end
