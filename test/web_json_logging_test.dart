@TestOn('browser')
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

void main() {
  group('Web JSON Logging Tests', () {
    setUp(() {
      // Reset LoggerOptions before each test
      LoggerOptions.instance.reset();
    });

    test('Web JSON logging shows complete message in IDE logs', () {
      final logger = Logger(tag: 'WEB_JSON_TEST');
      
      final testData = {
        'message': 'This should be visible in both browser console and IDE logs',
        'data': {
          'nested': true,
          'values': [1, 2, 3]
        }
      };
      
      // These should work without throwing and show complete JSON in IDE logs
      expect(() => logger.json(testData, label: 'Test Data'), returnsNormally);
      expect(() => logger.jsonInfo(testData), returnsNormally);
      expect(() => logger.jsonError(testData, label: 'Error Data'), returnsNormally);
    });

    test('Web JSON logging handles complex nested objects', () {
      final logger = Logger(tag: 'WEB_COMPLEX');
      
      final complexData = {
        'level1': {
          'level2': {
            'level3': {
              'deep': 'value',
              'array': [
                {'item': 1},
                {'item': 2},
                ['nested', 'array']
              ]
            }
          }
        },
        'metadata': {
          'timestamp': DateTime.now().toIso8601String(),
          'version': '1.0.0'
        }
      };
      
      expect(() => logger.json(complexData, label: 'Complex Data'), returnsNormally);
    });

    test('Web JSON logging with different log levels', () {
      final logger = Logger(tag: 'WEB_LEVELS');
      
      final testData = {'level': 'test'};
      
      expect(() => logger.jsonDebug(testData, label: 'Debug'), returnsNormally);
      expect(() => logger.jsonInfo(testData, label: 'Info'), returnsNormally);
      expect(() => logger.jsonWarn(testData, label: 'Warning'), returnsNormally);
      expect(() => logger.jsonError(testData, label: 'Error'), returnsNormally);
    });
  });
}