source "https://rubygems.org"

ruby '2.4.2'

DECIDIM_VERSION = "0.9.0"

gem "decidim", DECIDIM_VERSION
gem "decidim-debates", path: "engines/decidim-debates"
gem 'uglifier', '>= 1.3.0'
gem 'figaro', '>= 1.1.1'
gem "rollbar"
gem "progressbar"
gem "sidekiq", "~> 5.2"

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'rainbow', "~>2.2.0"
  gem "decidim-dev", DECIDIM_VERSION
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'faker'
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-bundler', '~> 1.2'
end

group :development, :staging do
  gem "letter_opener_web", "~> 1.3.0"
end

group :production do
  gem "puma"
  gem "fog-aws"
  gem "newrelic_rpm"
  gem "dalli"
  gem "rack-host-redirect"
end

group :test do
  gem "rspec-rails"
  gem "database_cleaner"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'foundation-rails', '~> 6.4.1.3'
