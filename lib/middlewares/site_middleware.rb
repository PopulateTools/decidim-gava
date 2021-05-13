# frozen_string_literal: true

require_relative "../../decidim-module-uned_engine/lib/decidim/uned_engine"
require_relative "../../decidim-module-uned_engine/lib/decidim/uned_engine"

class SiteMiddleware
  attr_reader :request

  def initialize(app)
    @app = app
  end

  def call(env)
    @request = Rack::Request.new(env)
    env["site_engine"] = site_engine

    Rails.logger.debug("Attaching site engine #{site_engine} via middleware")

    @app.call(env)
  end

  def each(&block); end

  def site_engine
    if request.host.include?("gava")
      Decidim::GavaEngine::GAVA_ENGINE_ID
    elsif request.host.include?("uned")
      Decidim::UnedEngine::UNED_ENGINE_ID
    elsif request.host.include?("civis")
      Decidim::CivisEngine::CIVIS_ENGINE_ID
    end
  end
end
