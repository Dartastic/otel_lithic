// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'dart:async';

const _key = #dartastic_otel_libs_lithic_suppress;

bool lithicInstrumentationSuppressed() => Zone.current[_key] == true;

T runWithoutLithicInstrumentation<T>(T Function() body) =>
    runZoned(body, zoneValues: {_key: true});

Future<T> runWithoutLithicInstrumentationAsync<T>(Future<T> Function() body) =>
    runZoned(body, zoneValues: {_key: true});
