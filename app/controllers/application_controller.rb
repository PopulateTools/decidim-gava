# frozen_string_literal: true

require_relative "../../decidim-module-gava_engine/lib/decidim/gava_engine"

require_relative "../../decidim-module-uned_engine/lib/decidim/uned_engine"
require_relative "../../decidim-module-uned_engine/app/services/sso_client"
require_relative "../../decidim-module-uned_engine/app/helpers/decidim/uned_engine/application_helper"
require_relative "../../decidim-module-uned_engine/lib/decidim/uned_engine/query_helper"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Decidim::NeedsOrganization

  include Decidim::UnedEngine::ApplicationHelper

  before_action :set_site_engine
  before_action :run_engine_hooks
  before_action :prepend_organization_views
  before_action :check_uned_session

  helper_method :care_proposals, :care_proposals_count

  private

  def set_site_engine
    @site_engine = if host.include?("gava")
                     Decidim::GavaEngine::GAVA_ENGINE_ID
                   elsif host.include?("uned")
                     Decidim::UnedEngine::UNED_ENGINE_ID
                   end
  end

  def run_engine_hooks
    return unless @site_engine == Decidim::UnedEngine::UNED_ENGINE_ID

    if request.path.include?("/account/delete")
      raise ActionController::RoutingError, "Not Found"
    elsif request.path.include?("/users/sign_in")
      redirect_to "#{Decidim::UnedEngine::SSOClient::SSO_URL}?URL=#{root_url}"
    end
  end


  def prepend_organization_views
    prepend_view_path "#{@site_engine}/app/custom_views" if @site_engine
  end

  def host
    request.host
  end
end
