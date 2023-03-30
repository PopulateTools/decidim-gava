# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? || Rails.env.staging?

  mount Decidim::Core::Engine => "/"
  mount Decidim::Proposals::Engine => "/"
  mount Decidim::ParticipatoryProcesses::Engine => "/"
end
