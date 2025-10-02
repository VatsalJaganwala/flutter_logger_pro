import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

class _TestService {
  final Logger _logger = Logger(tag: 'TestService');

  void doSomething() {
    _logger.info('Doing something');
  }

  void handleError() {
    _logger.error('An error occurred');
  }
}

void main() {
  group('Backward Compatibility Tests', () {
    setUp(() {
      // Reset LoggerOptions before each test to ensure clean state
      LoggerOptions.instance.reset();
    });

    test(
      'Logger works exactly as before without LoggerOptions configuration',
      () {
        // Test that all existing Logger usage patterns work unchanged

        // Basic logger creation
        final logger1 = Logger();
        expect(logger1, isNotNull);
        expect(logger1.enableColors, isTrue); // Default behavior
        expect(logger1.enableLogging, isTrue); // Default behavior
        expect(logger1.tag, isNull); // No tag by default

        // Logger with tag
        final logger2 = Logger(tag: 'TEST');
        expect(logger2.tag, equals('TEST'));
        expect(logger2.enableColors, isTrue); // Default behavior
        expect(logger2.enableLogging, isTrue); // Default behavior

        // Logger with explicit parameters
        final logger3 = Logger(
          tag: 'CUSTOM',
          enableColors: false,
          enableLogging: true,
        );
        expect(logger3.tag, equals('CUSTOM'));
        expect(logger3.enableColors, isFalse); // Explicit setting
        expect(logger3.enableLogging, isTrue); // Explicit setting

        // All logging methods should work without throwing
        expect(() => logger1.debug('Debug message'), returnsNormally);
        expect(() => logger1.info('Info message'), returnsNormally);
        expect(() => logger1.warn('Warning message'), returnsNormally);
        expect(() => logger1.error('Error message'), returnsNormally);

        expect(() => logger2.debug('Tagged debug'), returnsNormally);
        expect(() => logger2.info('Tagged info'), returnsNormally);
        expect(() => logger2.warn('Tagged warning'), returnsNormally);
        expect(() => logger2.error('Tagged error'), returnsNormally);

        expect(() => logger3.debug('Custom debug'), returnsNormally);
        expect(() => logger3.info('Custom info'), returnsNormally);
        expect(() => logger3.warn('Custom warning'), returnsNormally);
        expect(() => logger3.error('Custom error'), returnsNormally);
      },
    );

    test('Logger constructor parameters take precedence over defaults', () {
      // This behavior should be unchanged from before LoggerOptions

      final logger1 = Logger(enableColors: false);
      expect(logger1.enableColors, isFalse);

      final logger2 = Logger(enableLogging: false);
      expect(logger2.enableLogging, isFalse);

      final logger3 = Logger(
        tag: 'EXPLICIT',
        enableColors: true,
        enableLogging: true,
      );
      expect(logger3.tag, equals('EXPLICIT'));
      expect(logger3.enableColors, isTrue);
      expect(logger3.enableLogging, isTrue);

      // Test that disabled logger doesn't throw
      expect(() => logger2.info('Should not output'), returnsNormally);
    });

    test(
      'Multiple loggers with different configurations work independently',
      () {
        // This pattern should work exactly as before

        final defaultLogger = Logger();
        final taggedLogger = Logger(tag: 'TAGGED');
        final noColorLogger = Logger(enableColors: false);
        final disabledLogger = Logger(enableLogging: false);
        final customLogger = Logger(
          tag: 'CUSTOM',
          enableColors: false,
          enableLogging: true,
        );

        // Verify each logger has correct configuration
        expect(defaultLogger.enableColors, isTrue);
        expect(defaultLogger.enableLogging, isTrue);
        expect(defaultLogger.tag, isNull);

        expect(taggedLogger.enableColors, isTrue);
        expect(taggedLogger.enableLogging, isTrue);
        expect(taggedLogger.tag, equals('TAGGED'));

        expect(noColorLogger.enableColors, isFalse);
        expect(noColorLogger.enableLogging, isTrue);
        expect(noColorLogger.tag, isNull);

        expect(disabledLogger.enableColors, isTrue);
        expect(disabledLogger.enableLogging, isFalse);
        expect(disabledLogger.tag, isNull);

        expect(customLogger.enableColors, isFalse);
        expect(customLogger.enableLogging, isTrue);
        expect(customLogger.tag, equals('CUSTOM'));

        // All should work without throwing
        final loggers = [
          defaultLogger,
          taggedLogger,
          noColorLogger,
          disabledLogger,
          customLogger,
        ];
        for (final logger in loggers) {
          expect(() => logger.debug('Test debug'), returnsNormally);
          expect(() => logger.info('Test info'), returnsNormally);
          expect(() => logger.warn('Test warning'), returnsNormally);
          expect(() => logger.error('Test error'), returnsNormally);
        }
      },
    );

    test(
      'Logger behavior is consistent with pre-LoggerOptions implementation',
      () {
        // Test specific behaviors that should remain unchanged

        // Logger with disabled logging should not throw but should not output
        final disabledLogger = Logger(enableLogging: false);
        expect(() {
          disabledLogger.debug('Should not output');
          disabledLogger.info('Should not output');
          disabledLogger.warn('Should not output');
          disabledLogger.error('Should not output');
        }, returnsNormally);

        // Logger with disabled colors should still log
        final noColorLogger = Logger(enableColors: false);
        expect(() {
          noColorLogger.debug('No color debug');
          noColorLogger.info('No color info');
          noColorLogger.warn('No color warning');
          noColorLogger.error('No color error');
        }, returnsNormally);

        // Logger with both disabled should not throw
        final fullyDisabledLogger = Logger(
          enableColors: false,
          enableLogging: false,
        );
        expect(() {
          fullyDisabledLogger.debug('Fully disabled');
          fullyDisabledLogger.info('Fully disabled');
          fullyDisabledLogger.warn('Fully disabled');
          fullyDisabledLogger.error('Fully disabled');
        }, returnsNormally);
      },
    );

    test('Logger creation performance is not significantly impacted', () {
      // Ensure that adding LoggerOptions doesn't slow down logger creation
      const iterations = 100;

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < iterations; i++) {
        final logger = Logger(tag: 'PERF_TEST_$i');
        logger.info('Performance test $i');
      }

      stopwatch.stop();

      // Should complete quickly (less than 1 second for 100 loggers)
      expect(
        stopwatch.elapsedMilliseconds < 1000,
        isTrue,
        reason: 'Logger creation should be fast',
      );
    });

    test('Existing code patterns work without modification', () {
      // Test common usage patterns that existing code might use

      // Pattern 1: Simple logger
      void simpleLogging() {
        final logger = Logger();
        logger.info('Simple logging works');
      }

      expect(() => simpleLogging(), returnsNormally);

      // Pattern 2: Tagged logger
      void taggedLogging() {
        final logger = Logger(tag: 'SERVICE');
        logger.debug('Service started');
        logger.info('Service running');
        logger.warn('Service warning');
        logger.error('Service error');
      }

      expect(() => taggedLogging(), returnsNormally);

      // Pattern 3: Conditional logging
      void conditionalLogging(bool enableDebug) {
        final logger = Logger(tag: 'DEBUG', enableLogging: enableDebug);
        logger.debug('Debug message');
        logger.info('Info message');
      }

      expect(() => conditionalLogging(true), returnsNormally);
      expect(() => conditionalLogging(false), returnsNormally);

      // Pattern 4: Class-based logging
      final testService = _TestService();
      expect(() => testService.doSomething(), returnsNormally);
      expect(() => testService.handleError(), returnsNormally);
    });

    test('Logger properties are immutable after creation', () {
      // This behavior should be unchanged

      final logger = Logger(
        tag: 'IMMUTABLE',
        enableColors: false,
        enableLogging: true,
      );

      // Properties should not change
      expect(logger.tag, equals('IMMUTABLE'));
      expect(logger.enableColors, isFalse);
      expect(logger.enableLogging, isTrue);

      // Even if we configure LoggerOptions after creation,
      // existing logger should retain its configuration
      LoggerOptions.instance.configure(
        enableColors: true,
        enableLogging: false,
      );

      // Logger properties should remain unchanged
      expect(logger.tag, equals('IMMUTABLE'));
      expect(logger.enableColors, isFalse); // Should not change
      expect(logger.enableLogging, isTrue); // Should not change

      // Logger should still work with original configuration
      expect(() => logger.info('Still works'), returnsNormally);
    });

    test('No breaking changes in public API', () {
      // Ensure all existing Logger constructor signatures work

      // All these should compile and work without errors
      final logger1 = Logger();
      final logger2 = Logger(tag: 'TEST');
      final logger3 = Logger(enableColors: false);
      final logger4 = Logger(enableLogging: false);
      final logger5 = Logger(
        tag: 'FULL',
        enableColors: true,
        enableLogging: true,
      );

      // All should be Logger instances
      expect(logger1, isA<Logger>());
      expect(logger2, isA<Logger>());
      expect(logger3, isA<Logger>());
      expect(logger4, isA<Logger>());
      expect(logger5, isA<Logger>());

      // All should have the expected properties
      expect(logger1.tag, isNull);
      expect(logger2.tag, equals('TEST'));
      expect(logger3.enableColors, isFalse);
      expect(logger4.enableLogging, isFalse);
      expect(logger5.tag, equals('FULL'));
      expect(logger5.enableColors, isTrue);
      expect(logger5.enableLogging, isTrue);

      // All logging methods should exist and work
      final loggers = [logger1, logger2, logger3, logger4, logger5];
      for (final logger in loggers) {
        expect(() => logger.debug('test'), returnsNormally);
        expect(() => logger.info('test'), returnsNormally);
        expect(() => logger.warn('test'), returnsNormally);
        expect(() => logger.error('test'), returnsNormally);
      }
    });
  });
}
