# frozen_string_literal: true

require_relative "../../decidim-module-uned_engine/app/services/sso_client"
require_relative "../../decidim-module-uned_engine/lib/decidim/uned_engine/query_helper"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :prepend_organization_views
  before_action :check_uned_session

  include Decidim::NeedsOrganization

  helper_method :care_proposals, :care_proposals_count

  private

  def prepend_organization_views
    prepend_view_path "#{site_custom_engine}/app/custom_views" if site_custom_engine
  end

  def site_custom_engine
    if %w(gava.decidim.test gava.populate.tools participa.gavacitat.cat).include?(host)
      "decidim-module-gava_engine"
    elsif %w(uned.decidim.test uned.populate.tools).include?(host)
      "decidim-module-uned_engine"
    end
  end

  def check_uned_session
    return unless site_custom_engine == "decidim-module-uned_engine"

    if cookies["usuarioUNEDv2"].blank?
      Decidim::UnedEngine::SSOClient.log("Skipping automatic login: emtpy cookie")
      return
    end

    sso_client = Decidim::UnedEngine::SSOClient.new
    response = sso_client.check_user(cookies["usuarioUNEDv2"])

    unless response.success? && response.student?
      Decidim::UnedEngine::SSOClient.log("Can't verify user - #{response.summary}")
      return
    end

    user = Decidim::User.find_by(nickname: response.user_nickname)

    if user.nil?
      Decidim::UnedEngine::SSOClient.log("User #{response.user_nickname} not found. Creating a new one.")
      user = create_uned_user(response)
    end

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
      newsletter_notifications: false,  # TODO: ask
      email_on_notification: false,     # TODO: ask
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

  def host
    request.host
  end
end
