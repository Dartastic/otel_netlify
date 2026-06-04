// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_netlify_suppression.dart';

class NetlifyResult {
  const NetlifyResult({
    this.account,
    this.siteId,
    this.siteName,
    this.deployId,
    this.deployState,
    this.functionName,
    this.branch,
    this.commit,
    this.edgeLocation,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? account;
  final String? siteId;
  final String? siteName;
  final String? deployId;
  final String? deployState;
  final String? functionName;
  final String? branch;
  final String? commit;
  final String? edgeLocation;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class NetlifyCallResult<T> {
  const NetlifyCallResult({required this.value, this.result});
  final T value;
  final NetlifyResult? result;
}

Future<T> tracedNetlify<T>({
  required String operation,
  required Future<NetlifyCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (netlifyInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_netlify');
  final span = t.startSpan('netlify $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'netlify')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.account != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('netlify.account', res.account!)]));
      }
      if (res.siteId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('netlify.site.id', res.siteId!)]));
      }
      if (res.siteName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('netlify.site.name', res.siteName!)]));
      }
      if (res.deployId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('netlify.deploy.id', res.deployId!)]));
      }
      if (res.deployState != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('netlify.deploy.state', res.deployState!)]));
      }
      if (res.functionName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('faas.invoked_name', res.functionName!)]));
      }
      if (res.branch != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('vcs.ref.head.name', res.branch!)]));
      }
      if (res.commit != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('vcs.ref.head.revision', res.commit!)]));
      }
      if (res.edgeLocation != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('netlify.edge_location', res.edgeLocation!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('netlify.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              ErrorResource.errorType.key, res.errorCode ?? 'netlify.error')
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
