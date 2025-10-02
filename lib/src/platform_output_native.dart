import 'dart:convert';
import 'output_formatter.dart';
import 'table_formatter.dart';

/// Native platform output implementation
class PlatformOutputImpl {
  // Maximum safe print length to avoid truncation
  static const int _maxPrintLength = 800;

  static void output(String message, String level) {
    _printLongString(message);
  }

  /// Prints long strings by splitting them into chunks to avoid truncation
  static void _printLongString(String message) {
    if (message.length <= _maxPrintLength) {
      // ignore: avoid_print
      print(message);
      return;
    }

    // Split by lines first to preserve formatting
    final lines = message.split('\n');
    final buffer = StringBuffer();
    
    for (final line in lines) {
      if (line.length <= _maxPrintLength) {
        // If adding this line would exceed the limit, flush the buffer
        if (buffer.length + line.length + 1 > _maxPrintLength) {
          if (buffer.isNotEmpty) {
            // ignore: avoid_print
            print(buffer.toString());
            buffer.clear();
          }
        }
        
        if (buffer.isNotEmpty) {
          buffer.writeln();
        }
        buffer.write(line);
      } else {
        // Line itself is too long, flush buffer and split the line
        if (buffer.isNotEmpty) {
          // ignore: avoid_print
          print(buffer.toString());
          buffer.clear();
        }
        
        // Split long line into chunks
        for (int i = 0; i < line.length; i += _maxPrintLength) {
          final end = (i + _maxPrintLength < line.length) 
              ? i + _maxPrintLength 
              : line.length;
          // ignore: avoid_print
          print(line.substring(i, end));
        }
      }
    }
    
    // Print any remaining content in buffer
    if (buffer.isNotEmpty) {
      // ignore: avoid_print
      print(buffer.toString());
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
      // Format JSON with proper indentation for IDE/terminal readability
      final jsonString = const JsonEncoder.withIndent('  ').convert(object);
      
      // Create a message with optional label
      final message = label != null ? '$label:\n$jsonString' : jsonString;
      
      // Use the existing formatter to maintain consistent styling
      final formattedMessage = OutputFormatter.formatMessage(
        level: level,
        message: message,
        enableColors: enableColors,
        className: className,
        tag: tag,
        functionName: functionName,
        locationUrl: locationUrl,
        includeTimestamp: includeTimestamp,
        dateTimeFormat: dateTimeFormat,
        messageTemplate: messageTemplate,
      );

      _printLongString(formattedMessage);
    } catch (e) {
      // Fallback for non-JSON-serializable objects
      final fallbackMessage = label != null 
          ? '$label: ${object.toString()}' 
          : object.toString();
      
      final formattedMessage = OutputFormatter.formatMessage(
        level: level,
        message: fallbackMessage,
        enableColors: enableColors,
        className: className,
        tag: tag,
        functionName: functionName,
        locationUrl: locationUrl,
        includeTimestamp: includeTimestamp,
        dateTimeFormat: dateTimeFormat,
        messageTemplate: messageTemplate,
      );

      _printLongString(formattedMessage);
    }
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
      // Format the data into table structure
      final tableData = TableFormatter.formatTable(data, columns);
      
      // Generate ASCII table
      final tableString = TableFormatter.generateAsciiTable(tableData, enableColors: enableColors);
      
      // Create message with optional label
      final message = label != null ? '$label:\n$tableString' : tableString;
      
      // Use the existing formatter to maintain consistent styling
      final formattedMessage = OutputFormatter.formatMessage(
        level: level,
        message: message,
        enableColors: enableColors,
        className: className,
        tag: tag,
        functionName: functionName,
        locationUrl: locationUrl,
        includeTimestamp: includeTimestamp,
        dateTimeFormat: dateTimeFormat,
        messageTemplate: messageTemplate,
      );

      _printLongString(formattedMessage);
    } catch (e) {
      // Fallback to regular string output
      final fallbackMessage = label != null 
          ? '$label: ${data.toString()}' 
          : data.toString();
      
      final formattedMessage = OutputFormatter.formatMessage(
        level: level,
        message: fallbackMessage,
        enableColors: enableColors,
        className: className,
        tag: tag,
        functionName: functionName,
        locationUrl: locationUrl,
        includeTimestamp: includeTimestamp,
        dateTimeFormat: dateTimeFormat,
        messageTemplate: messageTemplate,
      );

      _printLongString(formattedMessage);
    }
  }
}