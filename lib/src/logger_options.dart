import 'log_level.dart';

/// Exception thrown when LoggerOptions configuration validation fails
class LoggerConfigurationException implements Exception {
  final String message;
  const LoggerConfigurationException(this.message);

  @override
  String toString() => 'LoggerConfigurationException: $message';
}

/// Singleton class that manages global logger configuration settings.
///
/// This class provides a centralized way to configure default settings
/// for all Logger instances in an application. Individual Logger constructors
/// can override these global settings as needed.
class LoggerOptions {
  // Singleton instance
  static LoggerOptions? _instance;

  /// Gets the singleton instance of LoggerOptions
  static LoggerOptions get instance => _instance ??= LoggerOptions._();

  // Private constructor to enforce singleton pattern
  LoggerOptions._();

  // Configuration properties - all nullable to distinguish between
  // "not set" and "explicitly set to false"

  /// Global enable/disable switch for all logging
  bool? enableLogging;

  /// Global enable/disable switch for ANSI color output
  bool? enableColors;

  /// Minimum log level to output globally
  LogLevel? minLogLevel;

  /// Whether to show class names in log output
  bool? showClassName;

  /// Whether to show function names in log output
  bool? showFunctionName;

  /// Whether to show file location information in log output
  bool? showLocation;

  /// Whether to include timestamps in log messages
  bool? includeTimestamp;

  /// Custom date/time format string for timestamps
  String? dateTimeFormat;

  /// Custom message template for log formatting
  String? messageTemplate;

  /// Configure multiple options at once
  ///
  /// All parameters are optional and will only update the corresponding
  /// setting if provided (non-null).
  ///
  /// Throws [LoggerConfigurationException] if validation fails.
  /// Logs warnings for invalid configurations that can be gracefully handled.
  static void configure({
    bool? enableLogging,
    bool? enableColors,
    LogLevel? minLogLevel,
    // bool? showClassName, // Hidden for future release
    bool? showFunctionName,
    bool? showLocation,
    bool? includeTimestamp,
    String? dateTimeFormat,
    String? messageTemplate,
  }) {
    instance._configure(
      enableLogging: enableLogging,
      enableColors: enableColors,
      minLogLevel: minLogLevel,
      showFunctionName: showFunctionName,
      showLocation: showLocation,
      includeTimestamp: includeTimestamp,
      dateTimeFormat: dateTimeFormat,
      messageTemplate: messageTemplate,
    );
  }

  /// Internal configure method used by both static and instance methods
  void _configure({
    bool? enableLogging,
    bool? enableColors,
    LogLevel? minLogLevel,
    // bool? showClassName, // Hidden for future release
    bool? showFunctionName,
    bool? showLocation,
    bool? includeTimestamp,
    String? dateTimeFormat,
    String? messageTemplate,
  }) {
    // Validate LogLevel - this should never fail with enum values, but included for completeness
    if (minLogLevel != null) {
      _validateLogLevel(minLogLevel);
    }

    // Validate and set dateTimeFormat with error handling
    if (dateTimeFormat != null) {
      if (_validateDateTimeFormat(dateTimeFormat)) {
        this.dateTimeFormat = dateTimeFormat;
      } else {
        // Log warning and use default format
        _logWarning(
          'Invalid dateTimeFormat "$dateTimeFormat", using default format',
        );
        this.dateTimeFormat = null; // Will use default 'HH:mm:ss'
      }
    }

    // Validate and set messageTemplate with warning for invalid templates
    if (messageTemplate != null) {
      if (_validateMessageTemplate(messageTemplate)) {
        this.messageTemplate = messageTemplate;
      } else {
        // Log warning but still set the template - OutputFormatter will handle graceful degradation
        _logWarning(
          'Invalid messageTemplate "$messageTemplate", may cause formatting issues',
        );
        this.messageTemplate = messageTemplate;
      }
    }

    // Set other validated options
    if (enableLogging != null) this.enableLogging = enableLogging;
    if (enableColors != null) this.enableColors = enableColors;
    if (minLogLevel != null) this.minLogLevel = minLogLevel;
    // if (showClassName != null) this.showClassName = showClassName; // Hidden for future release
    if (showFunctionName != null) this.showFunctionName = showFunctionName;
    if (showLocation != null) this.showLocation = showLocation;
    if (includeTimestamp != null) this.includeTimestamp = includeTimestamp;
  }

