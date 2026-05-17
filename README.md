# otel_lithic

Dartastic OpenTelemetry bridge for Lithic (card issuing + KYC).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_lithic/otel_lithic.dart';

await tracedLithic<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return LithicCallResult(value: r, result: LithicResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutLithicInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
