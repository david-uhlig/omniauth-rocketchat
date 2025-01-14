source "https://rubygems.org"

ruby "3.3.6", platforms: [ :ruby, :x86_64_linux ]

gem "rake", "~> 13.0"

group :test do
  gem "addressable", "~> 2.3.8", platforms: %i[jruby ruby_18]
  gem "coveralls_reborn", "~> 0.28.0", require: false
  gem "json", platforms: %i[jruby ruby_18 ruby_19]
  gem "mime-types", "~> 3.6", platforms: %i[jruby ruby_18]
  gem "rack-test"
  gem "rest-client", "~> 2.1.0", platforms: %i[jruby ruby_18]
  gem "rspec", "~> 3.8"
  gem "rubocop", "~> 1.70", platforms: %i[ruby_19 ruby_20 ruby_21 ruby_22 ruby_23 ruby_24]
  gem "simplecov-lcov"
  gem "tins", "~> 1.13", platforms: %i[jruby_18 jruby_19 ruby_19]
  gem "webmock", "~> 3.0"
end

# Specify your gem's dependencies in omniauth-oauth2.gemspec
gemspec
