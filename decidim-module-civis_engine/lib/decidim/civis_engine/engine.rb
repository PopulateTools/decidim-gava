# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module CivisEngine
    # This is the engine that runs on the public interface of civis_engine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::CivisEngine

      routes do
        # Add engine routes here
        # resources :civis_engine
        # root to: "civis_engine#index"
      end

      initializer "decidim_civis_engine.assets" do |app|
        app.config.assets.precompile += %w[decidim_civis_engine_manifest.js decidim_civis_engine_manifest.scss]
      end
    end
  end
end
