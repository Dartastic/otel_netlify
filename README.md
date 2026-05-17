# otel_netlify

Dartastic OpenTelemetry bridge for Netlify (web/serverless platform).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_netlify/otel_netlify.dart';

await tracedNetlify<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return NetlifyCallResult(value: r, result: NetlifyResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutNetlifyInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
