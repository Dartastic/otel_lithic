# Changelog

## [0.1.0-beta.2] - 2026-06-10

## [0.1.0-beta.1] - 2026-06-04

### Added

- Initial release.
- `tracedLithic<T>(...)` — wraps a otel_lithic call in a CLIENT-kind span
  with vendor-specific attributes.
- Zone-scoped suppression via `runWithoutLithicInstrumentation()` / `Async()`.
