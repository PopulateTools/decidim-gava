# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module GavaEngine
    # This is the engine that runs on the public interface of gava_engine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::GavaEngine

      routes do
        # Add engine routes here
        # resources :gava_engine
        # root to: "gava_engine#index"
      end

      initializer "decidim_gava_engine.assets" do |app|
        app.config.assets.precompile += %w[decidim_gava_engine_manifest.js decidim_gava_engine_manifest.css]
      end
    end
  end
end
