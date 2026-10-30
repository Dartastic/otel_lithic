// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_lithic_suppression.dart';

class LithicResult {
  /// Creates a result.
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

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class LithicCallResult<T> {
  /// Creates a call result.
  const LithicCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final LithicResult? result;
}

Future<T> tracedLithic<T>({
  required String operation,
  required Future<LithicCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (lithicInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_lithic');
  final span = t.startSpan('lithic $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.system', 'lithic')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.account != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('lithic.account', res.account!)]));
      }
      if (res.cardToken != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('lithic.card.token', res.cardToken!)]));
      }
      if (res.cardType != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('lithic.card.type', res.cardType!)]));
      }
      if (res.cardState != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('lithic.card.state', res.cardState!)]));
      }
      if (res.transactionToken != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
            'lithic.transaction.token',
            res.transactionToken!,
          )
        ]));
      }
      if (res.amount != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeDouble('lithic.amount', res.amount!)]));
      }
      if (res.currency != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('lithic.currency', res.currency!)]));
      }
      if (res.merchantCategory != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
            'lithic.merchant.category',
            res.merchantCategory!,
          )
        ]));
      }
      if (res.result != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('lithic.result', res.result!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('lithic.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
            ErrorAttributes.errorType.key,
            res.errorCode ?? 'lithic.error',
          )
        ]));
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
