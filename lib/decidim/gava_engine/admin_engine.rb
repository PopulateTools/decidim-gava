# frozen_string_literal: true

module Decidim
  module GavaEngine
    # This is the engine that runs on the public interface of `GavaEngine`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::GavaEngine::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :gava_engine do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "gava_engine#index"
      end

      def load_seed
        nil
      end
    end
  end
end
