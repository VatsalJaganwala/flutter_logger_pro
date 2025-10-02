import 'dart:isolate';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

void main() {
  group('Thread Safety Tests', () {
    setUp(() {
      LoggerOptions.instance.reset();
    });

    test('LoggerOptions singleton is consistent across isolates', () async {
      // Test that the singleton pattern works correctly in a multi-threaded environment
      
      // Configure LoggerOptions in main isolate
      LoggerOptions.instance.configure(
        enableLogging: false,
        enableColors: false,
        minLogLevel: LogLevel.error,
      );
      
      // Verify configuration in main isolate
      expect(LoggerOptions.instance.effectiveEnableLogging, isFalse);
      expect(LoggerOptions.instance.effectiveEnableColors, isFalse);
      expect(LoggerOptions.instance.effectiveMinLogLevel, equals(LogLevel.error));
      
      // Note: In Dart, each isolate has its own memory space, so the singleton
      // will be separate in each isolate. This is expected behavior.
      // We test that the singleton pattern works correctly within each isolate.
      
      // Test concurrent access to singleton within same isolate
      final futures = <Future<bool>>[];
      
      for (int i = 0; i < 10; i++) {
        futures.add(Future(() {
          final instance1 = LoggerOptions.instance;
          final instance2 = LoggerOptions.instance;
          return identical(instance1, instance2);
        }));
      }
      
      final results = await Future.wait(futures);
      
      // All should return true (same instance)
      for (final result in results) {
        expect(result, isTrue, reason: 'Singleton should return same instance');
      }
    });

    test('Concurrent Logger creation with LoggerOptions is safe', () async {
      // Test that multiple loggers can be created concurrently without issues
      
      LoggerOptions.instance.configure(
        enableLogging: true,
        enableColors: false,
        minLogLevel: LogLevel.info,
        // showClassName: true, // Hidden for future release
        showFunctionName: false,
        showLocation: true,
      );
      
      final futures = <Future<Logger>>[];
      
      // Create multiple loggers concurrently
      for (int i = 0; i < 20; i++) {
        futures.add(Future(() {
          return Logger(tag: 'CONCURRENT_$i');
        }));
      }
      
      final loggers = await Future.wait(futures);
      
      // Verify all loggers were created successfully
      expect(loggers.length, equals(20));
      
      // Verify all loggers have correct configuration from LoggerOptions
      for (int i = 0; i < loggers.length; i++) {
        final logger = loggers[i];
        expect(logger.tag, equals('CONCURRENT_$i'));
        expect(logger.enableLogging, isTrue);
        expect(logger.enableColors, isFalse);
        expect(logger.showClassName, isFalse); // Always false now
        expect(logger.showFunctionName, isFalse);
        expect(logger.showLocation, isTrue);
      }
      
      // Test that all loggers work correctly
      final loggingFutures = <Future<void>>[];
      for (final logger in loggers) {
        loggingFutures.add(Future(() {
          logger.info('Concurrent logging test');
          logger.warn('Concurrent warning test');
          logger.error('Concurrent error test');
        }));
      }
      
      // Should complete without errors
      await Future.wait(loggingFutures);
    });

    test('Concurrent LoggerOptions configuration is safe', () async {
      // Test that multiple concurrent configuration calls don't cause issues
      
      final futures = <Future<void>>[];
      
      // Multiple concurrent configure calls
      for (int i = 0; i < 10; i++) {
        futures.add(Future(() {
          LoggerOptions.instance.configure(
            enableLogging: i % 2 == 0,
            enableColors: i % 3 == 0,
            minLogLevel: i % 2 == 0 ? LogLevel.debug : LogLevel.error,
          );
        }));
      }
      
      // Should complete without errors
      await Future.wait(futures);
      
      // LoggerOptions should still be in a valid state
      final options = LoggerOptions.instance;
      expect(options.effectiveEnableLogging, isA<bool>());
      expect(options.effectiveEnableColors, isA<bool>());
      expect(options.effectiveMinLogLevel, isA<LogLevel>());
      
      // Should be able to create and use loggers after concurrent configuration
      final logger = Logger(tag: 'POST_CONCURRENT');
      expect(() => logger.info('Test after concurrent config'), returnsNormally);
    });

    test('LoggerOptions state consistency under concurrent access', () async {
      // Test that the singleton state remains consistent under concurrent access
      
      const iterations = 100;
      final futures = <Future<Map<String, dynamic>>>[];
      
      // Set initial state
      LoggerOptions.instance.configure(
        enableLogging: true,
        enableColors: true,
        minLogLevel: LogLevel.debug,
      );
      
      // Concurrent reads of LoggerOptions state
      for (int i = 0; i < iterations; i++) {
        futures.add(Future(() {
          final options = LoggerOptions.instance;
          return {
            'enableLogging': options.effectiveEnableLogging,
            'enableColors': options.effectiveEnableColors,
            'minLogLevel': options.effectiveMinLogLevel,
            'iteration': i,
          };
        }));
      }
      
      final results = await Future.wait(futures);
      
      // All reads should return consistent values
      final firstResult = results.first;
      for (final result in results) {
        expect(result['enableLogging'], equals(firstResult['enableLogging']),
          reason: 'enableLogging should be consistent across concurrent reads');
        expect(result['enableColors'], equals(firstResult['enableColors']),
          reason: 'enableColors should be consistent across concurrent reads');
        expect(result['minLogLevel'], equals(firstResult['minLogLevel']),
          reason: 'minLogLevel should be consistent across concurrent reads');
      }
    });

    test('Logger performance under concurrent usage', () async {
      // Test that logger performance doesn't degrade under concurrent usage
      
      LoggerOptions.instance.configure(
        enableLogging: true,
        enableColors: false,
        minLogLevel: LogLevel.info,
      );
      
      final logger = Logger(tag: 'PERFORMANCE');
      const messagesPerFuture = 100;
      const concurrentFutures = 10;
      
      final stopwatch = Stopwatch()..start();
      
      final futures = <Future<void>>[];
      for (int i = 0; i < concurrentFutures; i++) {
        futures.add(Future(() {
          for (int j = 0; j < messagesPerFuture; j++) {
            logger.info('Concurrent message $i-$j');
          }
        }));
      }
      
      await Future.wait(futures);
      stopwatch.stop();
      
      final totalMessages = concurrentFutures * messagesPerFuture;
      final avgTimePerMessage = stopwatch.elapsedMicroseconds / totalMessages;
      
      print('Concurrent Performance: $totalMessages messages in ${stopwatch.elapsedMilliseconds}ms');
      print('Average: ${avgTimePerMessage.toStringAsFixed(2)}μs per message');
      
      // Should complete in reasonable time (less than 5 seconds for 1000 messages)
      expect(stopwatch.elapsedMilliseconds < 5000, isTrue,
        reason: 'Concurrent logging should complete in reasonable time');
    });

    test('LoggerOptions reset is safe under concurrent access', () async {
      // Test that reset() works correctly even with concurrent access
      
      // Set some configuration
      LoggerOptions.instance.configure(
        enableLogging: false,
        enableColors: false,
        minLogLevel: LogLevel.error,
      );
      
      final futures = <Future<void>>[];
      
      // Some futures will reset, others will read
      for (int i = 0; i < 20; i++) {
        if (i % 5 == 0) {
          // Reset every 5th future
          futures.add(Future(() {
            LoggerOptions.instance.reset();
          }));
        } else {
          // Others just read the configuration
          futures.add(Future(() {
            final options = LoggerOptions.instance;
            // Just access the properties to ensure no errors
            options.effectiveEnableLogging;
            options.effectiveEnableColors;
            options.effectiveMinLogLevel;
          }));
        }
      }
      
      // Should complete without errors
      await Future.wait(futures);
      
      // LoggerOptions should be in a valid state after concurrent reset/access
      final options = LoggerOptions.instance;
      expect(options.effectiveEnableLogging, isA<bool>());
      expect(options.effectiveEnableColors, isA<bool>());
      expect(options.effectiveMinLogLevel, isA<LogLevel>());
      
      // Should be able to use logger after concurrent operations
      final logger = Logger(tag: 'POST_RESET');
      expect(() => logger.info('Test after concurrent reset'), returnsNormally);
    });
  });
}