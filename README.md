[Rocket Chat]: https://rocket.chat/
[OmniAuth]: https://github.com/omniauth/omniauth
[gem]: https://rubygems.org/gems/omniauth-rocketchat
[license]: LICENSE.md
[contributing]: CODE_OF_CONDUCT.md

# 🔓 OmniAuth Rocket Chat

[![Gem Version](http://img.shields.io/gem/v/omniauth-rocketchat.svg)][gem]
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)][license]
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)][contributing]

## 🚀 Authenticate with Rocket Chat in your Ruby applications

This unofficial [OmniAuth] strategy allows your application's users to authenticate with [Rocket Chat] as the identity provider (aka social login).

## Requirements

* Ruby `>= 3.2.0`.
* Rocket Chat `<= 7.4.0` (EOL) or `>= 8.0.0`. See [Compatibility](#compatibility) below.

### Compatibility

Rocket.Chat version 7.4.0 [introduced a bug](https://github.com/RocketChat/Rocket.Chat/issues/35419) that breaks third-party logins. A [partial fix](https://github.com/RocketChat/Rocket.Chat/pull/37707) is available starting in version 8.0.0, but PKCE flows remain affected. Until this is fully resolved, set `pkce: false` in the configurations below.

#### Compatibility Matrix

Excluding EOL versions:

| Rocket Chat Version | `pkce: false`      | `pkce: true` |
|---------------------|--------------------|--------------|
| `>= 7.10.x`         | :x:                | :x:          |
| `>= 8.0.x`          | :white_check_mark: | :x:          |

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-rocketchat'
```

Then execute `bundle install`.

## Configuration

> [!NOTE]
> Rocket Chat doesn't support `scopes`. Users grant you full permissions to their account. Handle responsibly!

### Rocket Chat

To enable third-party login, register your application in Rocket Chat to obtain the `Client ID` and `Client Secret`. Add your application's host(s) to whitelist callback redirects by following these steps:

1. Log in to your Rocket Chat instance as an administrator.
2. Navigate to Administration > Third-party login (e.g., https://example.com/admin/third-party-login).
3. Click New Application:
   * Enable the Active checkbox.
   * Enter an Application Name and Redirect URL (e.g., https://example.com/users/auth/rocketchat/callback for Devise).
   * Click Save.
4. Select your new application and copy the `Client ID` and `Client Secret`.

### Ruby Integration

Choose one of the following methods to integrate the strategy with your Ruby application.

#### Required Options
    
```ruby
use OmniAuth::Builder do
  provider(
    :rocketchat, 
    ENV["CLIENT_ID"],
    ENV["CLIENT_SECRET"], 
    pkce: false,
    client_options: {
      site: "https://example.com"
    }
  )
end
```

#### Custom Endpoints

If you modified the endpoint URL's in Rocket Chat, set `authorize_url` and `token_url`.

```ruby
use OmniAuth::Builder do
  provider(
    :rocketchat,
    ENV["CLIENT_ID"],
    ENV["CLIENT_SECRET"],
    pkce: false,
    client_options: {
      site: "https://example.com",
      authorize_url: "/custom/oauth/authorize",
      token_url: "/custom/oauth/token"
    }
  )
end
```

#### Custom Identifier

Set the `name` option to distinguish between multiple Rocket Chat instances. It appears in the OmniAuth auth hash `request.env["omniauth.auth"]` under the `provider` key.

```ruby
use OmniAuth::Build do
  provider(
    :rocketchat,
    ENV["CLIENT_ID"],
    ENV["CLIENT_SECRET"],
    name: :some_other_name,
    pkce: false,           
    client_options: {
      site: "https://example.com"
    }
  )
end
```

### Rails Integration

Choose one of the following methods to integrate the strategy with your Ruby on Rails application. The [Custom Endpoints](#custom-endpoints) and [Identifier](#custom-identifier) options apply here as well.

#### General

```ruby
# config/initializers/rocketchat.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :rocketchat,
    ENV["CLIENT_ID"],
    ENV["CLIENT_SECRET"],
    pkce: false,           
    client_options: {
      site: "https://example.com"
    }
  )
end
```

#### When using Devise

Use this integration if you use Devise with the `:omniauthable` module.

```ruby
# config/initializers/rocketchat.rb
Devise.setup do |config|
  config.omniauth(
    :rocketchat,
    ENV["CLIENT_ID"],
    ENV["CLIENT_SECRET"],
    pkce: false,
    client_options: {
      site: "https://example.com"
    }
  )
end
```

## Auth Hash Schema

### User Info

This strategy returns information about the authenticated user in the [Auth Hash Schema 1.0+](https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema). The following information is available in the `info` hash:

* `name`: The user's full name.
* `nickname`: The user's Rocket Chat username.
* `email`: The user's email address. The strategy prioritizes verified email addresses but will fall back to the first available one if no verified address is found.
* `email_verified`: A boolean indicating whether the email address has been verified on the Rocket Chat instance.
* `image`: The URL to the user's avatar.

You can find the complete profile information returned by Rocket Chat in `extra.raw_info`.

### Credentials

Rocket Chat also returns access and refresh tokens along with other information in the `credentials` hash.

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0](http://semver.org/). Violations of this scheme should be reported as bugs.

## Contributing

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

Bug reports and pull requests are welcome on the [GitHub project page](https://github.com/david-uhlig/omniauth-rocketchat).

## License

Copyright &copy; 2024-2026 David Uhlig. See [LICENSE][] for details.

