# frozen_string_literal: true

require_relative "lib/voice_notes/version"

Gem::Specification.new do |spec|
  spec.name = "voice-notes-ruby"
  spec.version = VoiceNotes::VERSION
  spec.authors = ["Voice Notes"]
  spec.email = ["support@voice-notes.online"]

  spec.summary = "Ruby client for the Voice Notes API"
  spec.description = "Official Ruby client library for interacting with the Voice Notes API"
  spec.homepage = "https://github.com/voice-notes-online/voice-notes-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "webmock", "~> 3.18"
end
