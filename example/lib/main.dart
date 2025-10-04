import 'package:flutter_logger_pro/flutter_logger_pro.dart';

/// 🌐 Flutter Logger Pro - Complete Examples
///
/// This example demonstrates all features of Flutter Logger Pro:
/// - Basic logging with different levels
/// - Interactive JSON logging (web-optimized)
/// - Table logging with console.table() support
/// - Global configuration options
/// - Real-world use cases
///
/// 🚀 Run this in Flutter Web and open DevTools (F12) to see interactive logging!
void main() {
  // Configure logger for optimal experience
  LoggerOptions.instance.configure(
    enableLogging: true,
    enableColors: true,
    minLogLevel: LogLevel.debug,
    includeTimestamp: true,
    showFunctionName: true,
  );

  // Run all examples
  // basicLoggingExample();
  // jsonLoggingExample();
  tableLoggingExample();
  // configurationExample();
  // realWorldExamples();
}

/// Example 1: Basic Logging
/// Shows all log levels and basic usage
void basicLoggingExample() {
  final logger = Logger(tag: 'BasicDemo');

  logger.debug('🔧 Debug: Detailed information for developers');
  logger.info('ℹ️ Info: General application events');
  logger.warn('⚠️ Warning: Something needs attention');
  logger.error('❌ Error: Something went wrong');

  // Short aliases for convenience
  logger.d('Debug using short alias');
  logger.i('Info using short alias');
  logger.w('Warning using short alias');
  logger.e('Error using short alias');
}

/// Example 2: JSON Logging
/// Perfect for debugging complex objects and API responses
void jsonLoggingExample() {
  final logger = Logger(tag: 'JsonDemo');

  // Simple object logging
  final user = {
    'id': 123,
    'name': 'John Doe',
    'email': 'john@example.com',
    'preferences': {'theme': 'dark', 'notifications': true},
  };
  logger.jsonInfo(user, label: 'User Data');

  // API response example
  final apiResponse = {
    'success': true,
    'data': [
      {'id': 1, 'name': 'Alice', 'active': true},
      {'id': 2, 'name': 'Bob', 'active': false},
    ],
    'meta': {
      'total': 2,
      'page': 1,
      'timestamp': DateTime.now().toIso8601String(),
    },
  };
  logger.jsonInfo(apiResponse, label: 'API Response');

  // Error context logging
  final errorInfo = {
    'error': 'Network timeout',
    'code': 'TIMEOUT_ERROR',
    'details': {'url': '/api/users', 'timeout': '30s', 'retryCount': 3},
  };
  logger.jsonError(errorInfo, label: 'Network Error');

  // Different log levels for JSON
  logger.jsonDebug({'debug': 'data'}, label: 'Debug Info');
  logger.jsonWarn({'warning': 'deprecated API'}, label: 'API Warning');
}

/// Example 3: Table Logging
/// Great for displaying structured data like console.table() in browsers
void tableLoggingExample() {
  final logger = Logger(tag: 'TableDemo');

  // Array of objects - most common use case
  final users = [
    {'id': 1, 'name': 'Alice', 'age': 25, 'city': 'Boston'},
    {'id': 2, 'name': 'Bob', 'age': 30, 'city': 'Seattle'},
    {'id': 3, 'name': 'Charlie', 'age': 35, 'city': 'Denver'},
  ];
  logger.tableInfo(users, label: 'User List');

  // Single object - keys become rows
  final config = {
    'appName': 'MyApp',
    'version': '1.2.0',
    'environment': 'production',
    'debug': false,
  };
  logger.tableInfo(config, label: 'App Configuration');

  // Column filtering - show only specific columns
  logger.tableInfo(
    users,
    columns: ['name', 'city'],
    label: 'Users (Name & City Only)',
  );

  // Different log levels for tables
  final metrics = [
    {'metric': 'CPU Usage', 'value': '45%', 'status': 'OK'},
    {'metric': 'Memory', 'value': '78%', 'status': 'Warning'},
    {'metric': 'Disk Space', 'value': '92%', 'status': 'Critical'},
  ];
  logger.tableWarn(metrics, label: 'System Metrics');

  // Array of arrays format
  final matrix = [
    ['Product', 'Price', 'Stock'],
    ['Laptop', 999.99, 15],
    ['Mouse', 29.99, 50],
    ['Keyboard', 79.99, 25],
  ];
  logger.tableInfo(matrix, label: 'Product Inventory');
}

