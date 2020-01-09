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
        resources :fake_sessions, only: [:new]
      end

      initializer "decidim_uned_engine.assets" do |app|
        app.config.assets.precompile += %w(
          decidim_uned_engine_manifest.js
          decidim_uned_engine_manifest.scss
          arrow-left.svg
          arrow-left-bottom.svg
          arrow-right.svg
          arrow-right-bottom.svg
          close.svg
          logo-uned.png
          uned-header-image.png
          chevron-down-solid.svg
        )
      end
    end
  end
end
