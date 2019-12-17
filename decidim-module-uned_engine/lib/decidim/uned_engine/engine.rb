# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module UnedEngine
    # This is the engine that runs on the public interface of uned_engine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::UnedEngine

      routes do
        # Add engine routes here
        # resources :uned_engine
        # root to: "uned_engine#index"
      end

      initializer "decidim_uned_engine.assets" do |app|
        app.config.assets.precompile += %w[decidim_uned_engine_manifest.js decidim_uned_engine_manifest.css]
      end
    end
  end
end
