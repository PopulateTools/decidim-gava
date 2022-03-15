# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.7.3"

DECIDIM_VERSION = "0.26.0"

if ENV["USE_LOCAL_DECIDIM"] == "true"
  gem "decidim", path: "~/dev/decidim"
else
  gem "decidim", DECIDIM_VERSION
end

gem "data_migrate"
gem "figaro", ">= 1.1.1"
gem "foundation-rails"
gem "httparty"
gem "progressbar"
gem "rollbar"
gem "uglifier", ">= 1.3.0"
gem "sidekiq"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer.git", branch: "develop"
gem "decidim-decidim_awesome", "~> 0.8"
gem "decidim-question_captcha", git: "https://github.com/PopulateTools/decidim-module-question_captcha.git", branch: "0.26_update"
gem "acts_as_textcaptcha", "~> 4.5.1"

# Performance
gem "appsignal", "= 3.0.6"

group :development, :test do
  gem "byebug", platform: :mri
end

group :development do
  gem "decidim-dev", DECIDIM_VERSION
  gem "web-console"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "faker"
  gem "capistrano"
  gem "capistrano3-puma"
  gem "capistrano-bundler"
  gem "puma"
  gem "pry-remote"
end

group :development, :staging do
  gem "letter_opener_web", "~> 1.4"
end

group :production do
  gem "fog-aws"
  gem "newrelic_rpm"
  gem "dalli"
  gem "rack-host-redirect"
end

group :test do
  gem "rspec-rails"
  gem "database_cleaner"
end

# Site engines
gem "decidim-gava_engine", path: "decidim-module-gava_engine"
gem "decidim-uned_engine", path: "decidim-module-uned_engine"
