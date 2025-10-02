import 'platform_output_native.dart'
    if (dart.library.js_interop) 'logger_web.dart';

/// Handles platform-specific output
class PlatformOutput {
  /// Output a message using the appropriate platform method
  static void output(String message, String level) {
    PlatformOutputImpl.output(message, level);
  }

  /// Output a JSON object using the appropriate platform method
  static void outputJson({
    required Object? object,
    required String level,
    String? label,
    bool enableColors = true,
    String? className,
    String? tag,
    String? functionName,
    String? locationUrl,
    bool includeTimestamp = false,
    String? dateTimeFormat,
    String? messageTemplate,
  }) {
    PlatformOutputImpl.outputJson(
      object: object,
      level: level,
      label: label,
      enableColors: enableColors,
      className: className,
      tag: tag,
      functionName: functionName,
      locationUrl: locationUrl,
      includeTimestamp: includeTimestamp,
      dateTimeFormat: dateTimeFormat,
      messageTemplate: messageTemplate,
    );
  }

  /// Output data in table format using the appropriate platform method
  static void outputTable({
    required Object? data,
    List<String>? columns,
    required String level,
    String? label,
    bool enableColors = true,
    String? className,
    String? tag,
    String? functionName,
    String? locationUrl,
    bool includeTimestamp = false,
    String? dateTimeFormat,
    String? messageTemplate,
  }) {
    PlatformOutputImpl.outputTable(
      data: data,
      columns: columns,
      level: level,
      label: label,
      enableColors: enableColors,
      className: className,
      tag: tag,
      functionName: functionName,
      locationUrl: locationUrl,
      includeTimestamp: includeTimestamp,
      dateTimeFormat: dateTimeFormat,
      messageTemplate: messageTemplate,
    );
  }
}
