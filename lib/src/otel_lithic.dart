// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_lithic_suppression.dart';

class LithicResult {
  const LithicResult({
    this.account,
    this.cardToken,
    this.cardType,
    this.cardState,
    this.transactionToken,
    this.amount,
    this.currency,
    this.merchantCategory,
    this.result,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? account;
  final String? cardToken;
  final String? cardType;
  final String? cardState;
  final String? transactionToken;
  final double? amount;
  final String? currency;
  final String? merchantCategory;
  final String? result;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class LithicCallResult<T> {
  const LithicCallResult({required this.value, this.result});
  final T value;
  final LithicResult? result;
}

Future<T> tracedLithic<T>({
  required String operation,
  required Future<LithicCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (lithicInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_lithic');
  final span = t.startSpan('lithic $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'lithic');
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.account != null) {
        span.setStringAttribute('lithic.account', res.account!);
      }
      if (res.cardToken != null) {
        span.setStringAttribute('lithic.card.token', res.cardToken!);
      }
      if (res.cardType != null) {
        span.setStringAttribute('lithic.card.type', res.cardType!);
      }
      if (res.cardState != null) {
        span.setStringAttribute('lithic.card.state', res.cardState!);
      }
      if (res.transactionToken != null) {
        span.setStringAttribute(
          'lithic.transaction.token',
          res.transactionToken!,
        );
      }
      if (res.amount != null) {
        span.setDoubleAttribute('lithic.amount', res.amount!);
      }
      if (res.currency != null) {
        span.setStringAttribute('lithic.currency', res.currency!);
      }
      if (res.merchantCategory != null) {
        span.setStringAttribute(
          'lithic.merchant.category',
          res.merchantCategory!,
        );
      }
      if (res.result != null) {
        span.setStringAttribute('lithic.result', res.result!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('lithic.error.code', res.errorCode!);
      }
      final fail =
          res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(
          ErrorResource.errorType.key,
          res.errorCode ?? 'lithic.error',
        );
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
