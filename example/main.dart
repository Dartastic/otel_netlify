// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_netlify/otel_netlify.dart';

/// Traces Netlify calls with OpenTelemetry.
///
/// `otel_netlify` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Netlify call in
/// [tracedNetlify]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'netlify-example');

  // Traces a Netlify call.
  final netlifyId = await tracedNetlify<String>(
    operation: 'create',
    invoke: () async {
      // Make the Netlify call here, then report what it returned.
      const id = 'netlify_8f3a2c';
      return const NetlifyCallResult(
          value: id,
          result: NetlifyResult(
              account: 'example',
              siteId: 'site_8f3a2c',
              siteName: 'example',
              deployId: 'deploy_8f3a2c',
              deployState: 'active',
              functionName: 'example',
              branch: 'example',
              commit: 'example',
              edgeLocation: 'example',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedNetlify create returned $netlifyId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutNetlifyInstrumentationAsync.
  await runWithoutNetlifyInstrumentationAsync(
    () => tracedNetlify<String>(
      operation: 'create',
      invoke: () async {
        const id = 'netlify_8f3a2c';
        return const NetlifyCallResult(
            value: id,
            result: NetlifyResult(
                account: 'example',
                siteId: 'site_8f3a2c',
                siteName: 'example',
                deployId: 'deploy_8f3a2c',
                deployState: 'active',
                functionName: 'example',
                branch: 'example',
                commit: 'example',
                edgeLocation: 'example',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