/// Example 4: Configuration Options
/// Shows how to configure logging globally and per-instance
void configurationExample() {
  // Global configuration - affects all new loggers
  LoggerOptions.instance.configure(
    enableLogging: true,
    enableColors: true,
    minLogLevel: LogLevel.info, // Only info and above
    includeTimestamp: true,
    dateTimeFormat: 'HH:mm:ss',
    showFunctionName: true,
    showLocation: false,
  );

  final globalLogger = Logger(tag: 'Global');
  globalLogger.debug(
    'This debug message won\'t show (filtered by minLogLevel)',
  );
  globalLogger.info('This info message will show');

  // Per-instance overrides
  final debugLogger = Logger(
    tag: 'Debug',
    enableColors: false, // Override global setting
    showLocation: true, // Override global setting
  );
  debugLogger.info('Custom logger with different settings');

  // Different message template
  LoggerOptions.instance.configure(
    messageTemplate: '[{timestamp}] {level} | {tag} | {message}',
  );

  final customLogger = Logger(tag: 'Custom');
  customLogger.info('Message with custom template');
}

/// Example 5: Real-World Use Cases
/// Practical examples you might use in actual applications
void realWorldExamples() {
  // Use case 1: API Service Logging
  apiServiceExample();

  // Use case 2: User Authentication
  authenticationExample();

  // Use case 3: Error Handling
  errorHandlingExample();

  // Use case 4: Performance Monitoring
  performanceExample();
}

/// API service with comprehensive logging
void apiServiceExample() {
  final apiLogger = Logger(tag: 'ApiService');

  apiLogger.info('🌐 Making API request to /users');

  // Log request details
  final requestData = {
    'method': 'GET',
    'url': '/api/users',
    'headers': {'Authorization': 'Bearer token123'},
    'timestamp': DateTime.now().toIso8601String(),
  };
  apiLogger.jsonDebug(requestData, label: 'Request Details');

  // Simulate response
  final responseData = {
    'status': 200,
    'data': [
      {'id': 1, 'name': 'Alice'},
      {'id': 2, 'name': 'Bob'},
    ],
    'duration': '150ms',
  };
  apiLogger.jsonInfo(responseData, label: 'API Response');
}

/// User authentication flow with logging
void authenticationExample() {
  final authLogger = Logger(tag: 'Auth');

  authLogger.info('🔐 User login attempt');

  // Log login attempt
  final loginData = {
    'email': 'user@example.com',
    'timestamp': DateTime.now().toIso8601String(),
    'ipAddress': '192.168.1.100',
    'userAgent': 'Flutter Web App',
  };
  authLogger.jsonDebug(loginData, label: 'Login Attempt');

  // Success case
  authLogger.info('✅ User authenticated successfully');

  // Log user session
  final sessionInfo = {
    'userId': 123,
    'sessionId': 'sess_abc123',
    'expiresAt': DateTime.now().add(Duration(hours: 24)).toIso8601String(),
    'permissions': ['read', 'write'],
  };
  authLogger.jsonInfo(sessionInfo, label: 'User Session Created');
}

/// Error handling with comprehensive logging
void errorHandlingExample() {
  final errorLogger = Logger(tag: 'ErrorHandler');

  try {
    // Simulate an error
    throw Exception('Database connection failed');
  } catch (e, stackTrace) {
    // Log comprehensive error information
    final errorContext = {
      'error': e.toString(),
      'type': e.runtimeType.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'context': {'operation': 'fetchUserData', 'userId': 123, 'retryCount': 2},
      'stackTrace': stackTrace.toString().split('\n').take(5).toList(),
    };

    errorLogger.jsonError(errorContext, label: 'Database Error');
    errorLogger.error('❌ Operation failed: ${e.toString()}');
  }
}

/// Performance monitoring example
void performanceExample() {
  final perfLogger = Logger(tag: 'Performance');

  // Track operation timing
  final stopwatch = Stopwatch()..start();

  // Simulate some work
  Future.delayed(Duration(milliseconds: 100));

  stopwatch.stop();

  // Log performance metrics
  final metrics = [
    {
      'operation': 'dataLoad',
      'duration': '${stopwatch.elapsedMilliseconds}ms',
      'status': 'success',
    },
    {'operation': 'renderUI', 'duration': '45ms', 'status': 'success'},
    {'operation': 'apiCall', 'duration': '230ms', 'status': 'timeout'},
  ];

  perfLogger.tableInfo(metrics, label: 'Operation Performance');

  // Memory usage
  final memoryInfo = {
    'heapUsed': '45MB',
    'heapTotal': '128MB',
    'external': '12MB',
    'timestamp': DateTime.now().toIso8601String(),
  };

  perfLogger.jsonInfo(memoryInfo, label: 'Memory Usage');
}
