import 'log_level.dart';
import 'logger_options.dart';
import 'output_formatter.dart';
import 'platform_output.dart';
import 'stack_trace_parser.dart';

/// A flexible logging utility that provides colored output and caller information
class Logger {
  final String? className;
  final String? tag;
  bool enableColors;
  bool enableLogging;
  final bool showClassName;
  bool showFunctionName;
  bool showLocation;

  /// Creates a new Logger instance
  ///
  /// [tag] - Optional tag to include in log messages
  /// [enableColors] - Whether to use ANSI colors in output (uses global default if not specified)
  /// [enableLogging] - Whether logging is enabled for this instance (uses global default if not specified)
  /// [showFunctionName] - Whether to show function names in output (uses global default if not specified)
  /// [showLocation] - Whether to show file location in output (uses global default if not specified)
  Logger({
    this.tag,
    bool? enableColors,
    bool? enableLogging,
    // bool? showClassName, // Hidden for future release
    bool? showFunctionName,
    bool? showLocation,
  })  : className = StackTraceParser.getCallerClass(),
        enableColors =
            enableColors ?? LoggerOptions.instance.effectiveEnableColors,
        enableLogging =
            enableLogging ?? LoggerOptions.instance.effectiveEnableLogging,
        showClassName = LoggerOptions
            .instance.effectiveShowClassName, // Always use global (disabled)
        showFunctionName = showFunctionName ??
            LoggerOptions.instance.effectiveShowFunctionName,
        showLocation =
            showLocation ?? LoggerOptions.instance.effectiveShowLocation;

  /// Log an info message
  void info(String message) => _log(LogLevel.info, message);

  /// Log a warning message
  void warn(String message) => _log(LogLevel.warn, message);

  /// Log an error message
  void error(String message) => _log(LogLevel.error, message);

  /// Log a debug message
  void debug(String message) => _log(LogLevel.debug, message);

  // Short method aliases for convenience
  /// Short alias for info()
  void i(String message) => info(message);

  /// Short alias for warn()
  void w(String message) => warn(message);

  /// Short alias for error()
  void e(String message) => error(message);

  /// Short alias for debug()
  void d(String message) => debug(message);

  /// Log a JSON object (Map, List, or any JSON-serializable object)
  ///
  /// For IDE/native: Formats with proper indentation for readability
  /// For browser: Uses native console methods for collapsible/expandable display
  ///
  /// [object] - The object to log as JSON (Map, List, or any JSON-serializable object)
  /// [level] - The log level to use (defaults to info)
  /// [label] - Optional label to prefix the JSON output
  void json(Object? object, {LogLevel level = LogLevel.info, String? label}) =>
      _logJson(level, object, label);

  /// Convenience method to log JSON at info level
  void jsonInfo(Object? object, {String? label}) =>
      json(object, level: LogLevel.info, label: label);

  /// Convenience method to log JSON at debug level
  void jsonDebug(Object? object, {String? label}) =>
      json(object, level: LogLevel.debug, label: label);

  /// Convenience method to log JSON at warn level
  void jsonWarn(Object? object, {String? label}) =>
      json(object, level: LogLevel.warn, label: label);

  /// Convenience method to log JSON at error level
  void jsonError(Object? object, {String? label}) =>
      json(object, level: LogLevel.error, label: label);

  /// Log data in a table format (similar to console.table in JavaScript)
  ///
  /// Supports various data structures:
  /// - Array of objects: Each object becomes a row with keys as column headers
  /// - Single object: Keys become row indices, values in a "Values" column
  /// - Array of arrays: Each inner array is a row with numeric column headers
  /// - Mixed types: Display values directly in table cells
  ///
  /// [data] - The data to display in table format
  /// [columns] - Optional list of column names to display (filters columns)
  /// [level] - The log level to use (defaults to info)
  /// [label] - Optional label to prefix the table output
  void table(
    Object? data, {
    List<String>? columns,
    LogLevel level = LogLevel.info,
    String? label,
  }) =>
      _logTable(level, data, columns, label);

  /// Convenience method to log table at info level
  void tableInfo(Object? data, {List<String>? columns, String? label}) =>
      table(data, columns: columns, level: LogLevel.info, label: label);

  /// Convenience method to log table at debug level
  void tableDebug(Object? data, {List<String>? columns, String? label}) =>
      table(data, columns: columns, level: LogLevel.debug, label: label);

  /// Convenience method to log table at warn level
  void tableWarn(Object? data, {List<String>? columns, String? label}) =>
      table(data, columns: columns, level: LogLevel.warn, label: label);

  /// Convenience method to log table at error level
  void tableError(Object? data, {List<String>? columns, String? label}) =>
      table(data, columns: columns, level: LogLevel.error, label: label);

  // Local logger configuration methods

  /// Configure multiple local logger settings at once
  ///
  /// Updates the settings for this specific logger instance without affecting
  /// global settings or other logger instances.
  ///
  /// [enableColors] - Whether to use ANSI colors in output for this logger
  /// [enableLogging] - Whether logging is enabled for this logger instance
  /// [showFunctionName] - Whether to show function names in output for this logger
  /// [showLocation] - Whether to show file location in output for this logger
  void configure({
    bool? enableColors,
    bool? enableLogging,
    bool? showFunctionName,
    bool? showLocation,
  }) {
    if (enableColors != null) this.enableColors = enableColors;
    if (enableLogging != null) this.enableLogging = enableLogging;
    if (showFunctionName != null) this.showFunctionName = showFunctionName;
    if (showLocation != null) this.showLocation = showLocation;
  }

