import 'ansi_colors.dart';

/// Handles formatting of log messages
class OutputFormatter {
  static const int _defaultTerminalWidth = 120;

  /// Format a log message with colors and location info
  static String formatMessage({
    required String level,
    required String message,
    required bool enableColors,
    String? className,
    String? tag,
    String? functionName,
    String? locationUrl,
    bool includeTimestamp = false,
    String? dateTimeFormat,
    String? messageTemplate,
  }) {
    // If a custom message template is provided, use template formatting
    if (messageTemplate != null && messageTemplate.isNotEmpty) {
      try {
        return _formatWithTemplate(
          template: messageTemplate,
          level: level,
          message: message,
          enableColors: enableColors,
          className: className,
          tag: tag,
          functionName: functionName,
          locationUrl: locationUrl,
          includeTimestamp: includeTimestamp,
          dateTimeFormat: dateTimeFormat,
        );
      } catch (e) {
        // If template formatting fails, fall back to default formatting
        // Continue with default formatting below
      }
    }

    // Default formatting logic (existing code)
    final coloredMessage = _getColoredMessage(level, message, enableColors);

    final timestamp = includeTimestamp
        ? _formatTimestamp(dateTimeFormat ?? 'HH:mm:ss')
        : null;

    final greyPrefix = _buildPrefix(
      className: className,
      tag: tag,
      functionName: functionName,
      level: level,
      timestamp: timestamp,
    );

    final mainContent = enableColors
        ? '${AnsiColors.grey}$greyPrefix${AnsiColors.reset}$coloredMessage'
        : '$greyPrefix$message';

    if (locationUrl != null) {
      // Extract just filename:line from the full URL for shorter display
      final shortLocation = locationUrl; //.split('/').last;

      // Calculate padding to align location at the right
      final contentLength = AnsiColors.stripAnsiCodes(
        '$greyPrefix$message',
      ).length;
      final padding = ' ' *
          (_defaultTerminalWidth - contentLength - shortLocation.length - 2)
              .clamp(1, _defaultTerminalWidth);

      return enableColors
          ? '$mainContent$padding${AnsiColors.grey}$shortLocation${AnsiColors.reset}'
          : '$greyPrefix$message$padding$shortLocation';
    } else {
      return mainContent;
    }
  }

  static String _buildPrefix({
    String? className,
    String? tag,
    String? functionName,
    required String level,
    String? timestamp,
  }) {
    final parts = <String>[];

    // Add timestamp first if provided
    if (timestamp?.isNotEmpty ?? false) {
      parts.add('[$timestamp]');
    }

    // Only add className if it's provided and not empty
    if (className?.isNotEmpty ?? false) {
      parts.add('[$className]');
    }

    // Always add tag if provided and not empty (tag is not controlled by display settings)
    if (tag?.isNotEmpty ?? false) {
      parts.add('[$tag]');
    }

    // Only add functionName if it's provided and not empty
    if (functionName?.isNotEmpty ?? false) {
      parts.add('[$functionName]');
    }

    parts.add('[$level] ');

    return parts.join('');
  }

  static String _getColoredMessage(
    String level,
    String message,
    bool enableColors,
  ) {
    if (!enableColors) return message;

    final color = AnsiColors.getColorForLevel(level);
    return '$color$message${AnsiColors.reset}';
  }

  /// Format the current timestamp using the provided format string
  ///
  /// Returns a formatted timestamp string. If the format is invalid,
  /// falls back to a simple timestamp format.
  static String formatTimestamp(String format) => _formatTimestamp(format);

  static String _formatTimestamp(String format) {
    try {
      final now = DateTime.now();
      return _formatDateTime(now, format);
    } catch (e) {
      // If formatting fails, fall back to simple timestamp
      final now = DateTime.now();
      return '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:'
          '${now.second.toString().padLeft(2, '0')}';
    }
  }

