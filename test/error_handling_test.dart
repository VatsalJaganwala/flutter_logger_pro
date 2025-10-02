import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_logger_pro/src/logger_options.dart';
import 'package:flutter_logger_pro/src/log_level.dart';

void main() {
  group('LoggerOptions Error Handling and Validation Tests', () {
    setUp(() {
      // Reset LoggerOptions before each test
      LoggerOptions.instance.reset();
    });

    test('LoggerOptions handles all validation scenarios correctly', () {
      final options = LoggerOptions.instance;
      
      // Test valid configurations work
      expect(() => options.configure(
        enableLogging: true,
        enableColors: false,
        minLogLevel: LogLevel.warn,
        dateTimeFormat: 'yyyy-MM-dd HH:mm:ss',
        messageTemplate: '{timestamp} {level}: {message}',
      ), returnsNormally);
      
      expect(options.effectiveEnableLogging, isTrue);
      expect(options.effectiveEnableColors, isFalse);
      expect(options.effectiveMinLogLevel, equals(LogLevel.warn));
      expect(options.effectiveDateTimeFormat, equals('yyyy-MM-dd HH:mm:ss'));
      expect(options.effectiveMessageTemplate, equals('{timestamp} {level}: {message}'));
    });

    test('LoggerOptions gracefully handles invalid dateTimeFormat', () {
      final options = LoggerOptions.instance;
      
      // Set a valid format first
      options.configure(dateTimeFormat: 'HH:mm:ss');
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
      
      // Try invalid formats - should use default with warning
      options.configure(dateTimeFormat: '');
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
      
      options.configure(dateTimeFormat: 'invalid@#\$');
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
      
      options.configure(dateTimeFormat: 'xyz123');
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
    });

    test('LoggerOptions gracefully handles invalid messageTemplate', () {
      final options = LoggerOptions.instance;
      
      // Valid template should work
      options.configure(messageTemplate: '{level}: {message}');
      expect(options.effectiveMessageTemplate, equals('{level}: {message}'));
      
      // Invalid templates should still be set but with warnings
      options.configure(messageTemplate: '');
      expect(options.effectiveMessageTemplate, equals(''));
      
      options.configure(messageTemplate: '{invalidPlaceholder}');
      expect(options.effectiveMessageTemplate, equals('{invalidPlaceholder}'));
    });

    test('LoggerOptions validation preserves valid settings during errors', () {
      final options = LoggerOptions.instance;
      
      // Set up valid configuration
      options.configure(
        enableLogging: true,
        enableColors: true,
        minLogLevel: LogLevel.info,
        dateTimeFormat: 'HH:mm:ss',
        messageTemplate: '{level}: {message}',
      );
      
      // Try to set invalid dateTimeFormat
      options.configure(dateTimeFormat: 'invalid');
      
      // Other settings should be preserved
      expect(options.effectiveEnableLogging, isTrue);
      expect(options.effectiveEnableColors, isTrue);
      expect(options.effectiveMinLogLevel, equals(LogLevel.info));
      expect(options.effectiveMessageTemplate, equals('{level}: {message}'));
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss')); // Default due to invalid
    });

    test('LoggerConfigurationException works correctly', () {
      const exception = LoggerConfigurationException('Test error message');
      
      expect(exception.message, equals('Test error message'));
      expect(exception.toString(), equals('LoggerConfigurationException: Test error message'));
      expect(exception, isA<Exception>());
    });

    test('LoggerOptions reset clears all configurations including invalid ones', () {
      final options = LoggerOptions.instance;
      
      // Set some configurations including invalid ones
      options.configure(
        enableLogging: false,
        dateTimeFormat: 'invalid',
        messageTemplate: '{invalidPlaceholder}',
      );
      
      // Reset should clear everything
      options.reset();
      
      // All should return to defaults
      expect(options.effectiveEnableLogging, isTrue);
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
      expect(options.effectiveMessageTemplate, isNull);
      expect(options.dateTimeFormat, isNull);
      expect(options.messageTemplate, isNull);
    });
  });
}