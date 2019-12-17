# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :prepend_organization_views

  private

  def prepend_organization_views
    prepend_view_path "#{site_custom_engine}/app/custom_views" if site_custom_engine
  end

  def site_custom_engine
    "decidim-module-gava_engine" if %w(gava.decidim.test gava.populate.tools participa.gavacitat.cat).include?(request.host)
  end
end
