# Changelog

## [0.1.0-beta.1-wip]

### Added

- Initial release.
- `tracedLithic<T>(...)` — wraps a otel_lithic call in a CLIENT-kind span
  with vendor-specific attributes.
- Zone-scoped suppression via `runWithoutLithicInstrumentation()` / `Async()`.
