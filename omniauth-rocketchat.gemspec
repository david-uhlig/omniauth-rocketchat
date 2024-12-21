# frozen_string_literal: true

require File.expand_path(
  File.join("..", "lib", "omniauth-rocketchat", "version"),
  __FILE__
)

Gem::Specification.new do |gem|
  gem.name          = "omniauth-rocketchat"
  gem.version       = OmniAuth::RocketChat::VERSION
  gem.license       = "MIT"
  gem.summary       = "An unofficial Rocket Chat OAuth2 strategy."
  gem.description   = 'Allows your application to integrate with Rocket Chat through their "Third-party login" feature.'

  gem.authors       = ["David Uhlig"]
  gem.email         = "david.uhlig@gmail.com"
  gem.homepage      = "https://github.com/david-uhlig/omniauth-rocketchat"

  gem.files         = `git ls-files -z`.split("\x0").reject { |f| f.start_with?('spec/') }
  gem.require_paths = %w[lib]

  gem.required_rubygems_version = '>= 1.3.5'
  gem.required_ruby_version     = '>= 2.2'

  gem.add_runtime_dependency 'oauth2', '~> 2.0'
  gem.add_runtime_dependency 'omniauth', '~> 2.0'
  gem.add_runtime_dependency 'omniauth-oauth2', '~> 1.8'

  gem.add_development_dependency "rake", "~> 13.0"
  gem.add_development_dependency "rubocop", "~> 1.0"
  gem.add_development_dependency "rspec", "~> 3.8"
  gem.add_development_dependency "simplecov", "~> 0.16"

  gem.platform = Gem::Platform::RUBY
end
