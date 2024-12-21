# OmniAuth Rocket Chat OAuth2 Strategy

[![Gem Version](http://img.shields.io/gem/v/omniauth-rocketchat.svg)][gem]
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)][license]
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)][contributing]

[gem]: https://rubygems.org/gems/omniauth-rocketchat
[license]: LICENSE
[contributing]: CODE_OF_CONDUCT.md

Unofficial OmniAuth strategy to authenticate with [Rocket Chat](https://rocket.chat/) through OAuth2 in [OmniAuth](https://github.com/omniauth/omniauth).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-rocketchat'
```

Then execute `bundle install`.

## Rocket Chat Setup

You need to register your application with your Rocket Chat instance to obtain the `Client ID` and `Client Secret`. You will also need to add this applications host(s). This whitelists your application for the callback redirect. You can do this by following the steps below:

* Go to your Rocket Chat instance and login as an administrator.
* Go to `Administration` -> `Third-party login`.
* Click on `New Application`.
  * Check the `Active` checkbox.
  * Fill in the `Application Name` and `Redirect URL`. The redirect URL for devise looks like `https://example.com/users/auth/rocketchat/callback`. You can add multiple hosts by separating them with a comma.
  * Click on `Save`.
* Select the third-party login you just created.
  * Copy the `Client ID` and `Client Secret`.

## Integration

Pick one of the following methods to integrate the strategy with your application.

### Basic Usage
    
```ruby
use OmniAuth::Builder do
  provider :rocketchat,
  ENV["ROCKETCHAT_CLIENT_ID"],
  ENV["ROCKETCHAT_CLIENT_SECRET"],
  client_options: {
    site: "https://example.com"
  }
end
```

### With Custom Endpoints
```ruby
use OmniAuth::Builder do
  provider :rocketchat,
  ENV["ROCKETCHAT_CLIENT_ID"],
  ENV["ROCKETCHAT_CLIENT_SECRET"],
  client_options: {
    site: "https://example.com",
    authorize_url: "/custom/oauth/authorize",
    token_url: "/custom/oauth/token"
  }
end
```

### In Rails
```ruby
# config/initializers/rocketchat.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :rocketchat,
  ENV["ROCKETCHAT_CLIENT_ID"],
  ENV["ROCKETCHAT_CLIENT_SECRET"],
  client_options: {
    site: "https://example.com"
  }
end
```

### With Devise
```ruby
# config/initializers/rocketchat.rb
Devise.setup do |config|
  config.omniauth :rocketchat,
  ENV["ROCKETCHAT_CLIENT_ID"],
  ENV["ROCKETCHAT_CLIENT_SECRET"],
  client_options: {
    site: "https://example.com"
  }
end
```

## Configuration

* The `client_options` options: `authorize_url` and `token_url` are optional and default to `/oauth/authorize` and `/oauth/token` respectively.
* `scope` has no effect on Rocket Chat. Users grant you full permissions to their account. Handle responsibly!

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0](http://semver.org/). Violations of this scheme should be reported as bugs.

## Contributing

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

Bug reports and pull requests are welcome on the [GitHub project page](https://github.com/david-uhlig/omniauth-rocketchat).

## License

Copyright &copy; 2024 David Uhlig. See [LICENSE][] for details.

[license]: LICENSE

