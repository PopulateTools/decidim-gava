# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? || Rails.env.staging?

  mount Decidim::UnedEngine::Engine => "/uned"

  mount Decidim::Core::Engine => "/"
  mount Decidim::Proposals::Engine => "/"
  mount Decidim::ParticipatoryProcesses::Engine => "/"
end
