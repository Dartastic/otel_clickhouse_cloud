// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_clickhouse_cloud_suppression.dart';

class ClickhouseCloudResult {
  const ClickhouseCloudResult({
    this.organizationId,
    this.serviceId,
    this.serviceName,
    this.region,
    this.cloudProvider,
    this.tier,
    this.endpoint,
    this.databaseName,
    this.tableName,
    this.queryKind,
    this.queryId,
    this.userName,
    this.rowsRead,
    this.rowsReturned,
    this.rowsWritten,
    this.bytesRead,
    this.bytesWritten,
    this.queryDurationMs,
    this.memoryUsageBytes,
    this.resultRows,
    this.resultBytes,
    this.compressedBytes,
    this.replicasUsed,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? organizationId;
  final String? serviceId;
  final String? serviceName;
  final String? region;
  final String? cloudProvider;
  final String? tier;
  final String? endpoint;
  final String? databaseName;
  final String? tableName;
  final String? queryKind;
  final String? queryId;
  final String? userName;
  final int? rowsRead;
  final int? rowsReturned;
  final int? rowsWritten;
  final int? bytesRead;
  final int? bytesWritten;
  final int? queryDurationMs;
  final int? memoryUsageBytes;
  final int? resultRows;
  final int? resultBytes;
  final int? compressedBytes;
  final int? replicasUsed;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class ClickhouseCloudCallResult<T> {
  const ClickhouseCloudCallResult({required this.value, this.result});
  final T value;
  final ClickhouseCloudResult? result;
}

Future<T> tracedClickhouseCloud<T>({
  required String operation,
  required Future<ClickhouseCloudCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (clickhouseCloudInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_clickhouse_cloud');
  final span =
      t.startSpan('clickhouse_cloud $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'clickhouse');
    span.setStringAttribute('rpc.method', operation);
    span.setStringAttribute('db.system', 'clickhouse');
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.organizationId != null) {
        span.setStringAttribute(
            'clickhouse.organization.id', res.organizationId!);
      }
      if (res.serviceId != null) {
        span.setStringAttribute('clickhouse.service.id', res.serviceId!);
      }
      if (res.serviceName != null) {
        span.setStringAttribute('clickhouse.service.name', res.serviceName!);
      }
      if (res.region != null) {
        span.setStringAttribute('clickhouse.region', res.region!);
      }
      if (res.cloudProvider != null) {
        span.setStringAttribute(
            'clickhouse.cloud_provider', res.cloudProvider!);
      }
      if (res.tier != null) {
        span.setStringAttribute('clickhouse.tier', res.tier!);
      }
      if (res.endpoint != null) {
        span.setStringAttribute('clickhouse.endpoint', res.endpoint!);
      }
      if (res.databaseName != null) {
        span.setStringAttribute('db.name', res.databaseName!);
      }
      if (res.tableName != null) {
        span.setStringAttribute('db.sql.table', res.tableName!);
      }
      if (res.queryKind != null) {
        span.setStringAttribute('clickhouse.query.kind', res.queryKind!);
      }
      if (res.queryId != null) {
        span.setStringAttribute('clickhouse.query.id', res.queryId!);
      }
      if (res.userName != null) {
        span.setStringAttribute('db.user', res.userName!);
      }
      if (res.rowsRead != null) {
        span.setIntAttribute('clickhouse.rows.read', res.rowsRead!);
      }
      if (res.rowsReturned != null) {
        span.setIntAttribute('clickhouse.rows.returned', res.rowsReturned!);
      }
      if (res.rowsWritten != null) {
        span.setIntAttribute('clickhouse.rows.written', res.rowsWritten!);
      }
      if (res.bytesRead != null) {
        span.setIntAttribute('clickhouse.bytes.read', res.bytesRead!);
      }
      if (res.bytesWritten != null) {
        span.setIntAttribute('clickhouse.bytes.written', res.bytesWritten!);
      }
      if (res.queryDurationMs != null) {
        span.setIntAttribute(
            'clickhouse.query.duration_ms', res.queryDurationMs!);
      }
      if (res.memoryUsageBytes != null) {
        span.setIntAttribute(
            'clickhouse.memory.usage_bytes', res.memoryUsageBytes!);
      }
      if (res.resultRows != null) {
        span.setIntAttribute('clickhouse.result.rows', res.resultRows!);
      }
      if (res.resultBytes != null) {
        span.setIntAttribute('clickhouse.result.bytes', res.resultBytes!);
      }
      if (res.compressedBytes != null) {
        span.setIntAttribute(
            'clickhouse.compressed_bytes', res.compressedBytes!);
      }
      if (res.replicasUsed != null) {
        span.setIntAttribute('clickhouse.replicas.used', res.replicasUsed!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('clickhouse.error.code', res.errorCode!);
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(ErrorResource.errorType.key,
            res.errorCode ?? 'clickhouse_cloud.error');
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