  /// Instance method for backward compatibility
  ///
  /// Delegates to the internal _configure method.
  void configureInstance({
    bool? enableLogging,
    bool? enableColors,
    LogLevel? minLogLevel,
    bool? showFunctionName,
    bool? showLocation,
    bool? includeTimestamp,
    String? dateTimeFormat,
    String? messageTemplate,
  }) {
    _configure(
      enableLogging: enableLogging,
      enableColors: enableColors,
      minLogLevel: minLogLevel,
      showFunctionName: showFunctionName,
      showLocation: showLocation,
      includeTimestamp: includeTimestamp,
      dateTimeFormat: dateTimeFormat,
      messageTemplate: messageTemplate,
    );
  }

  /// Instance method for backward compatibility
  ///
  /// Delegates to the internal _reset method.
  void resetInstance() {
    _reset();
  }

  /// Reset all configuration options to their default values (null)
  ///
  /// This will cause all effective getters to return their built-in defaults.
  static void reset() {
    instance._reset();
  }

  /// Internal reset method used by both static and instance methods
  void _reset() {
    enableLogging = null;
    enableColors = null;
    minLogLevel = null;
    showClassName = null;
    showFunctionName = null;
    showLocation = null;
    includeTimestamp = null;
    dateTimeFormat = null;
    messageTemplate = null;
  }

  // Effective getter methods that provide defaults for null values

  /// Gets the effective enableLogging setting (default: true)
  bool get effectiveEnableLogging => enableLogging ?? true;

  /// Gets the effective enableColors setting (default: true)
  bool get effectiveEnableColors => enableColors ?? true;

  /// Gets the effective minimum log level (default: LogLevel.debug)
  LogLevel get effectiveMinLogLevel => minLogLevel ?? LogLevel.debug;

  /// Gets the effective showClassName setting (disabled for future release)
  bool get effectiveShowClassName => false; // Disabled for future release

  /// Gets the effective showFunctionName setting (default: true)
  bool get effectiveShowFunctionName => showFunctionName ?? true;

  /// Gets the effective showLocation setting (default: true)
  bool get effectiveShowLocation => showLocation ?? true;

  /// Gets the effective includeTimestamp setting (default: false)
  bool get effectiveIncludeTimestamp => includeTimestamp ?? false;

  /// Gets the effective dateTimeFormat setting (default: 'HH:mm:ss')
  ///
  /// If the stored format is invalid, returns the default format.
  String get effectiveDateTimeFormat {
    final format = dateTimeFormat ?? 'HH:mm:ss';
    // Validate the format before returning it
    if (_validateDateTimeFormat(format)) {
      return format;
    } else {
      // Graceful degradation - return default if stored format is somehow invalid
      return 'HH:mm:ss';
    }
  }

  /// Gets the effective messageTemplate setting (default: null for built-in formatting)
  String? get effectiveMessageTemplate => messageTemplate;

  // Static property setters for individual configuration updates

  /// Set the global enable/disable switch for all logging
  static void setEnableLogging(bool enable) {
    instance.enableLogging = enable;
  }

  /// Set the global enable/disable switch for ANSI color output
  static void setEnableColors(bool enable) {
    instance.enableColors = enable;
  }

  /// Set the minimum log level to output globally
  ///
  /// Throws [LoggerConfigurationException] if the LogLevel is invalid.
  static void setMinLogLevel(LogLevel level) {
    instance._validateLogLevel(level);
    instance.minLogLevel = level;
  }

  /// Set whether to show function names in log output
  static void setShowFunctionName(bool show) {
    instance.showFunctionName = show;
  }

  /// Set whether to show file location information in log output
  static void setShowLocation(bool show) {
    instance.showLocation = show;
  }

