# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/civis_engine/version"

Gem::Specification.new do |s|
  s.version = Decidim::CivisEngine.version
  s.authors = ["Eduardo Martínez"]
  s.email = ["eduardo@populate.tools"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-civis_engine"
  s.required_ruby_version = ">= 2.5"

  s.name = "decidim-civis_engine"
  s.summary = "A decidim civis_engine module"
  s.description = "Decidim module for storing CIVIS customizations."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::CivisEngine.version
end
