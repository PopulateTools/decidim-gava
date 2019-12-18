# frozen_string_literal: true

require_relative "../../decidim-module-uned_engine/lib/decidim/uned_engine/query_helper"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :prepend_organization_views

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

  def host
    request.host
  end
end
