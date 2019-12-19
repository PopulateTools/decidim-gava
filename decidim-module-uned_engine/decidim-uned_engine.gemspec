# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/uned_engine/version"

Gem::Specification.new do |s|
  s.version = Decidim::UnedEngine.version
  s.authors = ["Alberto Miedes"]
  s.email = ["albertomg994@gmail.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-uned_engine"
  s.required_ruby_version = ">= 2.5"

  s.name = "decidim-uned_engine"
  s.summary = "A decidim uned_engine module"
  s.description = "Decidim module for UNED customizations."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::UnedEngine.version
  s.add_dependency "savon"
end
