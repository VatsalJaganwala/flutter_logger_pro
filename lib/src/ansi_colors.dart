/// ANSI color codes for terminal output
class AnsiColors {
  static const String reset = '\x1B[0m';
  static const String grey = '\x1B[90m';
  static const String red = '\x1B[31m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String cyan = '\x1B[36m';

  /// Get color for log level
  static String getColorForLevel(String level) {
    switch (level) {
      case 'ERROR':
        return red;
      case 'WARN':
        return yellow;
      case 'INFO':
        return blue;
      case 'DEBUG':
        return cyan;
      default:
        return reset;
    }
  }

  /// Strip ANSI codes from text
  static String stripAnsiCodes(String text) {
    return text.replaceAll(RegExp(r'\x1B\[[0-9;]*m'), '');
  }
}