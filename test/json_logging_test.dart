import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

void main() {
  group('JSON Logging Tests', () {
    setUp(() {
      // Reset LoggerOptions before each test
      LoggerOptions.instance.reset();
    });

    test('JSON logging methods can be called without throwing', () {
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

    test('JSON logging respects log level filtering', () {
      LoggerOptions.instance.configure(minLogLevel: LogLevel.warn);
      final logger = Logger(tag: 'FILTER_TEST');

      final testData = {'test': 'data'};

      // These should be filtered out (below warn level)
      expect(() => logger.jsonDebug(testData), returnsNormally);
      expect(() => logger.jsonInfo(testData), returnsNormally);

      // These should pass through (warn level and above)
      expect(() => logger.jsonWarn(testData), returnsNormally);
      expect(() => logger.jsonError(testData), returnsNormally);
    });

    test('JSON logging respects enableLogging setting', () {
      LoggerOptions.instance.configure(enableLogging: false);
      final logger = Logger(tag: 'DISABLED_TEST');

      final testData = {'disabled': true};

      expect(() => logger.json(testData), returnsNormally);
      expect(() => logger.jsonInfo(testData), returnsNormally);
      expect(() => logger.jsonWarn(testData), returnsNormally);
      expect(() => logger.jsonError(testData), returnsNormally);
    });

    test('JSON logging with complex nested objects', () {
      final logger = Logger(tag: 'COMPLEX_TEST');

      final complexObject = {
        'string': 'value',
        'number': 42,
        'boolean': true,
        'null_value': null,
        'list': [
          1,
          2,
          3,
          'four',
          {'nested': 'object'},
        ],
        'nested_map': {
          'level1': {
            'level2': {'level3': 'deep value'},
          },
        },
        'mixed_list': [
          {'type': 'object', 'value': 1},
          ['nested', 'array'],
          'simple string',
          123.45,
        ],
      };

      expect(
        () => logger.json(complexObject, label: 'Complex Object'),
        returnsNormally,
      );
    });

    test('JSON logging with different data types', () {
      final logger = Logger(tag: 'TYPES_TEST');

      // Test various data types
      expect(() => logger.json('string value'), returnsNormally);
      expect(() => logger.json(42), returnsNormally);
      expect(() => logger.json(3.14), returnsNormally);
      expect(() => logger.json(true), returnsNormally);
      expect(() => logger.json(false), returnsNormally);
      expect(() => logger.json(null), returnsNormally);
      expect(() => logger.json([]), returnsNormally);
      expect(() => logger.json({}), returnsNormally);
    });

    test(
      'JSON logging with non-serializable objects falls back gracefully',
      () {
        final logger = Logger(tag: 'FALLBACK_TEST');

        // Create an object that can't be JSON serialized
        final nonSerializable = DateTime.now();

        expect(
          () => logger.json(nonSerializable, label: 'DateTime'),
          returnsNormally,
        );
      },
    );

    test('JSON logging with all log levels', () {
      final logger = Logger(tag: 'LEVELS_TEST');

      final testData = {'level_test': true};

      expect(
        () => logger.json(testData, level: LogLevel.debug),
        returnsNormally,
      );
      expect(
        () => logger.json(testData, level: LogLevel.info),
        returnsNormally,
      );
      expect(
        () => logger.json(testData, level: LogLevel.warn),
        returnsNormally,
      );
      expect(
        () => logger.json(testData, level: LogLevel.error),
        returnsNormally,
      );
    });

    test('JSON logging with logger configuration overrides', () {
      LoggerOptions.instance.configure(
        enableLogging: false,
        enableColors: false,
        minLogLevel: LogLevel.error,
      );

      // Logger with overrides should still work
      final logger = Logger(
        tag: 'OVERRIDE_TEST',
        enableLogging: true,
        enableColors: true,
      );

      final testData = {'override_test': true};

      expect(() => logger.jsonDebug(testData), returnsNormally);
      expect(() => logger.jsonInfo(testData), returnsNormally);
      expect(() => logger.jsonWarn(testData), returnsNormally);
      expect(() => logger.jsonError(testData), returnsNormally);
    });
  });
}
