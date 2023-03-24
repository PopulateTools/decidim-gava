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
    end
  end
end
