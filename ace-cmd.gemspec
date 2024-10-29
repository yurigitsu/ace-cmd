# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "ace_cmd/version"

Gem::Specification.new do |spec|
  spec.name    = "ace-cmd"
  spec.version = AceCmd::VERSION
  spec.authors = ["yurigitsu"]
  spec.email   = ["yurigi.pro@gmail.com"]
  spec.license = "MIT"

  spec.summary     = "A Ruby gem for creating command objects with result handling."
  spec.description = "AceCmd is a Ruby gem for implementing the Command pattern with result handling."
  spec.homepage    = "https://github.com/yurigitsu/#{spec.name}"

  spec.required_ruby_version = ">= 3.0.0"

  spec.files         = Dir["CHANGELOG.md", "LICENSE", "README.md", "ace-cmd.gemspec", "lib/**/*"]
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.metadata["repo_homepage"]     = "https://github.com/yurigitsu/"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"

  spec.metadata["rubygems_mfa_required"] = "true"

  spec.add_dependency "ace-config"
end
