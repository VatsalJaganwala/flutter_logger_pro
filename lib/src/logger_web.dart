import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:js_interop';

import 'package:flutter/foundation.dart';

import 'output_formatter.dart';
import 'table_formatter.dart';

/// Web platform output implementation
class PlatformOutputImpl {
  static void output(String message, String level) {
    switch (level) {
      case 'ERROR':
        console.error(message.toJS);
        break;
      case 'WARN':
        console.warn(message.toJS);
        break;
      case 'INFO':
        console.info(message.toJS);
        break;
      case 'DEBUG':
        console.log(message.toJS);
        break;
      default:
        console.log(message.toJS);
        break;
    }
  }

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
    try {
      // Create prefix for context (similar to regular log messages)
      final prefix = _buildJsonPrefix(
        level: level,
        className: className,
        tag: tag,
        functionName: functionName,
        includeTimestamp: includeTimestamp,
        dateTimeFormat: dateTimeFormat,
      );

      // For web, we'll use a hybrid approach:
      // 1. If it's a simple object, try to pass it directly to console
      // 2. Otherwise, format as JSON string but still use appropriate console method

      final displayLabel = label != null ? '$prefix$label' : prefix;

      // Try to convert to JS object for better browser console experience
      JSAny? jsObject;
      try {
        jsObject = _convertToJS(object);
      } catch (e) {
        // If conversion fails, we'll use string fallback below
        jsObject = null;
      }

      switch (level) {
        case 'ERROR':
          if (jsObject != null) {
            if (displayLabel.isNotEmpty) {
              console.error(displayLabel.toJS, jsObject);
            } else {
              console.error(jsObject);
            }
            // Also log to IDE console for debugging
            _logToIdeConsole(object, level, displayLabel);
          } else {
            _fallbackJsonOutput(object, displayLabel, level);
          }
          break;
        case 'WARN':
          if (jsObject != null) {
            if (displayLabel.isNotEmpty) {
              console.warn(displayLabel.toJS, jsObject);
            } else {
              console.warn(jsObject);
            }
            // Also log to IDE console for debugging
            _logToIdeConsole(object, level, displayLabel);
          } else {
            _fallbackJsonOutput(object, displayLabel, level);
          }
          break;
        case 'INFO':
          if (jsObject != null) {
            if (displayLabel.isNotEmpty) {
              console.info(displayLabel.toJS, jsObject);
            } else {
              console.info(jsObject);
            }
            // Also log to IDE console for debugging
            _logToIdeConsole(object, level, displayLabel);
          } else {
            _fallbackJsonOutput(object, displayLabel, level);
          }
          break;
        case 'DEBUG':
        default:
          if (jsObject != null) {
            if (displayLabel.isNotEmpty) {
              console.log(displayLabel.toJS, jsObject);
            } else {
              console.log(jsObject);
            }
            // Also log to IDE console for debugging
            _logToIdeConsole(object, level, displayLabel);
          } else {
            _fallbackJsonOutput(object, displayLabel, level);
          }
          break;
      }
    } catch (e) {
      // Final fallback to regular string output
      final fallbackMessage = label != null
          ? '$label: ${object.toString()}'
          : object.toString();
      output(fallbackMessage, level);
    }
  }

  static void _fallbackJsonOutput(
    Object? object,
    String displayLabel,
    String level,
  ) {
    try {
      // Format as JSON string with indentation
      final jsonString = const JsonEncoder.withIndent('  ').convert(object);
      final message = displayLabel.isNotEmpty
          ? '$displayLabel:\n$jsonString'
          : jsonString;
      output(message, level);
    } catch (e) {
      // Ultimate fallback
      final message = displayLabel.isNotEmpty
          ? '$displayLabel: ${object.toString()}'
          : object.toString();
      output(message, level);
    }
  }

  static JSAny? _convertToJS(Object? obj) {
    if (obj == null) return null;

    if (obj is Map) {
      // For maps, we'll create a JS object
      final jsObj = <String, JSAny?>{};
      obj.forEach((key, value) {
        jsObj[key.toString()] = _convertToJS(value);
      });
      return jsObj.jsify();
    } else if (obj is List) {
      // For lists, convert each element
      final jsList = obj.map((e) => _convertToJS(e)).toList();
      return jsList.jsify();
    } else if (obj is String) {
      return obj.toJS;
    } else if (obj is num) {
      return obj.toJS;
    } else if (obj is bool) {
      return obj.toJS;
    } else {
      // For other types, convert to string
      return obj.toString().toJS;
    }
  }

  static String _buildJsonPrefix({
    required String level,
    String? className,
    String? tag,
    String? functionName,
    bool includeTimestamp = false,
    String? dateTimeFormat,
  }) {
    final parts = <String>[];

    // Add timestamp first if provided
    if (includeTimestamp) {
      final timestamp = OutputFormatter.formatTimestamp(
        dateTimeFormat ?? 'HH:mm:ss',
      );
      parts.add('[$timestamp]');
    }

    // Only add className if it's provided and not empty
    if (className?.isNotEmpty ?? false) {
      parts.add('[$className]');
    }

    // Always add tag if provided and not empty
    if (tag?.isNotEmpty ?? false) {
      parts.add('[$tag]');
    }

    // Only add functionName if it's provided and not empty
    if (functionName?.isNotEmpty ?? false) {
      parts.add('[$functionName]');
    }

    parts.add('[$level]');

    return parts.isEmpty ? '' : '${parts.join('')} ';
  }

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
    try {
      // Create prefix for context (similar to regular log messages)
      final prefix = _buildJsonPrefix(
        level: level,
        className: className,
        tag: tag,
        functionName: functionName,
        includeTimestamp: includeTimestamp,
        dateTimeFormat: dateTimeFormat,
      );

      final displayLabel = label != null ? '$prefix$label' : prefix.trim();

      // Try to convert data to JS object for console.table
      JSAny? jsData;
      try {
        jsData = _convertToJS(data);
      } catch (e) {
        jsData = null;
      }

      // Filter columns if specified and data is suitable for console.table
      JSAny? jsColumns;
      if (columns != null && columns.isNotEmpty) {
        jsColumns = columns.jsify();
      }

      // Use console.table if we have suitable JS data
      if (jsData != null && _isSuitableForConsoleTable(data)) {
        if (displayLabel.isNotEmpty) {
          console.log(displayLabel.toJS);
        }

        if (jsColumns != null) {
          console.table(jsData, jsColumns);
        } else {
          console.table(jsData);
        }

        // Also log to IDE console for debugging
        _logTableToIdeConsole(data, columns, level, displayLabel);
      } else {
        // Fallback to formatted ASCII table
        _fallbackTableOutput(data, columns, displayLabel, level);
      }
    } catch (e) {
      // Final fallback to regular string output
      final fallbackMessage = label != null
          ? '$label: ${data.toString()}'
          : data.toString();
      output(fallbackMessage, level);
    }
  }

  static bool _isSuitableForConsoleTable(Object? data) {
    // console.table works well with arrays, objects, and mixed data
    if (data is List) {
      return data.isNotEmpty;
    }
    return data is Map;
  }

  static void _fallbackTableOutput(
    Object? data,
    List<String>? columns,
    String displayLabel,
    String level,
  ) {
    try {
      // Use our custom table formatter
      final tableData = TableFormatter.formatTable(data, columns);
      final tableString = TableFormatter.generateAsciiTable(tableData);

      final message = displayLabel.isNotEmpty
          ? '$displayLabel:\n$tableString'
          : tableString;
      output(message, level);
    } catch (e) {
      // Ultimate fallback
      final message = displayLabel.isNotEmpty
          ? '$displayLabel: ${data.toString()}'
          : data.toString();
      output(message, level);
    }
  }

  /// Log JSON object to IDE console using dart:developer log
  static void _logToIdeConsole(
    Object? object,
    String level,
    String displayLabel,
  ) {
    if (!kDebugMode) {
      return;
    }
    try {
      final jsonString = const JsonEncoder.withIndent('  ').convert(object);
      developer.log(jsonString, name: displayLabel, level: _getLogLevel(level));
    } catch (e) {
      // Fallback for non-JSON-serializable objects
      developer.log(
        object.toString(),
        name: displayLabel,
        level: _getLogLevel(level),
      );
    }
  }

  /// Log table data to IDE console using dart:developer log
  static void _logTableToIdeConsole(
    Object? data,
    List<String>? columns,
    String level,
    String displayLabel,
  ) {
    if (!kDebugMode) {
      return;
    }
    try {
      // Use our custom table formatter for IDE console
      final tableData = TableFormatter.formatTable(data, columns);
      final tableString = TableFormatter.generateAsciiTable(tableData);

      developer.log(
        '\n$tableString',
        name: displayLabel,
        level: _getLogLevel(level),
      );
    } catch (e) {
      // Fallback
      developer.log(
        data.toString(),
        name: displayLabel,
        level: _getLogLevel(level),
      );
    }
  }

  /// Convert log level string to dart:developer log level
  static int _getLogLevel(String level) {
    switch (level.toUpperCase()) {
      case 'ERROR':
        return 1000; // Severe
      case 'WARN':
        return 900; // Warning
      case 'INFO':
        return 800; // Info
      case 'DEBUG':
      default:
        return 700; // Fine
    }
  }
}

@JS('console')
external Console get console;

extension type Console(JSObject _) implements JSObject {
  external void log(JSAny? message, [JSAny? optionalParams]);

  external void info(JSAny? message, [JSAny? optionalParams]);

  external void warn(JSAny? message, [JSAny? optionalParams]);

  external void error(JSAny? message, [JSAny? optionalParams]);

  external void table(JSAny? data, [JSAny? columns]);
}
