# frozen_string_literal: true

module Decidim
  module UnedEngine
    # This is the engine that runs on the public interface of `UnedEngine`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::UnedEngine::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :uned_engine do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "uned_engine#index"
      end

      def load_seed
        nil
      end
    end
  end
end
