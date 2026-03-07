# Changelog

### Unreleased

This release contains breaking changes. See [Upgrade Instructions](UPGRADE.md#version-02) for detailed upgrade instructions.

#### Breaking

- Bumps required Ruby version `>= 3.2`.
- The `info` hash now returns the expected [Auth Hash Schema 1.0+](https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema).
- Always returns `info.email`, even if the email was not verified. Check `info.email_verified` for verification status.

### 0.2.0 / 2026-03-07
