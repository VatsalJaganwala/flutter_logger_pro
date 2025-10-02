/// Log levels for the logger
enum LogLevel {
  debug(700, 'DEBUG'),
  info(800, 'INFO'),
  warn(900, 'WARN'),
  error(1000, 'ERROR');

  const LogLevel(this.value, this.name);

  final int value;
  final String name;

  /// Get LogLevel from string name
  static LogLevel? fromString(String level) {
    switch (level.toUpperCase()) {
      case 'DEBUG':
        return LogLevel.debug;
      case 'INFO':
        return LogLevel.info;
      case 'WARN':
        return LogLevel.warn;
      case 'ERROR':
        return LogLevel.error;
      default:
        return null;
    }
  }
}