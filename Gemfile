source "https://rubygems.org"

DECIDIM_VERSION = "0.21.0"

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
gem "sidekiq", "~> 5.2"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem "byebug", platform: :mri
end

group :development do
  gem "rainbow", "~>2.2.0"
  gem "decidim-dev", DECIDIM_VERSION
  gem "web-console"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "faker"
  gem "capistrano"
  gem "capistrano3-puma"
  gem "capistrano-bundler", "~> 1.2"
  gem "puma"
  gem "pry-remote"
end

group :development, :staging do
  gem "letter_opener_web", "~> 1.3.0"
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