  /// Format a DateTime using a custom format string
  ///
  /// Supports basic format patterns:
  /// - yyyy: 4-digit year
  /// - MM: 2-digit month
  /// - dd: 2-digit day
  /// - HH: 2-digit hour (24-hour)
  /// - mm: 2-digit minute
  /// - ss: 2-digit second
  /// - SSS: 3-digit millisecond
  ///
  /// If the format string doesn't contain any recognized patterns,
  /// it's considered invalid and an exception is thrown.
  static String _formatDateTime(DateTime dateTime, String format) {
    String result = format;
    bool hasValidPattern = false;

    // Replace format patterns with actual values
    if (result.contains('yyyy')) {
      result = result.replaceAll('yyyy', dateTime.year.toString());
      hasValidPattern = true;
    }
    if (result.contains('MM')) {
      result = result.replaceAll(
        'MM',
        dateTime.month.toString().padLeft(2, '0'),
      );
      hasValidPattern = true;
    }
    if (result.contains('dd')) {
      result = result.replaceAll('dd', dateTime.day.toString().padLeft(2, '0'));
      hasValidPattern = true;
    }
    if (result.contains('HH')) {
      result = result.replaceAll(
        'HH',
        dateTime.hour.toString().padLeft(2, '0'),
      );
      hasValidPattern = true;
    }
    if (result.contains('mm')) {
      result = result.replaceAll(
        'mm',
        dateTime.minute.toString().padLeft(2, '0'),
      );
      hasValidPattern = true;
    }
    if (result.contains('ss')) {
      result = result.replaceAll(
        'ss',
        dateTime.second.toString().padLeft(2, '0'),
      );
      hasValidPattern = true;
    }
    if (result.contains('SSS')) {
      result = result.replaceAll(
        'SSS',
        dateTime.millisecond.toString().padLeft(3, '0'),
      );
      hasValidPattern = true;
    }

    // If no valid patterns were found, throw an exception to trigger fallback
    if (!hasValidPattern) {
      throw FormatException('Invalid date format: $format');
    }

    return result;
  }

  /// Format a log message using a custom template
  ///
  /// Supports the following placeholders:
  /// - {timestamp}: Current timestamp (formatted using dateTimeFormat)
  /// - {level}: Log level name
  /// - {message}: The actual log message
  /// - {className}: Class name (if available)
  /// - {tag}: Tag (if provided)
  /// - {functionName}: Function name (if available)
  /// - {location}: File location (if available)
  ///
  /// If the template is invalid or contains unrecognized placeholders,
  /// throws an exception to trigger fallback to default formatting.
  static String _formatWithTemplate({
    required String template,
    required String level,
    required String message,
    required bool enableColors,
    String? className,
    String? tag,
    String? functionName,
    String? locationUrl,
    bool includeTimestamp = false,
    String? dateTimeFormat,
  }) {
    String result = template;
    bool hasValidPlaceholder = false;

    // Replace timestamp placeholder
    if (result.contains('{timestamp}')) {
      if (includeTimestamp) {
        final timestamp = _formatTimestamp(dateTimeFormat ?? 'HH:mm:ss');
        result = result.replaceAll('{timestamp}', timestamp);
      } else {
        result = result.replaceAll('{timestamp}', '');
      }
      hasValidPlaceholder = true;
    }

    // Replace level placeholder
    if (result.contains('{level}')) {
      result = result.replaceAll('{level}', level);
      hasValidPlaceholder = true;
    }

    // Replace message placeholder
    if (result.contains('{message}')) {
      final coloredMessage = enableColors
          ? _getColoredMessage(level, message, enableColors)
          : message;
      result = result.replaceAll('{message}', coloredMessage);
      hasValidPlaceholder = true;
    }

    // Replace className placeholder
    if (result.contains('{className}')) {
      result = result.replaceAll('{className}', className ?? '');
      hasValidPlaceholder = true;
    }

    // Replace tag placeholder
    if (result.contains('{tag}')) {
      result = result.replaceAll('{tag}', tag ?? '');
      hasValidPlaceholder = true;
    }

    // Replace functionName placeholder
    if (result.contains('{functionName}')) {
      result = result.replaceAll('{functionName}', functionName ?? '');
      hasValidPlaceholder = true;
    }

    // Replace location placeholder
    if (result.contains('{location}')) {
      if (locationUrl != null) {
        // Extract just filename:line from the full URL for shorter display
        final shortLocation = locationUrl.split('/').last;
        result = result.replaceAll('{location}', shortLocation);
      } else {
        result = result.replaceAll('{location}', '');
      }
      hasValidPlaceholder = true;
    }

    // If no valid placeholders were found, consider the template invalid
    if (!hasValidPlaceholder) {
      throw FormatException(
        'Invalid message template: no recognized placeholders found',
      );
    }

    return result;
  }
}
