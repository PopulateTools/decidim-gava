# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Decidim::Proposals::Engine.routes.url_helpers
  helper Decidim::ActionAuthorizationHelper
  helper Decidim::Proposals::ProposalVotesHelper

  helper_method(
    :proposal_path
  )

  private

  def site_engine
    request.env["site_engine"]
  end

  def prepend_organization_views
    prepend_view_path "#{site_engine}/app/custom_views" if site_engine
  end

  def host
    request.host
  end
end
