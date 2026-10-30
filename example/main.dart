// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_lithic/otel_lithic.dart';

/// Traces Lithic calls with OpenTelemetry.
///
/// `otel_lithic` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Lithic call in
/// [tracedLithic]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'lithic-example');

  // Traces a Lithic call.
  final lithicId = await tracedLithic<String>(
    operation: 'create',
    invoke: () async {
      // Make the Lithic call here, then report what it returned.
      const id = 'lithic_8f3a2c';
      return const LithicCallResult(
          value: id,
          result: LithicResult(
              account: 'example',
              cardToken: 'example',
              cardType: 'standard',
              cardState: 'active',
              transactionToken: 'example',
              amount: 0.5,
              currency: 'usd',
              merchantCategory: 'example',
              result: 'example',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedLithic create returned $lithicId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutLithicInstrumentationAsync.
  await runWithoutLithicInstrumentationAsync(
    () => tracedLithic<String>(
      operation: 'create',
      invoke: () async {
        const id = 'lithic_8f3a2c';
        return const LithicCallResult(
            value: id,
            result: LithicResult(
                account: 'example',
                cardToken: 'example',
                cardType: 'standard',
                cardState: 'active',
                transactionToken: 'example',
                amount: 0.5,
                currency: 'usd',
                merchantCategory: 'example',
                result: 'example',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
