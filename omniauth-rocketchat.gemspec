# frozen_string_literal: true

require_relative "lib/omniauth-rocketchat/version"

Gem::Specification.new do |spec|
  spec.name = "omniauth-rocketchat"
  spec.version = OmniAuth::RocketChat::VERSION
  spec.authors = ["David Uhlig"]
  spec.email = ["david.uhlig@gmail.com"]

  spec.summary = "An unofficial Rocket Chat OAuth2 strategy."
  spec.description = <<~DESC
    Allows your application to integrate with Rocket Chat through their "Third-party login" feature.
  DESC
  spec.homepage = "https://github.com/david-uhlig/omniauth-rocketchat"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/david-uhlig/omniauth-rocketchat/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .standard.yml mise.toml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "omniauth-oauth2", "~> 1.8"
  spec.add_development_dependency "irb"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "standard", "~> 1.3"
  spec.add_development_dependency "simplecov"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
