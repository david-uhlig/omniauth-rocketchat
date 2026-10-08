# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Add `bin/compat` to check compatibility against real Rocket Chat instances.

### Removed
- Drop documented support for EOL Rocket Chat versions below 8.2.0.

## [0.2.0] - 2026-03-08

### Breaking Changes
See [Upgrade Instructions](UPGRADE.md#version-02) for detailed upgrade instructions.

- Bump required Ruby version to `>= 3.2`.
- The `info` hash now returns the expected [Auth Hash Schema 1.0+](https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema).
- Always return `info.email`, even if the email was not verified. Check `info.email_verified` for verification status.

[Unreleased]: https://github.com/david-uhlig/omniauth-rocketchat/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/david-uhlig/omniauth-rocketchat/compare/v0.1.2...v0.2.0
