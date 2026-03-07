# OmniAuth Rocket Chat Upgrade Guide

Follow this guide to upgrade your OmniAuth Rocket Chat Strategy to the next version

## Version 0.2

This version introduces breaking changes that may require your attention.

### Ruby version requirement

The minimum required Ruby version is now **3.2.0**. Support for older versions has been dropped.

### OmniAuth Auth Hash Schema 1.0+ compliance

The `info` hash has been refactored to follow the [Auth Hash Schema 1.0+](https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema).

*   `nickname` replaces `username`.
*   `image` (the avatar URL) replaces the nested `avatar` hash.
*   `active` and `roles` have been removed.

If you still need access to `active` or `roles`, you can find them in `extra.raw_info`.

### Email handling

The strategy now always returns an `info.email` address, even if it hasn't been verified on the Rocket Chat instance.

*   A new boolean field `info.email_verified` indicates the verification status.
*   The strategy prioritizes verified email addresses but will fall back to the first available one.

### PKCE requirement

Rocket.Chat version 7.4.0 [introduced a bug](https://github.com/RocketChat/Rocket.Chat/issues/35419) that breaks third-party logins. A [partial fix](https://github.com/RocketChat/Rocket.Chat/pull/37707) is available starting in version 8.0.0, but PKCE flows remain affected.

Until this is fully resolved, you must set `pkce: false` in your configuration.
