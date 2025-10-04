import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

void main() {
  group('Logger Tests', () {
    test('Logger can be instantiated', () {
      final logger = Logger();
      expect(logger, isNotNull);
      expect(logger.enableColors, isTrue);
    });

    test('Logger can be instantiated with custom tag', () {
      final logger = Logger(tag: 'TEST');
      expect(logger.tag, equals('TEST'));
    });

    test('Logger can be instantiated with colors disabled', () {
      final logger = Logger(enableColors: false);
      expect(logger.enableColors, isFalse);
    });

    test('Logger methods can be called without throwing', () {
      final logger = Logger(tag: 'TEST');

      expect(() => logger.debug('Debug message'), returnsNormally);
      expect(() => logger.info('Info message'), returnsNormally);
      expect(() => logger.warn('Warning message'), returnsNormally);
      expect(() => logger.error('Error message'), returnsNormally);
    });

    test('Logger JSON methods can be called without throwing', () {
      final logger = Logger(tag: 'JSON_TEST');

      final testMap = {
        'key': 'value',
        'number': 42,
        'nested': {'inner': true},
      };
      final testList = [
        1,
        'two',
        {'three': 3},
        [4, 5],
      ];

      expect(() => logger.json(testMap), returnsNormally);
      expect(() => logger.json(testList), returnsNormally);
      expect(() => logger.json(testMap, label: 'Test Map'), returnsNormally);
      expect(() => logger.json(null), returnsNormally);

      expect(() => logger.jsonInfo(testMap), returnsNormally);
      expect(() => logger.jsonDebug(testList), returnsNormally);
      expect(() => logger.jsonWarn(testMap, label: 'Warning'), returnsNormally);
      expect(() => logger.jsonError(testList, label: 'Error'), returnsNormally);
    });
  });

  group('LogLevel Tests', () {
    test('LogLevel enum has correct values', () {
      expect(LogLevel.debug.value, equals(700));
      expect(LogLevel.info.value, equals(800));
      expect(LogLevel.warn.value, equals(900));
      expect(LogLevel.error.value, equals(1000));
    });

    test('LogLevel fromString works correctly', () {
      expect(LogLevel.fromString('DEBUG'), equals(LogLevel.debug));
      expect(LogLevel.fromString('info'), equals(LogLevel.info));
      expect(LogLevel.fromString('WARN'), equals(LogLevel.warn));
      expect(LogLevel.fromString('error'), equals(LogLevel.error));
      expect(LogLevel.fromString('invalid'), isNull);
    });
  });

  group('LoggerOptions Singleton Tests', () {
    setUp(() {
      // Reset LoggerOptions before each test
      LoggerOptions.instance.reset();
    });

    test('LoggerOptions is a singleton', () {
      final instance1 = LoggerOptions.instance;
      final instance2 = LoggerOptions.instance;
      expect(identical(instance1, instance2), isTrue);
    });

    test('LoggerOptions singleton behavior is consistent', () {
      final instance1 = LoggerOptions.instance;
      final instance2 = LoggerOptions.instance;
      final instance3 = LoggerOptions.instance;

      expect(identical(instance1, instance2), isTrue);
      expect(identical(instance2, instance3), isTrue);
      expect(identical(instance1, instance3), isTrue);
    });

    test('LoggerOptions singleton state persists across access', () {
      final instance1 = LoggerOptions.instance;
      instance1.configure(enableLogging: false);

      final instance2 = LoggerOptions.instance;
      expect(instance2.effectiveEnableLogging, isFalse);

      instance2.configure(enableColors: false);

      final instance3 = LoggerOptions.instance;
      expect(instance3.effectiveEnableLogging, isFalse);
      expect(instance3.effectiveEnableColors, isFalse);
    });

    test('LoggerOptions has correct default values', () {
      final options = LoggerOptions.instance;
      expect(options.effectiveEnableLogging, isTrue);
      expect(options.effectiveEnableColors, isTrue);
      expect(options.effectiveMinLogLevel, equals(LogLevel.debug));
      expect(
        options.effectiveShowClassName,
        isFalse,
      ); // Disabled for future release
      expect(options.effectiveShowFunctionName, isTrue);
      expect(options.effectiveShowLocation, isTrue);
      expect(options.effectiveIncludeTimestamp, isFalse);
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
      expect(options.effectiveMessageTemplate, isNull);
    });

    test('LoggerOptions effective getters provide correct defaults', () {
      final options = LoggerOptions.instance;

      // All raw properties should be null initially
      expect(options.enableLogging, isNull);
      expect(options.enableColors, isNull);
      expect(options.minLogLevel, isNull);
      expect(options.showClassName, isNull);
      expect(options.showFunctionName, isNull);
      expect(options.showLocation, isNull);
      expect(options.includeTimestamp, isNull);
      expect(options.dateTimeFormat, isNull);
      expect(options.messageTemplate, isNull);

      // Effective getters should provide defaults
      expect(options.effectiveEnableLogging, isTrue);
      expect(options.effectiveEnableColors, isTrue);
      expect(options.effectiveMinLogLevel, equals(LogLevel.debug));
      expect(
        options.effectiveShowClassName,
        isFalse,
      ); // Disabled for future release
      expect(options.effectiveShowFunctionName, isTrue);
      expect(options.effectiveShowLocation, isTrue);
      expect(options.effectiveIncludeTimestamp, isFalse);
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
      expect(options.effectiveMessageTemplate, isNull);
    });

    test('LoggerOptions configure method works', () {
      final options = LoggerOptions.instance;
      options.configure(enableLogging: false);
      expect(options.effectiveEnableLogging, isFalse);
    });

    test('LoggerOptions configure method handles all parameters', () {
      final options = LoggerOptions.instance;

      options.configure(
        enableLogging: false,
        enableColors: false,
        minLogLevel: LogLevel.error,
        // showClassName: false, // Hidden for future release
        showFunctionName: false,
        showLocation: false,
        includeTimestamp: true,
        dateTimeFormat: 'yyyy-MM-dd HH:mm:ss',
        messageTemplate: '{level}: {message}',
      );

      expect(options.effectiveEnableLogging, isFalse);
      expect(options.effectiveEnableColors, isFalse);
      expect(options.effectiveMinLogLevel, equals(LogLevel.error));
      expect(options.effectiveShowClassName, isFalse); // Always false now
      expect(options.effectiveShowFunctionName, isFalse);
      expect(options.effectiveShowLocation, isFalse);
      expect(options.effectiveIncludeTimestamp, isTrue);
      expect(options.effectiveDateTimeFormat, equals('yyyy-MM-dd HH:mm:ss'));
      expect(options.effectiveMessageTemplate, equals('{level}: {message}'));
    });

    test('LoggerOptions configure method handles partial updates', () {
      final options = LoggerOptions.instance;

      // Initial configuration
      options.configure(
        enableLogging: false,
        enableColors: false,
        minLogLevel: LogLevel.error,
      );

      expect(options.effectiveEnableLogging, isFalse);
      expect(options.effectiveEnableColors, isFalse);
      expect(options.effectiveMinLogLevel, equals(LogLevel.error));
      expect(options.effectiveShowClassName, isFalse); // Always false now

      // Partial update - should only change specified values
      options.configure(
        enableLogging: true,
        // showClassName: false, // Hidden for future release
      );

      expect(options.effectiveEnableLogging, isTrue); // Changed
      expect(options.effectiveEnableColors, isFalse); // Unchanged
      expect(options.effectiveMinLogLevel, equals(LogLevel.error)); // Unchanged
      expect(options.effectiveShowClassName, isFalse); // Always false now
    });

    test(
      'LoggerOptions configure method handles null parameters correctly',
      () {
        final options = LoggerOptions.instance;

        // Set some values
        options.configure(enableLogging: false, enableColors: false);

        expect(options.effectiveEnableLogging, isFalse);
        expect(options.effectiveEnableColors, isFalse);

        // Call configure with null values - should not change existing settings
        options.configure(
          enableLogging: null,
          enableColors: null,
          minLogLevel: LogLevel.warn, // This should change
        );

        expect(options.effectiveEnableLogging, isFalse); // Unchanged
        expect(options.effectiveEnableColors, isFalse); // Unchanged
        expect(options.effectiveMinLogLevel, equals(LogLevel.warn)); // Changed
      },
    );

    test('LoggerOptions reset method works', () {
      final options = LoggerOptions.instance;
      options.configure(enableLogging: false);
      expect(options.effectiveEnableLogging, isFalse);

      options.reset();
      expect(options.effectiveEnableLogging, isTrue);
    });

    test('LoggerOptions reset method restores all defaults', () {
      final options = LoggerOptions.instance;

      // Configure all settings to non-default values
      options.configure(
        enableLogging: false,
        enableColors: false,
        minLogLevel: LogLevel.error,
        // showClassName: false, // Hidden for future release
        showFunctionName: false,
        showLocation: false,
        includeTimestamp: true,
        dateTimeFormat: 'yyyy-MM-dd HH:mm:ss',
        messageTemplate: '{level}: {message}',
      );

      // Verify non-default values
      expect(options.effectiveEnableLogging, isFalse);
      expect(options.effectiveEnableColors, isFalse);
      expect(options.effectiveMinLogLevel, equals(LogLevel.error));
      expect(options.effectiveShowClassName, isFalse); // Always false now
      expect(options.effectiveShowFunctionName, isFalse);
      expect(options.effectiveShowLocation, isFalse);
      expect(options.effectiveIncludeTimestamp, isTrue);
      expect(options.effectiveDateTimeFormat, equals('yyyy-MM-dd HH:mm:ss'));
      expect(options.effectiveMessageTemplate, equals('{level}: {message}'));

      // Reset and verify defaults
      options.reset();

      expect(options.effectiveEnableLogging, isTrue);
      expect(options.effectiveEnableColors, isTrue);
      expect(options.effectiveMinLogLevel, equals(LogLevel.debug));
      expect(options.effectiveShowClassName, isFalse); // Always false now
      expect(options.effectiveShowFunctionName, isTrue);
      expect(options.effectiveShowLocation, isTrue);
      expect(options.effectiveIncludeTimestamp, isFalse);
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
      expect(options.effectiveMessageTemplate, isNull);

      // Verify raw properties are null after reset
      expect(options.enableLogging, isNull);
      expect(options.enableColors, isNull);
      expect(options.minLogLevel, isNull);
      expect(options.showClassName, isNull);
      expect(options.showFunctionName, isNull);
      expect(options.showLocation, isNull);
      expect(options.includeTimestamp, isNull);
      expect(options.dateTimeFormat, isNull);
      expect(options.messageTemplate, isNull);
    });

    test('LoggerOptions minLogLevel can be configured', () {
      final options = LoggerOptions.instance;

      options.configure(minLogLevel: LogLevel.warn);
      expect(options.effectiveMinLogLevel, equals(LogLevel.warn));
      expect(options.minLogLevel, equals(LogLevel.warn));

      options.configure(minLogLevel: LogLevel.error);
      expect(options.effectiveMinLogLevel, equals(LogLevel.error));
      expect(options.minLogLevel, equals(LogLevel.error));
    });

    test('LoggerOptions minLogLevel defaults to debug when not set', () {
      final options = LoggerOptions.instance;
      expect(options.effectiveMinLogLevel, equals(LogLevel.debug));
      expect(options.minLogLevel, isNull); // Not explicitly set
    });

    test('LoggerOptions reset restores minLogLevel to default', () {
      final options = LoggerOptions.instance;

      options.configure(minLogLevel: LogLevel.error);
      expect(options.effectiveMinLogLevel, equals(LogLevel.error));

      options.reset();
      expect(options.effectiveMinLogLevel, equals(LogLevel.debug));
      expect(options.minLogLevel, isNull);
    });
  });

  group('Configuration Precedence Tests', () {
    setUp(() {
      // Reset LoggerOptions before each test
      LoggerOptions.instance.reset();
    });

    test('Logger uses global enableLogging setting by default', () {
      LoggerOptions.instance.configure(enableLogging: false);
      final logger = Logger(tag: 'TEST');
      expect(logger.enableLogging, isFalse);
    });

    test('Logger constructor parameter overrides global enableLogging', () {
      LoggerOptions.instance.configure(enableLogging: false);
      final logger = Logger(tag: 'TEST', enableLogging: true);
      expect(logger.enableLogging, isTrue);
    });

    test('Logger uses global enableColors setting by default', () {
      LoggerOptions.instance.configure(enableColors: false);
      final logger = Logger(tag: 'TEST');
      expect(logger.enableColors, isFalse);
    });

    test('Logger constructor parameter overrides global enableColors', () {
      LoggerOptions.instance.configure(enableColors: false);
      final logger = Logger(tag: 'TEST', enableColors: true);
      expect(logger.enableColors, isTrue);
    });

    test('Logger uses global display control settings by default', () {
      LoggerOptions.instance.configure(
        // showClassName: false, // Hidden for future release
        showFunctionName: false,
        showLocation: false,
      );

      final logger = Logger(tag: 'TEST');
      expect(logger.showClassName, isFalse); // Always false now
      expect(logger.showFunctionName, isFalse);
      expect(logger.showLocation, isFalse);
    });

    test(
      'Logger constructor parameters override global display control settings',
      () {
        LoggerOptions.instance.configure(
          // showClassName: false, // Hidden for future release
          showFunctionName: false,
          showLocation: false,
        );

        final logger = Logger(
          tag: 'TEST',
          // showClassName: true, // Hidden for future release
          showFunctionName: true,
          showLocation: true,
        );

        expect(logger.showClassName, isFalse); // Always false now
        expect(logger.showFunctionName, isTrue);
        expect(logger.showLocation, isTrue);
      },
    );

    test(
      'Logger constructor parameters override global settings completely',
      () {
        // Set all global settings to non-default values
        LoggerOptions.instance.configure(
          enableLogging: false,
          enableColors: false,
          // showClassName: false, // Hidden for future release
          showFunctionName: false,
          showLocation: false,
        );

        // Create logger with all overrides
        final logger = Logger(
          tag: 'OVERRIDE_ALL',
          enableLogging: true,
          enableColors: true,
          // showClassName: true, // Hidden for future release
          showFunctionName: true,
          showLocation: true,
        );

        // Logger should use constructor values, not global
        expect(logger.enableLogging, isTrue);
        expect(logger.enableColors, isTrue);
        expect(logger.showClassName, isFalse); // Always false now
        expect(logger.showFunctionName, isTrue);
        expect(logger.showLocation, isTrue);
      },
    );

    test(
      'Logger uses global settings when constructor parameters not provided',
      () {
        // Set global settings
        LoggerOptions.instance.configure(
          enableLogging: false,
          enableColors: false,
          // showClassName: false, // Hidden for future release
          showFunctionName: false,
          showLocation: false,
        );

        // Create logger without overrides
        final logger = Logger(tag: 'USE_GLOBAL');

        // Logger should use global values
        expect(logger.enableLogging, isFalse);
        expect(logger.enableColors, isFalse);
        expect(logger.showClassName, isFalse); // Always false now
        expect(logger.showFunctionName, isFalse);
        expect(logger.showLocation, isFalse);
      },
    );

    test('Logger uses mixed global and constructor settings correctly', () {
      // Set some global settings
      LoggerOptions.instance.configure(
        enableLogging: false,
        enableColors: false,
        // showClassName: false, // Hidden for future release
      );

      // Create logger with partial overrides
      final logger = Logger(
        tag: 'MIXED',
        enableLogging: true, // Override
        // showClassName: true, // Hidden for future release
        // enableColors, showFunctionName, showLocation use global/default
      );

      expect(logger.enableLogging, isTrue); // Overridden
      expect(logger.enableColors, isFalse); // Global
      expect(logger.showClassName, isFalse); // Always false now
      expect(logger.showFunctionName, isTrue); // Default (global not set)
      expect(logger.showLocation, isTrue); // Default (global not set)
    });

    test('Configuration precedence is immutable after logger creation', () {
      LoggerOptions.instance.configure(enableLogging: false);

      final logger = Logger(tag: 'IMMUTABLE', enableLogging: true);
      expect(logger.enableLogging, isTrue);

      // Change global setting after logger creation
      LoggerOptions.instance.configure(enableLogging: true);

      // Logger should retain its original configuration
      expect(logger.enableLogging, isTrue);

      // But new loggers should use new global setting
      final newLogger = Logger(tag: 'NEW');
      expect(newLogger.enableLogging, isTrue);
    });
  });

  group('Logger Integration Tests', () {
    setUp(() {
      // Reset LoggerOptions before each test
      LoggerOptions.instance.reset();
    });

    test('Logger with enableLogging false does not throw when logging', () {
      final logger = Logger(tag: 'TEST', enableLogging: false);

      expect(() => logger.debug('Debug message'), returnsNormally);
      expect(() => logger.info('Info message'), returnsNormally);
      expect(() => logger.warn('Warning message'), returnsNormally);
      expect(() => logger.error('Error message'), returnsNormally);
    });

    test('Logger respects global enableLogging false setting', () {
      LoggerOptions.instance.configure(enableLogging: false);
      final logger = Logger(tag: 'TEST');

      expect(() => logger.debug('Debug message'), returnsNormally);
      expect(() => logger.info('Info message'), returnsNormally);
      expect(() => logger.warn('Warning message'), returnsNormally);
      expect(() => logger.error('Error message'), returnsNormally);
    });

    test('Logger respects global minimum log level during runtime', () {
      final logger = Logger(tag: 'RUNTIME_TEST');

      // Start with debug level - all should work
      LoggerOptions.instance.configure(minLogLevel: LogLevel.debug);
      expect(() => logger.debug('Debug message'), returnsNormally);
      expect(() => logger.info('Info message'), returnsNormally);
      expect(() => logger.warn('Warning message'), returnsNormally);
      expect(() => logger.error('Error message'), returnsNormally);

      // Change to warn level - debug and info should be filtered
      LoggerOptions.instance.configure(minLogLevel: LogLevel.warn);
      expect(() => logger.debug('Debug message'), returnsNormally);
      expect(() => logger.info('Info message'), returnsNormally);
      expect(() => logger.warn('Warning message'), returnsNormally);
      expect(() => logger.error('Error message'), returnsNormally);

      // Change to error level - only error should work
      LoggerOptions.instance.configure(minLogLevel: LogLevel.error);
      expect(() => logger.debug('Debug message'), returnsNormally);
      expect(() => logger.info('Info message'), returnsNormally);
      expect(() => logger.warn('Warning message'), returnsNormally);
      expect(() => logger.error('Error message'), returnsNormally);
    });

    test('Logger respects global enable/disable during runtime', () {
      final logger = Logger(tag: 'ENABLE_TEST');

      // Start with logging enabled
      LoggerOptions.instance.configure(enableLogging: true);
      expect(() => logger.info('Should work'), returnsNormally);

      // Disable logging globally
      LoggerOptions.instance.configure(enableLogging: false);
      expect(() => logger.info('Should be disabled'), returnsNormally);

      // Re-enable logging
      LoggerOptions.instance.configure(enableLogging: true);
      expect(() => logger.info('Should work again'), returnsNormally);
    });

    test('Logger with constructor override ignores global runtime changes', () {
      // Create logger with explicit enableLogging=true
      final logger = Logger(tag: 'OVERRIDE_TEST', enableLogging: true);

      // Should work initially
      expect(() => logger.info('Should work'), returnsNormally);

      // Disable logging globally - should not affect this logger
      LoggerOptions.instance.configure(enableLogging: false);
      expect(() => logger.info('Should still work'), returnsNormally);

      // Create new logger without override - should be disabled
      final newLogger = Logger(tag: 'NEW_LOGGER');
      expect(newLogger.enableLogging, isFalse);
    });

    test(
      'Multiple loggers with different configurations work independently',
      () {
        LoggerOptions.instance.configure(
          enableLogging: false,
          enableColors: false,
          minLogLevel: LogLevel.warn,
        );

        final disabledLogger = Logger(
          tag: 'DISABLED',
        ); // Uses global (disabled)
        final enabledLogger = Logger(
          tag: 'ENABLED',
          enableLogging: true,
        ); // Override
        final colorfulLogger = Logger(
          tag: 'COLORFUL',
          enableColors: true,
        ); // Partial override

        expect(disabledLogger.enableLogging, isFalse);
        expect(disabledLogger.enableColors, isFalse);

        expect(enabledLogger.enableLogging, isTrue);
        expect(enabledLogger.enableColors, isFalse); // Uses global

        expect(colorfulLogger.enableLogging, isFalse); // Uses global
        expect(colorfulLogger.enableColors, isTrue);

        // All should execute without throwing
        expect(() => disabledLogger.error('Disabled logger'), returnsNormally);
        expect(() => enabledLogger.error('Enabled logger'), returnsNormally);
        expect(() => colorfulLogger.error('Colorful logger'), returnsNormally);
      },
    );

    test('Logger integration with all LoggerOptions features', () {
      LoggerOptions.instance.configure(
        enableLogging: true,
        enableColors: false,
        minLogLevel: LogLevel.info,
        // showClassName: true, // Hidden for future release
        showFunctionName: false,
        showLocation: true,
        includeTimestamp: true,
        dateTimeFormat: 'HH:mm:ss.SSS',
        messageTemplate: '[{timestamp}] {level} ({className}): {message}',
      );

      final logger = Logger(tag: 'INTEGRATION_TEST');

      // Test all log levels with comprehensive configuration
      expect(() => logger.debug('Debug - should be filtered'), returnsNormally);
      expect(() => logger.info('Info message'), returnsNormally);
      expect(() => logger.warn('Warning message'), returnsNormally);
      expect(() => logger.error('Error message'), returnsNormally);

      // Verify logger properties match global settings
      expect(logger.enableLogging, isTrue);
      expect(logger.enableColors, isFalse);
      expect(logger.showClassName, isFalse); // Always false now
      expect(logger.showFunctionName, isFalse);
      expect(logger.showLocation, isTrue);
    });
  });

  group('Edge Cases and Error Handling Tests', () {
    setUp(() {
      // Reset LoggerOptions before each test
      LoggerOptions.instance.reset();
    });

    test('LoggerOptions handles multiple configure calls correctly', () {
      final options = LoggerOptions.instance;

      // Multiple calls should accumulate/override settings
      options.configure(enableLogging: false);
      expect(options.effectiveEnableLogging, isFalse);

      options.configure(enableColors: false);
      expect(options.effectiveEnableLogging, isFalse); // Should remain
      expect(options.effectiveEnableColors, isFalse);

      options.configure(enableLogging: true); // Override previous
      expect(options.effectiveEnableLogging, isTrue);
      expect(options.effectiveEnableColors, isFalse); // Should remain
    });

    test('LoggerOptions handles empty configure calls', () {
      final options = LoggerOptions.instance;

      // Set some initial values
      options.configure(enableLogging: false);
      expect(options.effectiveEnableLogging, isFalse);

      // Empty configure call should not change anything
      options.configure();
      expect(options.effectiveEnableLogging, isFalse);
    });

    test('Logger handles null tag gracefully', () {
      LoggerOptions.instance.configure(enableLogging: true);

      final logger = Logger(); // No tag provided
      expect(logger.tag, isNull);

      expect(() => logger.debug('Debug without tag'), returnsNormally);
      expect(() => logger.info('Info without tag'), returnsNormally);
      expect(() => logger.warn('Warning without tag'), returnsNormally);
      expect(() => logger.error('Error without tag'), returnsNormally);
    });

    test('Logger handles extreme log level configurations', () {
      final logger = Logger(tag: 'EXTREME_TEST');

      // Test with highest level (error)
      LoggerOptions.instance.configure(minLogLevel: LogLevel.error);
      expect(() => logger.debug('Should be filtered'), returnsNormally);
      expect(() => logger.info('Should be filtered'), returnsNormally);
      expect(() => logger.warn('Should be filtered'), returnsNormally);
      expect(() => logger.error('Should work'), returnsNormally);

      // Test with lowest level (debug)
      LoggerOptions.instance.configure(minLogLevel: LogLevel.debug);
      expect(() => logger.debug('Should work'), returnsNormally);
      expect(() => logger.info('Should work'), returnsNormally);
      expect(() => logger.warn('Should work'), returnsNormally);
      expect(() => logger.error('Should work'), returnsNormally);
    });

    test('Logger handles disabled logging with all other features enabled', () {
      LoggerOptions.instance.configure(
        enableLogging: false, // Disabled
        enableColors: true,
        minLogLevel: LogLevel.debug,
        // showClassName: true, // Hidden for future release
        showFunctionName: true,
        showLocation: true,
        includeTimestamp: true,
        messageTemplate: '[{timestamp}] {level}: {message}',
      );

      final logger = Logger(tag: 'DISABLED_TEST');

      // All should execute without throwing despite complex configuration
      expect(() => logger.debug('Disabled debug'), returnsNormally);
      expect(() => logger.info('Disabled info'), returnsNormally);
      expect(() => logger.warn('Disabled warning'), returnsNormally);
      expect(() => logger.error('Disabled error'), returnsNormally);
    });

    test('Logger creation with all possible constructor combinations', () {
      LoggerOptions.instance.configure(
        enableLogging: false,
        enableColors: false,
        // showClassName: false, // Hidden for future release
        showFunctionName: false,
        showLocation: false,
      );

      // Test all possible constructor parameter combinations
      final logger1 = Logger();
      final logger2 = Logger(tag: 'TEST');
      final logger3 = Logger(enableLogging: true);
      final logger4 = Logger(enableColors: true);
      final logger5 = Logger(
          /* showClassName: true, */
          ); // Hidden for future release
      final logger6 = Logger(showFunctionName: true);
      final logger7 = Logger(showLocation: true);
      final logger8 = Logger(
        tag: 'FULL',
        enableLogging: true,
        enableColors: true,
        // showClassName: true, // Hidden for future release
        showFunctionName: true,
        showLocation: true,
      );

      // All should be created successfully
      final loggers = [
        logger1,
        logger2,
        logger3,
        logger4,
        logger5,
        logger6,
        logger7,
        logger8,
      ];
      for (final logger in loggers) {
        expect(logger, isNotNull);
        expect(() => logger.info('Test message'), returnsNormally);
      }
    });
  });

  group('Backward Compatibility Tests', () {
    setUp(() {
      // Reset LoggerOptions before each test
      LoggerOptions.instance.reset();
    });

    test('Existing Logger usage works without LoggerOptions configuration', () {
      // Don't configure LoggerOptions at all - test backward compatibility

      final logger1 = Logger();
      final logger2 = Logger(tag: 'TEST');
      final logger3 = Logger(enableColors: false);
      final logger4 = Logger(tag: 'COLORED', enableColors: true);

      // All should work with default behavior
      expect(() => logger1.debug('Default logger'), returnsNormally);
      expect(() => logger2.info('Tagged logger'), returnsNormally);
      expect(() => logger3.warn('No colors'), returnsNormally);
      expect(() => logger4.error('With colors'), returnsNormally);

      // Properties should have expected values
      expect(logger1.enableColors, isTrue); // Default
      expect(logger1.enableLogging, isTrue); // Default
      expect(logger2.tag, equals('TEST'));
      expect(logger3.enableColors, isFalse); // Explicit
      expect(logger4.enableColors, isTrue); // Explicit
    });

    test('Logger constructor parameters work same as before LoggerOptions', () {
      // Test that explicit constructor parameters work exactly as before

      final logger = Logger(
        tag: 'LEGACY',
        enableColors: false,
        enableLogging: true,
      );

      expect(logger.tag, equals('LEGACY'));
      expect(logger.enableColors, isFalse);
      expect(logger.enableLogging, isTrue);

      expect(() => logger.debug('Legacy usage'), returnsNormally);
      expect(() => logger.info('Legacy usage'), returnsNormally);
      expect(() => logger.warn('Legacy usage'), returnsNormally);
      expect(() => logger.error('Legacy usage'), returnsNormally);
    });
  });

  group('LoggerOptions Validation and Error Handling Tests', () {
    setUp(() {
      // Reset LoggerOptions before each test
      LoggerOptions.instance.reset();
    });

    test('LoggerOptions validates LogLevel values correctly', () {
      final options = LoggerOptions.instance;

      // Valid LogLevel values should work
      expect(
        () => options.configure(minLogLevel: LogLevel.debug),
        returnsNormally,
      );
      expect(
        () => options.configure(minLogLevel: LogLevel.info),
        returnsNormally,
      );
      expect(
        () => options.configure(minLogLevel: LogLevel.warn),
        returnsNormally,
      );
      expect(
        () => options.configure(minLogLevel: LogLevel.error),
        returnsNormally,
      );

      // All enum values should be valid
      for (final level in LogLevel.values) {
        expect(() => options.configure(minLogLevel: level), returnsNormally);
      }
    });

    test('LoggerOptions handles invalid dateTimeFormat gracefully', () {
      final options = LoggerOptions.instance;

      // Valid formats should work
      expect(
        () => options.configure(dateTimeFormat: 'HH:mm:ss'),
        returnsNormally,
      );
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));

      expect(
        () => options.configure(dateTimeFormat: 'yyyy-MM-dd HH:mm:ss'),
        returnsNormally,
      );
      expect(options.effectiveDateTimeFormat, equals('yyyy-MM-dd HH:mm:ss'));

      // Invalid formats should use default with warning
      expect(() => options.configure(dateTimeFormat: ''), returnsNormally);
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss')); // Default

      expect(
        () => options.configure(dateTimeFormat: 'invalid@#\$'),
        returnsNormally,
      );
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss')); // Default
    });

    test('LoggerOptions validates messageTemplate and provides warnings', () {
      final options = LoggerOptions.instance;

      // Valid templates should work
      expect(
        () => options.configure(messageTemplate: '{level}: {message}'),
        returnsNormally,
      );
      expect(options.effectiveMessageTemplate, equals('{level}: {message}'));

      expect(
        () => options.configure(
          messageTemplate: '[{timestamp}] {level} - {message}',
        ),
        returnsNormally,
      );
      expect(
        options.effectiveMessageTemplate,
        equals('[{timestamp}] {level} - {message}'),
      );

      expect(
        () => options.configure(messageTemplate: 'Simple message: {message}'),
        returnsNormally,
      );
      expect(
        options.effectiveMessageTemplate,
        equals('Simple message: {message}'),
      );

      // Invalid templates should still be set but with warnings
      expect(() => options.configure(messageTemplate: ''), returnsNormally);
      expect(
        options.effectiveMessageTemplate,
        equals(''),
      ); // Still set despite being invalid

      expect(
        () => options.configure(messageTemplate: '{invalidPlaceholder}'),
        returnsNormally,
      );
      expect(
        options.effectiveMessageTemplate,
        equals('{invalidPlaceholder}'),
      ); // Still set with warning
    });

    test('LoggerOptions handles valid messageTemplate placeholders', () {
      final options = LoggerOptions.instance;

      final validTemplates = [
        '{timestamp}',
        '{level}',
        '{message}',
        '{className}',
        '{functionName}',
        '{location}',
        '{tag}',
        '{file}',
        '{line}',
        '[{timestamp}] {level}: {message}',
        '{level} - {className}.{functionName}: {message}',
        '{timestamp} | {level} | {tag} | {message}',
      ];

      for (final template in validTemplates) {
        expect(
          () => options.configure(messageTemplate: template),
          returnsNormally,
        );
        expect(options.effectiveMessageTemplate, equals(template));
      }
    });

    test('LoggerOptions graceful degradation for effectiveDateTimeFormat', () {
      final options = LoggerOptions.instance;

      // Set a valid format first
      options.configure(dateTimeFormat: 'yyyy-MM-dd');
      expect(options.effectiveDateTimeFormat, equals('yyyy-MM-dd'));

      // Manually set an invalid format (simulating corruption or edge case)
      options.dateTimeFormat = 'invalid@#\$';

      // effectiveDateTimeFormat should return default due to graceful degradation
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
    });

    test(
      'LoggerOptions validation does not throw exceptions for user errors',
      () {
        final options = LoggerOptions.instance;

        // All these should complete without throwing exceptions
        expect(() => options.configure(dateTimeFormat: ''), returnsNormally);
        expect(() => options.configure(dateTimeFormat: null), returnsNormally);
        expect(
          () => options.configure(dateTimeFormat: 'invalid'),
          returnsNormally,
        );
        expect(() => options.configure(messageTemplate: ''), returnsNormally);
        expect(() => options.configure(messageTemplate: null), returnsNormally);
        expect(
          () => options.configure(messageTemplate: '{invalid}'),
          returnsNormally,
        );
      },
    );

    test(
      'LoggerOptions validation preserves valid settings when invalid ones are provided',
      () {
        final options = LoggerOptions.instance;

        // Set valid configuration
        options.configure(
          enableLogging: true,
          dateTimeFormat: 'HH:mm:ss',
          messageTemplate: '{level}: {message}',
        );

        expect(options.effectiveEnableLogging, isTrue);
        expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
        expect(options.effectiveMessageTemplate, equals('{level}: {message}'));

        // Try to set invalid dateTimeFormat - should not affect other settings
        options.configure(dateTimeFormat: 'invalid');

        expect(options.effectiveEnableLogging, isTrue); // Unchanged
        expect(
          options.effectiveDateTimeFormat,
          equals('HH:mm:ss'),
        ); // Reverted to default
        expect(
          options.effectiveMessageTemplate,
          equals('{level}: {message}'),
        ); // Unchanged
      },
    );

    test('LoggerOptions handles mixed valid and invalid configuration', () {
      final options = LoggerOptions.instance;

      // Configure with mix of valid and invalid values
      options.configure(
        enableLogging: true, // Valid
        enableColors: false, // Valid
        dateTimeFormat: 'invalid', // Invalid - should use default
        messageTemplate: '{level}: {message}', // Valid
        includeTimestamp: true, // Valid
      );

      expect(options.effectiveEnableLogging, isTrue);
      expect(options.effectiveEnableColors, isFalse);
      expect(
        options.effectiveDateTimeFormat,
        equals('HH:mm:ss'),
      ); // Default due to invalid input
      expect(options.effectiveMessageTemplate, equals('{level}: {message}'));
      expect(options.effectiveIncludeTimestamp, isTrue);
    });

    test('LoggerOptions reset clears invalid configurations', () {
      final options = LoggerOptions.instance;

      // Set some invalid configurations
      options.configure(
        dateTimeFormat: 'invalid',
        messageTemplate: '{invalidPlaceholder}',
      );

      // Reset should clear everything
      options.reset();

      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
      expect(options.effectiveMessageTemplate, isNull);
      expect(options.dateTimeFormat, isNull);
      expect(options.messageTemplate, isNull);
    });

    test('LoggerOptions validation works with null values', () {
      final options = LoggerOptions.instance;

      // Null values should not trigger validation
      expect(
        () => options.configure(
          dateTimeFormat: null,
          messageTemplate: null,
          minLogLevel: null,
        ),
        returnsNormally,
      );

      // Should use defaults
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
      expect(options.effectiveMessageTemplate, isNull);
      expect(options.effectiveMinLogLevel, equals(LogLevel.debug));
    });

    test('LoggerOptions validation edge cases', () {
      final options = LoggerOptions.instance;

      // Test various edge cases
      expect(
        () => options.configure(dateTimeFormat: ' '),
        returnsNormally,
      ); // Whitespace
      expect(
        () => options.configure(dateTimeFormat: '\t\n'),
        returnsNormally,
      ); // Tabs/newlines
      expect(
        () => options.configure(messageTemplate: ' '),
        returnsNormally,
      ); // Whitespace
      expect(
        () => options.configure(messageTemplate: '{}'),
        returnsNormally,
      ); // Empty placeholder

      // All should handle gracefully without throwing
    });

    test('LoggerConfigurationException is properly defined', () {
      const exception = LoggerConfigurationException('Test message');
      expect(exception.message, equals('Test message'));
      expect(
        exception.toString(),
        equals('LoggerConfigurationException: Test message'),
      );
      expect(exception, isA<Exception>());
    });

    test('LoggerOptions validation methods work independently', () {
      final options = LoggerOptions.instance;

      // Test that validation methods can be called independently
      // (These are private methods, so we test them through configure)

      // Valid dateTimeFormat
      options.configure(dateTimeFormat: 'HH:mm:ss');
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));

      // Valid messageTemplate
      options.configure(messageTemplate: '{level}: {message}');
      expect(options.effectiveMessageTemplate, equals('{level}: {message}'));

      // Invalid dateTimeFormat should not affect messageTemplate
      options.configure(dateTimeFormat: 'invalid');
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss')); // Default
      expect(
        options.effectiveMessageTemplate,
        equals('{level}: {message}'),
      ); // Unchanged
    });

    test('LoggerOptions handles complex dateTimeFormat validation', () {
      final options = LoggerOptions.instance;

      // Valid complex formats
      final validFormats = [
        'yyyy-MM-dd HH:mm:ss',
        'HH:mm:ss.SSS',
        'dd/MM/yyyy',
        'yyyy-MM-dd',
        'HH:mm',
        'yyyy/MM/dd HH:mm:ss',
        'dd-MM-yyyy HH:mm',
      ];

      for (final format in validFormats) {
        options.configure(dateTimeFormat: format);
        expect(
          options.effectiveDateTimeFormat,
          equals(format),
          reason: 'Format "$format" should be valid',
        );
      }

      // Invalid formats that should use default
      final invalidFormats = [
        '',
        'invalid@#\$',
        'xyz123',
        '!!!',
        'abc def',
        '{invalid}',
      ];

      for (final format in invalidFormats) {
        options.configure(dateTimeFormat: format);
        expect(
          options.effectiveDateTimeFormat,
          equals('HH:mm:ss'),
          reason: 'Invalid format "$format" should use default',
        );
      }
    });

    test('LoggerOptions handles complex messageTemplate validation', () {
      final options = LoggerOptions.instance;

      // Valid templates with various placeholder combinations
      final validTemplates = [
        '{timestamp} {level}: {message}',
        '[{timestamp}] {level} - {className}.{functionName}: {message}',
        '{level} | {tag} | {message}',
        '{timestamp} {level} {file}:{line} {message}',
        'Simple message without placeholders',
        '{message}', // Just message
        '{level}', // Just level
        'Prefix {message} suffix',
        '{timestamp} - {location} - {message}',
      ];

      for (final template in validTemplates) {
        options.configure(messageTemplate: template);
        expect(
          options.effectiveMessageTemplate,
          equals(template),
          reason: 'Template "$template" should be valid',
        );
      }

      // Invalid templates that should still be set but with warnings
      final invalidTemplates = [
        '',
        '{invalidPlaceholder}',
        '{unknown}',
        '{badFormat',
        'unclosed{placeholder',
        '{nested{placeholder}}',
      ];

      for (final template in invalidTemplates) {
        options.configure(messageTemplate: template);
        expect(
          options.effectiveMessageTemplate,
          equals(template),
          reason:
              'Invalid template "$template" should still be set with warning',
        );
      }
    });

    test('LoggerOptions graceful degradation works in all scenarios', () {
      final options = LoggerOptions.instance;

      // Test graceful degradation for dateTimeFormat
      options.configure(dateTimeFormat: 'yyyy-MM-dd');
      expect(options.effectiveDateTimeFormat, equals('yyyy-MM-dd'));

      // Simulate corruption by directly setting invalid format
      options.dateTimeFormat = 'corrupted@#\$';
      expect(
        options.effectiveDateTimeFormat,
        equals('HH:mm:ss'),
        reason: 'Corrupted format should gracefully degrade to default',
      );

      // Test that other settings are not affected by validation failures
      options.configure(
        enableLogging: true,
        enableColors: false,
        dateTimeFormat: 'invalid',
        messageTemplate: '{level}: {message}',
        includeTimestamp: true,
      );

      expect(options.effectiveEnableLogging, isTrue);
      expect(options.effectiveEnableColors, isFalse);
      expect(options.effectiveDateTimeFormat, equals('HH:mm:ss')); // Degraded
      expect(options.effectiveMessageTemplate, equals('{level}: {message}'));
      expect(options.effectiveIncludeTimestamp, isTrue);
    });

    test(
      'LoggerOptions validation preserves application state during errors',
      () {
        final options = LoggerOptions.instance;

        // Set up a valid configuration
        options.configure(
          enableLogging: true,
          enableColors: true,
          minLogLevel: LogLevel.info,
          // showClassName: false, // Hidden for future release
          dateTimeFormat: 'HH:mm:ss',
          messageTemplate: '{level}: {message}',
        );

        // Verify initial state
        expect(options.effectiveEnableLogging, isTrue);
        expect(options.effectiveEnableColors, isTrue);
        expect(options.effectiveMinLogLevel, equals(LogLevel.info));
        expect(options.effectiveShowClassName, isFalse); // Always false now
        expect(options.effectiveDateTimeFormat, equals('HH:mm:ss'));
        expect(options.effectiveMessageTemplate, equals('{level}: {message}'));

        // Try to configure with some invalid values
        options.configure(
          dateTimeFormat: 'invalid@#\$',
          messageTemplate: '{invalidPlaceholder}',
          // Don't change other valid settings
        );

        // Valid settings should be preserved
        expect(options.effectiveEnableLogging, isTrue);
        expect(options.effectiveEnableColors, isTrue);
        expect(options.effectiveMinLogLevel, equals(LogLevel.info));
        expect(options.effectiveShowClassName, isFalse);

        // Invalid settings should use defaults/warnings
        expect(
          options.effectiveDateTimeFormat,
          equals('HH:mm:ss'),
        ); // Default due to invalid
        expect(
          options.effectiveMessageTemplate,
          equals('{invalidPlaceholder}'),
        ); // Set with warning
      },
    );
  });

  group('Backward Compatibility Tests', () {
    setUp(() {
      // Reset LoggerOptions before each test
      LoggerOptions.instance.reset();
    });

    test('Default Logger behavior unchanged when LoggerOptions not used', () {
      // Create loggers without any LoggerOptions configuration
      final logger1 = Logger();
      final logger2 = Logger(tag: 'TEST');

      // Should have same defaults as before LoggerOptions
      expect(logger1.enableColors, isTrue);
      expect(logger1.enableLogging, isTrue);
      expect(logger1.showClassName, isFalse); // Always false now
      expect(logger1.showFunctionName, isTrue);
      expect(logger1.showLocation, isTrue);

      expect(logger2.enableColors, isTrue);
      expect(logger2.enableLogging, isTrue);
      expect(logger2.tag, equals('TEST'));
    });

    test('Gradual adoption of LoggerOptions is possible', () {
      // Start with no configuration (backward compatible)
      final oldLogger = Logger(tag: 'OLD');
      expect(oldLogger.enableColors, isTrue);
      expect(oldLogger.enableLogging, isTrue);

      // Add some global configuration
      LoggerOptions.instance.configure(enableColors: false);

      // Old logger should be unaffected (immutable after creation)
      expect(oldLogger.enableColors, isTrue);

      // New loggers use global setting
      final newLogger = Logger(tag: 'NEW');
      expect(newLogger.enableColors, isFalse);

      // Can still use explicit overrides
      final overrideLogger = Logger(tag: 'OVERRIDE', enableColors: true);
      expect(overrideLogger.enableColors, isTrue);
    });

    test('LoggerOptions does not change Logger API surface', () {
      // Verify that Logger still has the same public API
      final logger = Logger(tag: 'API_TEST');

      // Core logging methods should still exist and work
      expect(() => logger.debug('Debug'), returnsNormally);
      expect(() => logger.info('Info'), returnsNormally);
      expect(() => logger.warn('Warn'), returnsNormally);
      expect(() => logger.error('Error'), returnsNormally);

      // Properties should still be accessible
      expect(logger.tag, equals('API_TEST'));
      expect(logger.enableColors, isA<bool>());
      expect(logger.enableLogging, isA<bool>());
      expect(logger.className, isA<String?>());
    });
  });
}
