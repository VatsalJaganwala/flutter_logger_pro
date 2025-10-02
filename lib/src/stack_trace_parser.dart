/// Utilities for parsing stack traces to extract caller information
class StackTraceParser {
  /// Extract the caller class name from stack trace
  static String? getCallerClass() {
    final traceLines = StackTrace.current.toString().split("\n");

    // Look through multiple frames to find the actual caller
    for (int i = 2; i < traceLines.length && i < 8; i++) {
      final frame = traceLines[i];

      // Skip logger internal frames
      if (frame.contains('package:flutter_logger_pro') || frame.contains('dart-sdk')) {
        continue;
      }

      // Try different patterns for different platforms
      RegExpMatch? match;

      // Pattern 1: Native Dart - "new ClassName"
      match = RegExp(r'new\s+([A-Za-z0-9_]+)').firstMatch(frame);
      if (match != null) {
        return match.group(1);
      }

      // Pattern 2: Web/Package - "package:package_name/file.dart line:col functionName"
      match = RegExp(
        r'package:[^/]+/[^/]*([A-Za-z0-9_]+)\.dart\s+\d+:\d+\s+([A-Za-z0-9_]+)',
      ).firstMatch(frame);
      if (match != null) {
        final fileName = match.group(1);
        final functionName = match.group(2);
        // If function name looks like a class constructor, use it
        if (functionName == 'new' && fileName != null) {
          return fileName;
        }
        // Otherwise try to extract class from filename
        return fileName;
      }

      // Pattern 3: Web - just the function/class name at the end
      match = RegExp(r'\s+([A-Za-z0-9_]+)$').firstMatch(frame);
      if (match != null) {
        final name = match.group(1);
        if (name != null && !['new', 'get', 'set', 'call'].contains(name)) {
          return name;
        }
      }
    }

    return null;
  }

  /// Extract path and caller function from stack trace
  static (String, String)? getPathAndCallerFunction() {
    final traceLines = StackTrace.current.toString().split("\n");

    for (int i = 0; i < traceLines.length && i < 15; i++) {
      final frame = traceLines[i];
      if (frame.contains('package:flutter_logger_pro') || frame.contains('dart-sdk')) {
        continue;
      }

      // Check if this is Android/Native format (starts with #number)
      if (frame.trim().startsWith('#')) {
        // Android format: "#4      Incrementor.demoTableLogger (package:logger_example/main.dart:323:17)"
        final androidRegex = RegExp(
          r'#\d+\s+([A-Za-z0-9_]+\.[A-Za-z0-9_]+)\s+\((.*?:\d+:\d+)\)',
        );
        final androidMatch = androidRegex.firstMatch(frame);

        if (androidMatch != null) {
          final functionName = androidMatch.group(
            1,
          ); // e.g., "Incrementor.demoTableLogger"
          final pathWithLine = androidMatch.group(
            2,
          ); // e.g., "package:logger_example/main.dart:323:17"

          if (functionName != null && pathWithLine != null) {
            return (pathWithLine, functionName);
          }
        }
      } else {
        // Web format: Extract URL with line:column and function name
        final webRegex = RegExp(r'^(.*?\s+\d+:\d+)\s+(\[?(.*?)\]?)$');
        final webMatch = webRegex.firstMatch(frame);

        if (webMatch != null) {
          final urlWithLine = webMatch.group(
            1,
          ); // captures file path + line:column
          final functionName = webMatch.group(
            3,
          ); // captures function/method name

          if ((functionName?.isEmpty ?? true) ||
              (urlWithLine?.isEmpty ?? true)) {
            continue;
          }

          return (urlWithLine!, functionName!);
        }
      }
    }
    return null;
  }
}
