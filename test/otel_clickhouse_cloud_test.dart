// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_clickhouse_cloud/otel_clickhouse_cloud.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_clickhouse_cloud-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('query.SELECT records rows + bytes + duration', () async {
    await tracedClickhouseCloud<String>(
      operation: 'query.SELECT',
      invoke: () async => const ClickhouseCloudCallResult(
        value: 'ok',
        result: ClickhouseCloudResult(
          serviceName: 'analytics-prod',
          region: 'us-east-1',
          cloudProvider: 'aws',
          tier: 'production',
          databaseName: 'events',
          tableName: 'page_views',
          queryKind: 'Select',
          rowsRead: 5000000,
          rowsReturned: 1000,
          bytesRead: 268435456,
          queryDurationMs: 145,
          resultRows: 1000,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('clickhouse_cloud query.SELECT')!);
    expect(a['db.system'], 'clickhouse');
    expect(a['clickhouse.rows.read'], 5000000);
    expect(a['clickhouse.bytes.read'], 268435456);
  });

  test('error code sets span error', () async {
    await tracedClickhouseCloud<String>(
      operation: 'query.INSERT',
      invoke: () async => const ClickhouseCloudCallResult(
        value: 'ok',
        result: ClickhouseCloudResult(
          errorCode: '241',
          statusCode: 500,
          errorMessage: 'MEMORY_LIMIT_EXCEEDED',
        ),
      ),
    );
    expect(
      spans.findSpanByName('clickhouse_cloud query.INSERT')!.status,
      SpanStatusCode.Error,
    );
  });

  test('insert records rows_written + compressed_bytes', () async {
    await tracedClickhouseCloud<String>(
      operation: 'query.INSERT',
      invoke: () async => const ClickhouseCloudCallResult(
        value: 'ok',
        result: ClickhouseCloudResult(
          queryKind: 'Insert',
          rowsWritten: 100000,
          bytesWritten: 10485760,
          compressedBytes: 2097152,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('clickhouse_cloud query.INSERT')!);
    expect(a['clickhouse.rows.written'], 100000);
    expect(a['clickhouse.compressed_bytes'], 2097152);
  });

  test('suppression skips spans', () async {
    await runWithoutClickhouseCloudInstrumentationAsync(() async {
      await tracedClickhouseCloud<String>(
        operation: 'services.list',
        invoke: () async => const ClickhouseCloudCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('clickhouse_cloud '), isEmpty);
  });
}
