// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_lithic/otel_lithic.dart';
import 'package:test/test.dart';

void main() {
  group('otel_lithic', () {
    test('suppression toggles in zone', () async {
      expect(lithicInstrumentationSuppressed(), isFalse);
      await runWithoutLithicInstrumentationAsync(() async {
        expect(lithicInstrumentationSuppressed(), isTrue);
      });
      expect(lithicInstrumentationSuppressed(), isFalse);
    });

    test('LithicResult fields default null', () {
      const r = LithicResult();
      expect(r.statusCode, isNull);
    });
  });
}
