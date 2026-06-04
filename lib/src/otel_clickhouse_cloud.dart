// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

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
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'clickhouse')]));
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.method', operation)]));
    span.addAttributes(
        OTel.attributes([OTel.attributeString('db.system', 'clickhouse')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.organizationId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'clickhouse.organization.id', res.organizationId!)
        ]));
      }
      if (res.serviceId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('clickhouse.service.id', res.serviceId!)]));
      }
      if (res.serviceName != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('clickhouse.service.name', res.serviceName!)
        ]));
      }
      if (res.region != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('clickhouse.region', res.region!)]));
      }
      if (res.cloudProvider != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('clickhouse.cloud_provider', res.cloudProvider!)
        ]));
      }
      if (res.tier != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('clickhouse.tier', res.tier!)]));
      }
      if (res.endpoint != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('clickhouse.endpoint', res.endpoint!)]));
      }
      if (res.databaseName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('db.name', res.databaseName!)]));
      }
      if (res.tableName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('db.sql.table', res.tableName!)]));
      }
      if (res.queryKind != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('clickhouse.query.kind', res.queryKind!)]));
      }
      if (res.queryId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('clickhouse.query.id', res.queryId!)]));
      }
      if (res.userName != null) {
        span.addAttributes(
            OTel.attributes([OTel.attributeString('db.user', res.userName!)]));
      }
      if (res.rowsRead != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('clickhouse.rows.read', res.rowsRead!)]));
      }
      if (res.rowsReturned != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('clickhouse.rows.returned', res.rowsReturned!)
        ]));
      }
      if (res.rowsWritten != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('clickhouse.rows.written', res.rowsWritten!)]));
      }
      if (res.bytesRead != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('clickhouse.bytes.read', res.bytesRead!)]));
      }
      if (res.bytesWritten != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('clickhouse.bytes.written', res.bytesWritten!)
        ]));
      }
      if (res.queryDurationMs != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'clickhouse.query.duration_ms', res.queryDurationMs!)
        ]));
      }
      if (res.memoryUsageBytes != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'clickhouse.memory.usage_bytes', res.memoryUsageBytes!)
        ]));
      }
      if (res.resultRows != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('clickhouse.result.rows', res.resultRows!)]));
      }
      if (res.resultBytes != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('clickhouse.result.bytes', res.resultBytes!)]));
      }
      if (res.compressedBytes != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('clickhouse.compressed_bytes', res.compressedBytes!)
        ]));
      }
      if (res.replicasUsed != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('clickhouse.replicas.used', res.replicasUsed!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('clickhouse.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(ErrorResource.errorType.key,
              res.errorCode ?? 'clickhouse_cloud.error')
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