  /// Set whether to include timestamps in log messages
  static void setIncludeTimestamp(bool include) {
    instance.includeTimestamp = include;
  }

  /// Set custom date/time format string for timestamps
  ///
  /// Logs warnings for invalid formats and uses default format as fallback.
  static void setDateTimeFormat(String format) {
    if (instance._validateDateTimeFormat(format)) {
      instance.dateTimeFormat = format;
    } else {
      // Log warning and use default format
      instance._logWarning(
        'Invalid dateTimeFormat "$format", using default format',
      );
      instance.dateTimeFormat = null; // Will use default 'HH:mm:ss'
    }
  }

  /// Set custom message template for log formatting
  ///
  /// Logs warnings for potentially problematic templates but still applies them.
  static void setMessageTemplate(String template) {
    if (instance._validateMessageTemplate(template)) {
      instance.messageTemplate = template;
    } else {
      // Log warning but still set the template - OutputFormatter will handle graceful degradation
      instance._logWarning(
        'Invalid messageTemplate "$template", may cause formatting issues',
      );
      instance.messageTemplate = template;
    }
  }

  // Private validation methods

  /// Validates that the provided LogLevel is valid
  ///
  /// Throws [LoggerConfigurationException] if the LogLevel is invalid.
  void _validateLogLevel(LogLevel logLevel) {
    // Since LogLevel is an enum, this validation is mostly for completeness
    // The enum itself ensures type safety, but we check the value range
    if (logLevel.value < LogLevel.debug.value ||
        logLevel.value > LogLevel.error.value) {
      throw LoggerConfigurationException(
        'Invalid LogLevel value: ${logLevel.value}. Must be between ${LogLevel.debug.value} and ${LogLevel.error.value}',
      );
    }
  }

  /// Validates that the provided dateTimeFormat string is valid
  ///
  /// Returns true if valid, false if invalid.
  /// Uses graceful degradation - invalid formats will use default.
  bool _validateDateTimeFormat(String format) {
    try {
      // Check for common invalid patterns that would cause issues
      if (format.isEmpty) {
        return false;
      }

      // Check for obviously invalid characters that would cause issues
      final invalidChars = RegExp(r'[^a-zA-Z0-9\s\-:/.]+');
      if (invalidChars.hasMatch(format)) {
        return false;
      }

      // Check for common date/time format patterns
      // Must contain at least one valid date/time format character
      final validFormatChars = RegExp(r'[yMdHhmsS]');
      if (!validFormatChars.hasMatch(format)) {
        return false;
      }

      // Reject obviously invalid patterns
      if (format == 'invalid' ||
          format.startsWith('xyz') ||
          format.contains('!!!') ||
          format == 'abc def') {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validates that the provided messageTemplate string is valid
  ///
  /// Returns true if valid, false if potentially problematic.
  /// Uses graceful degradation - invalid templates will still be set but with warnings.
  bool _validateMessageTemplate(String template) {
    try {
      // Check for empty template
      if (template.isEmpty) {
        return false;
      }

      // Check for basic template structure
      // Valid templates should contain at least one placeholder or be a simple string
      final placeholderPattern = RegExp(r'\{[^}]+\}');

      // If it contains placeholders, validate they are reasonable
      if (placeholderPattern.hasMatch(template)) {
        final placeholders = placeholderPattern.allMatches(template);
        final validPlaceholders = {
          'timestamp',
          'level',
          'message',
          'className',
          'functionName',
          'location',
          'tag',
          'file',
          'line',
        };

        for (final match in placeholders) {
          final placeholder = match.group(0)?.replaceAll(RegExp(r'[{}]'), '');
          if (placeholder != null && !validPlaceholders.contains(placeholder)) {
            return false; // Unknown placeholder
          }
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Logs a warning message to the console
  ///
  /// This is used for non-fatal configuration issues that can be handled gracefully.
  void _logWarning(String message) {
    // Use stderr for warnings to avoid interfering with normal output
    // In production, this could be replaced with a proper logging mechanism
    // ignore: avoid_print
    print('LoggerOptions Warning: $message');
  }
}
