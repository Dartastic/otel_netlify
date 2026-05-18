// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:otel_netlify/otel_netlify.dart';
import 'package:test/test.dart';

void main() {
  group('otel_netlify', () {
    test('suppression toggles in zone', () async {
      expect(netlifyInstrumentationSuppressed(), isFalse);
      await runWithoutNetlifyInstrumentationAsync(() async {
        expect(netlifyInstrumentationSuppressed(), isTrue);
      });
      expect(netlifyInstrumentationSuppressed(), isFalse);
    });

    test('NetlifyResult fields default null', () {
      const r = NetlifyResult();
      expect(r.statusCode, isNull);
    });
  });
}
