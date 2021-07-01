# frozen_string_literal: true

require_relative "../../decidim-module-uned_engine/lib/decidim/uned_engine"
require_relative "../../decidim-module-uned_engine/app/helpers/decidim/uned_engine/application_helper"
require_relative "../../decidim-module-uned_engine/app/helpers/decidim/uned_engine/care_proposals_helper"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Decidim::UnedEngine::ApplicationHelper
  include Decidim::Proposals::Engine.routes.url_helpers
  helper Decidim::ActionAuthorizationHelper
  helper Decidim::Proposals::ProposalVotesHelper
  helper Decidim::UnedEngine::CareProposalsHelper

  before_action :run_uned_engine_hooks
  before_action :prepend_organization_views
  before_action :check_uned_session

  helper_method(
    :proposal_path
  )

  private

  def site_engine
    request.env["site_engine"]
  end

  def run_uned_engine_hooks
    return unless site_engine == Decidim::UnedEngine::UNED_ENGINE_ID

    request.env["decidim.current_component"] = Decidim::Component.find(98)
    request.env["decidim.current_participatory_space"] = Decidim::ParticipatoryProcess.find(35)

    raise(ActionController::RoutingError, "Not Found") if request.path.include?("/account/delete")
  end

  def prepend_organization_views
    prepend_view_path "#{site_engine}/app/custom_views" if site_engine
  end

  def host
    request.host
  end
end
