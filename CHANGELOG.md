# Changelog

## [0.1.0-beta.1-wip]

### Added

- Initial release.
- `tracedNetlify<T>(...)` — wraps a otel_netlify call in a CLIENT-kind span
  with vendor-specific attributes.
- Zone-scoped suppression via `runWithoutNetlifyInstrumentation()` / `Async()`.
