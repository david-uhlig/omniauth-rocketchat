# Changelog

### Unreleased

- [Breaking] The `info` hash now returns the expected [Auth Hash Schema 1.0+](https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema).
- [Breaking] Always returns an `info.email`, even if the email was not verified. Check `info.email_verified` for verification status.
- [Breaking] Bump required Ruby version `>= 3.2`.

### 0.2.0 / 2026-03-07
