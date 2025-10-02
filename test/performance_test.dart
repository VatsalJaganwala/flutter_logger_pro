import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

void main() {
  group('Performance Tests', () {
    setUp(() {
      LoggerOptions.instance.reset();
    });

    test('Logger performance with LoggerOptions enabled vs disabled', () {
      const iterations = 10000;

      // Test 1: Logger without LoggerOptions configuration (baseline)
      final baselineLogger = Logger(tag: 'BASELINE');
      final baselineStopwatch = Stopwatch()..start();

      for (int i = 0; i < iterations; i++) {
        baselineLogger.info('Baseline message $i');
      }

      baselineStopwatch.stop();
      final baselineTime = baselineStopwatch.elapsedMicroseconds;

      // Test 2: Logger with LoggerOptions configured (should be similar performance)
      LoggerOptions.instance.configure(
        enableLogging: true,
        enableColors: true,
        minLogLevel: LogLevel.debug,
        // showClassName: true, // Hidden for future release
        showFunctionName: true,
        showLocation: true,
      );

      final configuredLogger = Logger(tag: 'CONFIGURED');
      final configuredStopwatch = Stopwatch()..start();

      for (int i = 0; i < iterations; i++) {
        configuredLogger.info('Configured message $i');
      }

      configuredStopwatch.stop();
      final configuredTime = configuredStopwatch.elapsedMicroseconds;

      // Test 3: Logger with logging disabled (should be fastest)
      LoggerOptions.instance.configure(enableLogging: false);

      final disabledLogger = Logger(tag: 'DISABLED');
      final disabledStopwatch = Stopwatch()..start();

      for (int i = 0; i < iterations; i++) {
        disabledLogger.info('Disabled message $i');
      }

      disabledStopwatch.stop();
      final disabledTime = disabledStopwatch.elapsedMicroseconds;

      print('Performance Results ($iterations iterations):');
      print('Baseline (no LoggerOptions): ${baselineTime}μs');
      print('Configured LoggerOptions: ${configuredTime}μs');
      print('Disabled logging: ${disabledTime}μs');

      // Performance assertions
      // Disabled logging should be significantly faster
      expect(
        disabledTime < baselineTime,
        isTrue,
        reason: 'Disabled logging should be faster than baseline',
      );

      // Configured should not be more than 50% slower than baseline
      final overhead = (configuredTime - baselineTime) / baselineTime;
      expect(
        overhead < 0.5,
        isTrue,
        reason: 'LoggerOptions overhead should be less than 50%',
      );

      // Disabled should be at least 50% faster than baseline
      final disabledSpeedup = (baselineTime - disabledTime) / baselineTime;
      expect(
        disabledSpeedup > 0.5,
        isTrue,
        reason: 'Disabled logging should be at least 50% faster',
      );
    });

    test('Logger performance with different log levels', () {
      const iterations = 5000;

      // Test filtering performance at different levels
      final logger = Logger(tag: 'LEVEL_TEST');

      // Test with debug level (all messages pass)
      LoggerOptions.instance.configure(minLogLevel: LogLevel.debug);
      final debugStopwatch = Stopwatch()..start();

      for (int i = 0; i < iterations; i++) {
        logger.debug('Debug $i');
        logger.info('Info $i');
        logger.warn('Warn $i');
        logger.error('Error $i');
      }

      debugStopwatch.stop();
      final debugTime = debugStopwatch.elapsedMicroseconds;

      // Test with error level (most messages filtered)
      LoggerOptions.instance.configure(minLogLevel: LogLevel.error);
      final errorStopwatch = Stopwatch()..start();

      for (int i = 0; i < iterations; i++) {
        logger.debug('Debug $i'); // Filtered
        logger.info('Info $i'); // Filtered
        logger.warn('Warn $i'); // Filtered
        logger.error('Error $i'); // Not filtered
      }

      errorStopwatch.stop();
      final errorTime = errorStopwatch.elapsedMicroseconds;

      print('Log Level Performance ($iterations iterations each level):');
      print('Debug level (all pass): ${debugTime}μs');
      print('Error level (most filtered): ${errorTime}μs');

      // Error level should be faster due to filtering
      expect(
        errorTime < debugTime,
        isTrue,
        reason: 'Higher minimum log level should be faster due to filtering',
      );
    });

    test('Logger creation performance with and without LoggerOptions', () {
      const iterations = 1000;

      // Test 1: Logger creation without LoggerOptions configuration
      LoggerOptions.instance.reset();
      final baselineStopwatch = Stopwatch()..start();

      for (int i = 0; i < iterations; i++) {
        final logger = Logger(tag: 'BASELINE_$i');
        logger.info('Test'); // Ensure logger is used
      }

      baselineStopwatch.stop();
      final baselineTime = baselineStopwatch.elapsedMicroseconds;

      // Test 2: Logger creation with LoggerOptions configured
      LoggerOptions.instance.configure(
        enableLogging: true,
        enableColors: false,
        minLogLevel: LogLevel.info,
        // showClassName: false, // Hidden for future release
        showFunctionName: false,
        showLocation: false,
      );

      final configuredStopwatch = Stopwatch()..start();

      for (int i = 0; i < iterations; i++) {
        final logger = Logger(tag: 'CONFIGURED_$i');
        logger.info('Test'); // Ensure logger is used
      }

      configuredStopwatch.stop();
      final configuredTime = configuredStopwatch.elapsedMicroseconds;

      print('Logger Creation Performance ($iterations creations):');
      print('Baseline: ${baselineTime}μs');
      print('With LoggerOptions: ${configuredTime}μs');

      // Creation time should not be significantly different
      // Allow for some variance in timing, but configured should not be more than 2x slower
      final ratio = configuredTime / baselineTime;
      expect(
        ratio < 2.0,
        isTrue,
        reason:
            'Logger creation with LoggerOptions should not be more than 2x slower than baseline',
      );
    });

    test('Singleton access performance', () {
      const iterations = 100000;

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < iterations; i++) {
        final instance = LoggerOptions.instance;
        // Access some properties to ensure the instance is used
        instance.effectiveEnableLogging;
        instance.effectiveMinLogLevel;
      }

      stopwatch.stop();
      final totalTime = stopwatch.elapsedMicroseconds;
      final avgTime = totalTime / iterations;

      print('Singleton Access Performance ($iterations accesses):');
      print('Total: ${totalTime}μs');
      print('Average: ${avgTime.toStringAsFixed(3)}μs per access');

      // Singleton access should be very fast (less than 1μs per access on average)
      expect(
        avgTime < 1.0,
        isTrue,
        reason: 'Singleton access should be very fast',
      );
    });

    test('Memory usage with multiple loggers', () {
      const loggerCount = 1000;

      // Create many loggers with different configurations
      final loggers = <Logger>[];

      LoggerOptions.instance.configure(
        enableLogging: true,
        enableColors: false,
        minLogLevel: LogLevel.info,
      );

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < loggerCount; i++) {
        final logger = Logger(
          tag: 'LOGGER_$i',
          enableColors: i % 2 == 0, // Alternate colors
          // showClassName: i % 3 == 0, // Hidden for future release
        );
        loggers.add(logger);
      }

      stopwatch.stop();

      // Test that all loggers work
      for (int i = 0; i < loggers.length; i += 100) {
        loggers[i].info('Test message $i');
      }

      print(
        'Memory Test ($loggerCount loggers created in ${stopwatch.elapsedMilliseconds}ms)',
      );
      print('All loggers functional: ${loggers.length == loggerCount}');

      expect(loggers.length, equals(loggerCount));
      expect(
        stopwatch.elapsedMilliseconds < 1000,
        isTrue,
        reason: 'Creating $loggerCount loggers should take less than 1 second',
      );
    });
  });
}
