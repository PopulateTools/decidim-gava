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

  before_action :set_environment
  before_action :run_engine_hooks
  before_action :prepend_organization_views
  before_action :check_uned_session

  helper_method(
    :proposal_path,
    :current_component,
    :current_participatory_space,
    :component_settings,
    :current_settings
  )

  private

  def set_environment
    request.env["decidim.current_component"] = Decidim::Component.find(98)
    request.env["decidim.current_participatory_space"] = Decidim::ParticipatoryProcess.find(35)
  end

  def current_participatory_space
    request.env["decidim.current_participatory_space"]
  end

  def current_component
    request.env["decidim.current_component"]
  end

  def component_settings
    @component_settings ||= current_component.settings
  end

  def current_settings
    @current_settings ||= current_component.current_settings
  end

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
end
