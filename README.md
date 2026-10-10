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
* Rocket Chat `>= 8.2.0`. See [Compatibility](#compatibility) below.

### Compatibility

Rocket Chat [doesn't store the PKCE code challenge](https://github.com/RocketChat/Rocket.Chat/issues/39459), so the token exchange fails with `Invalid grant: code verifier is invalid`. Until this is resolved, set `pkce: false` in the configurations below.

#### Compatibility Matrix

| Rocket Chat Version | `pkce: false`      | `pkce: true` |
|---------------------|--------------------|--------------|
| `>= 8.2.0`          | :white_check_mark: | :x:          |

Versions below 8.2.0 are EOL and not supported. Use [`bin/compat`](#compatibility-check) to check a specific version.

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then run `bundle exec rake` to run the specs and the linter.

### Compatibility Check

`bin/compat` runs the full OAuth flow against real Rocket Chat instances: request phase, user consent, token exchange, and profile fetch. It tests both `pkce: true` and `pkce: false`, and prints the result of each flow, a compatibility matrix and a plain-language summary. It exits non-zero if any flow fails.

By default, it starts throwaway Docker containers (MongoDB and Rocket Chat) for each version you pass. It removes them afterwards. Versions are [`rocketchat/rocket.chat`](https://hub.docker.com/r/rocketchat/rocket.chat/tags) image tags. Docker is required.

```sh
bin/compat 8.9.0              # a single version
bin/compat 8.2.0 8.9.0        # several versions, one matrix
bin/compat --keep 8.9.0       # keep the containers running for debugging
bin/compat --mongo mongo:7.0 8.2.0  # use another MongoDB image (default: mongo:8.2)
```

You can also test unreleased code, e.g. to check whether an upstream fix works. The script uses the images Rocket Chat's CI publishes to `ghcr.io/rocketchat/rocket.chat`. These exist for the `develop` branch and for pull requests from branches of the [Rocket.Chat](https://github.com/RocketChat/Rocket.Chat) repository, not for pull requests from forks. The matrix shows the commit each image was built from.

```sh
bin/compat --pr 42686                  # a pull request
bin/compat --ref develop               # a branch
bin/compat 8.9.0 --ref develop         # mix with released versions in one matrix
```

Set `GITHUB_TOKEN` (or `GH_TOKEN`) if you hit GitHub's API rate limit.

You can also test against an existing instance. The user needs permission to manage OAuth apps:

```sh
ROCKETCHAT_PASSWORD=secret bin/compat --site https://chat.example.com --user admin
```

The script registers a temporary OAuth app with the redirect URL `http://localhost:4567/auth/rocketchat/callback` and deletes it afterwards. Run `bin/compat --help` for all options.

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0](http://semver.org/). Violations of this scheme should be reported as bugs.

## Contributing

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

Bug reports and pull requests are welcome on the [GitHub project page](https://github.com/david-uhlig/omniauth-rocketchat).

## License

Copyright &copy; 2024-2026 David Uhlig. See [LICENSE][] for details.