  /// Reset this logger's local settings to use global defaults
  ///
  /// This will cause the logger to inherit all settings from LoggerOptions
  /// global configuration.
  void reset() {
    enableColors = LoggerOptions.instance.effectiveEnableColors;
    enableLogging = LoggerOptions.instance.effectiveEnableLogging;
    showFunctionName = LoggerOptions.instance.effectiveShowFunctionName;
    showLocation = LoggerOptions.instance.effectiveShowLocation;
  }

  // Individual property setters for local logger configuration

  /// Set whether to use ANSI colors in output for this logger
  void setEnableColors(bool enable) {
    enableColors = enable;
  }

  /// Set whether logging is enabled for this logger instance
  void setEnableLogging(bool enable) {
    enableLogging = enable;
  }

  /// Set whether to show function names in output for this logger
  void setShowFunctionName(bool show) {
    showFunctionName = show;
  }

  /// Set whether to show file location in output for this logger
  void setShowLocation(bool show) {
    showLocation = show;
  }

  /// Internal logging method that handles formatting and output
  void _log(LogLevel level, String message) {
    // PERFORMANCE OPTIMIZATION: Check logging enabled first (fastest check)
    if (!enableLogging) return;

    // PERFORMANCE OPTIMIZATION: Cache the minimum log level to avoid repeated singleton access
    final minLevel = LoggerOptions.instance.effectiveMinLogLevel;
    if (level.value < minLevel.value) return;

    // PERFORMANCE OPTIMIZATION: Only get caller info if we actually need it
    String? locationUrl;
    String? functionName;

    if (showFunctionName || showLocation) {
      final callerInfo = StackTraceParser.getPathAndCallerFunction();
      locationUrl = showLocation ? callerInfo?.$1 : null;
      functionName = showFunctionName ? callerInfo?.$2 : null;
    }

    // PERFORMANCE OPTIMIZATION: Cache LoggerOptions values to minimize singleton access
    final options = LoggerOptions.instance;
    final includeTimestamp = options.effectiveIncludeTimestamp;
    final dateTimeFormat = options.effectiveDateTimeFormat;
    final messageTemplate = options.effectiveMessageTemplate;

    final formattedMessage = OutputFormatter.formatMessage(
      level: level.name,
      message: message,
      enableColors: enableColors,
      className: showClassName ? className : null,
      tag: tag,
      functionName: functionName,
      locationUrl: locationUrl,
      includeTimestamp: includeTimestamp,
      dateTimeFormat: dateTimeFormat,
      messageTemplate: messageTemplate,
    );

    PlatformOutput.output(formattedMessage, level.name);
  }

  /// Internal JSON logging method that handles formatting and output
  void _logJson(LogLevel level, Object? object, String? label) {
    // PERFORMANCE OPTIMIZATION: Check logging enabled first (fastest check)
    if (!enableLogging) return;

    // PERFORMANCE OPTIMIZATION: Cache the minimum log level to avoid repeated singleton access
    final minLevel = LoggerOptions.instance.effectiveMinLogLevel;
    if (level.value < minLevel.value) return;

    // PERFORMANCE OPTIMIZATION: Only get caller info if we actually need it
    String? locationUrl;
    String? functionName;

    if (showFunctionName || showLocation) {
      final callerInfo = StackTraceParser.getPathAndCallerFunction();
      locationUrl = showLocation ? callerInfo?.$1 : null;
      functionName = showFunctionName ? callerInfo?.$2 : null;
    }

    // PERFORMANCE OPTIMIZATION: Cache LoggerOptions values to minimize singleton access
    final options = LoggerOptions.instance;
    final includeTimestamp = options.effectiveIncludeTimestamp;
    final dateTimeFormat = options.effectiveDateTimeFormat;
    final messageTemplate = options.effectiveMessageTemplate;

    // Use platform-specific JSON output for better browser console experience
    PlatformOutput.outputJson(
      object: object,
      level: level.name,
      label: label,
      enableColors: enableColors,
      className: showClassName ? className : null,
      tag: tag,
      functionName: functionName,
      locationUrl: locationUrl,
      includeTimestamp: includeTimestamp,
      dateTimeFormat: dateTimeFormat,
      messageTemplate: messageTemplate,
    );
  }

  /// Internal table logging method that handles formatting and output
  void _logTable(
    LogLevel level,
    Object? data,
    List<String>? columns,
    String? label,
  ) {
    // PERFORMANCE OPTIMIZATION: Check logging enabled first (fastest check)
    if (!enableLogging) return;

    // PERFORMANCE OPTIMIZATION: Cache the minimum log level to avoid repeated singleton access
    final minLevel = LoggerOptions.instance.effectiveMinLogLevel;
    if (level.value < minLevel.value) return;

    // PERFORMANCE OPTIMIZATION: Only get caller info if we actually need it
    String? locationUrl;
    String? functionName;

    if (showFunctionName || showLocation) {
      final callerInfo = StackTraceParser.getPathAndCallerFunction();
      locationUrl = showLocation ? callerInfo?.$1 : null;
      functionName = showFunctionName ? callerInfo?.$2 : null;
    }

    // PERFORMANCE OPTIMIZATION: Cache LoggerOptions values to minimize singleton access
    final options = LoggerOptions.instance;
    final includeTimestamp = options.effectiveIncludeTimestamp;
    final dateTimeFormat = options.effectiveDateTimeFormat;
    final messageTemplate = options.effectiveMessageTemplate;

    // Use platform-specific table output
    PlatformOutput.outputTable(
      data: data,
      columns: columns,
      level: level.name,
      label: label,
      enableColors: enableColors,
      className: showClassName ? className : null,
      tag: tag,
      functionName: functionName,
      locationUrl: locationUrl,
      includeTimestamp: includeTimestamp,
      dateTimeFormat: dateTimeFormat,
      messageTemplate: messageTemplate,
    );
  }
}
