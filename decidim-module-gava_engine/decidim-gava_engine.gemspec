# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/gava_engine/version"

Gem::Specification.new do |s|
  s.version = Decidim::GavaEngine.version
  s.authors = ["Alberto Miedes"]
  s.email = ["alberto@populate.tools"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-gava_engine"
  s.required_ruby_version = ">= 2.5"

  s.name = "decidim-gava_engine"
  s.summary = "A decidim gava_engine module"
  s.description = "Decidim module for storing Gava customizations."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::GavaEngine.version
end
