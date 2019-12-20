# frozen_string_literal: true

require_relative "../../decidim-module-uned_engine/lib/decidim/uned_engine"
require_relative "../../decidim-module-uned_engine/app/helpers/decidim/uned_engine/application_helper"
require_relative "../../decidim-module-uned_engine/lib/decidim/uned_engine/query_helper"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Decidim::UnedEngine::ApplicationHelper
  include Decidim::Proposals::Engine.routes.url_helpers

  before_action :run_engine_hooks
  before_action :prepend_organization_views
  before_action :check_uned_session

  helper Decidim::Core::Engine.routes.url_helpers
  helper Decidim::ActionAuthorizationHelper
  helper Decidim::Proposals::ProposalVotesHelper
  helper Decidim::ParticipatoryProcesses::Engine.routes.url_helpers

  helper_method(
    :care_proposals,
    :care_proposals_count,
    :care_proposal_vote_path,
    :care_proposal_vote_button_classes,
    :proposal_path
  )

  private

  def site_engine
    request.env["site_engine"]
  end

  def run_engine_hooks
    return unless site_engine == Decidim::UnedEngine::UNED_ENGINE_ID

    raise(ActionController::RoutingError, "Not Found") if request.path.include?("/account/delete")
  end

  def prepend_organization_views
    prepend_view_path "#{site_engine}/app/custom_views" if site_engine
  end

  def host
    request.host
  end

  def care_proposal_vote_path(proposal)
    proposal_proposal_vote_path(proposal_id: proposal, from_proposals_list: false)
  end

  def care_proposal_vote_button_classes
    "uned-poll-slider-participa-button-right expanded button--sc"
  end
end
