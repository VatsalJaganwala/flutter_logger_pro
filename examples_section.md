# 📚 Examples

This section provides practical, copy-paste ready examples to get you started with Flutter Logger Pro quickly.

## 🚀 Quick Start (30 seconds)

### Minimal Setup

```dart
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

void main() {
  final logger = Logger(tag: 'MyApp');
  
  logger.info('🎉 Flutter Logger Pro is ready!');
  logger.warn('⚠️ This is a warning');
  logger.error('❌ Something went wrong');
}
```

**Expected Output:**
```
[MyApp][INFO] 🎉 Flutter Logger Pro is ready!
[MyApp][WARN] ⚠️ This is a warning
[MyApp][ERROR] ❌ Something went wrong
```

### Web-Optimized Setup

```dart
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

void main() {
  // Configure for optimal web experience
  LoggerOptions.instance.configure(
    enableColors: true,
    includeTimestamp: true,
    minLogLevel: LogLevel.debug,
  );

  final logger = Logger(tag: 'WebApp');
  
  // Interactive JSON - click to expand in browser DevTools!
  logger.json({
    'user': {'id': 123, 'name': 'John'},
    'session': {'duration': '45min'}
  }, label: 'User Session');
  
  // Native table - uses console.table() in browser!
  logger.table([
    {'name': 'Alice', 'revenue': 299.99},
    {'name': 'Bob', 'revenue': 149.99},
  ], label: 'User Analytics');
}
```

**Browser Console Result:**
- 🔍 Interactive, expandable JSON objects
- 📊 Native console.table() with sortable columns
- 🎯 Dual output (browser + IDE console)

## 📖 Core Examples

### 1. Basic Logging Levels

```dart
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

void basicLoggingExample() {
  final logger = Logger(tag: 'BasicDemo');

  // All log levels
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
```

**Expected Output:**
```
[BasicDemo][DEBUG] 🔧 Debug: Detailed information for developers
[BasicDemo][INFO] ℹ️ Info: General application events
[BasicDemo][WARN] ⚠️ Warning: Something needs attention
[BasicDemo][ERROR] ❌ Error: Something went wrong
[BasicDemo][DEBUG] Debug using short alias
[BasicDemo][INFO] Info using short alias
[BasicDemo][WARN] Warning using short alias
[BasicDemo][ERROR] Error using short alias
```

### 2. JSON Logging (Web-Optimized)

Perfect for debugging complex objects and API responses:

```dart
void jsonLoggingExample() {
  final logger = Logger(tag: 'JsonDemo');

  // Simple object logging
  final user = {
    'id': 123,
    'name': 'John Doe',
    'email': 'john@example.com',
    'preferences': {
      'theme': 'dark',
      'notifications': true,
    },
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
    'details': {
      'url': '/api/users',
      'timeout': '30s',
      'retryCount': 3,
    },
  };
  logger.jsonError(errorInfo, label: 'Network Error');

  // Different log levels for JSON
  logger.jsonDebug({'debug': 'data'}, label: 'Debug Info');
  logger.jsonWarn({'warning': 'deprecated API'}, label: 'API Warning');
}
```

**IDE Console Output:**
```
[JsonDemo][INFO] User Data:
{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com",
  "preferences": {
    "theme": "dark",
    "notifications": true
  }
}
```

**Browser Console:**
Interactive, collapsible object tree for easy exploration.

### 3. Table Logging

Great for displaying structured data like console.table() in browsers:

```dart
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
```

**IDE Console Output:**
```
[TableDemo][INFO] User List:
┌─────────┬─────────┬─────────┬─────────┐
│ (index) │   id    │  name   │  city   │
├─────────┼─────────┼─────────┼─────────┤
│    0    │    1    │ 'Alice' │'Boston' │
│    1    │    2    │  'Bob'  │'Seattle'│
│    2    │    3    │'Charlie'│'Denver' │
└─────────┴─────────┴─────────┴─────────┘
```

**Browser Console:**
Native console.table() with interactive, sortable columns.

### 4. Configuration Options

Shows how to configure logging globally and per-instance:

```dart
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
  globalLogger.debug('This debug message won\'t show (filtered by minLogLevel)');
  globalLogger.info('This info message will show');

  // Per-instance overrides
  final debugLogger = Logger(
    tag: 'Debug',
    enableColors: false, // Override global setting
    showLocation: true,  // Override global setting
  );
  debugLogger.info('Custom logger with different settings');

  // Different message template
  LoggerOptions.instance.configure(
    messageTemplate: '[{timestamp}] {level} | {tag} | {message}',
  );
  
  final customLogger = Logger(tag: 'Custom');
  customLogger.info('Message with custom template');
}
```

**Expected Output:**
```
[14:30:25][Global][INFO] This info message will show
[14:30:25] INFO | Custom | Message with custom template
```

## 🛠️ Real-World Use Cases

### API Service Logging

```dart
class ApiService {
  final _logger = Logger(tag: 'ApiService');
  
  Future<Map<String, dynamic>> fetchUsers() async {
    _logger.info('🌐 Making API request to /users');
    
    // Log request details
    final requestData = {
      'method': 'GET',
      'url': '/api/users',
      'headers': {'Authorization': 'Bearer token123'},
      'timestamp': DateTime.now().toIso8601String(),
    };
    _logger.jsonDebug(requestData, label: 'Request Details');
    
    try {
      final response = await http.get(Uri.parse('/api/users'));
      
      // Log successful response
      final responseData = {
        'status': response.statusCode,
        'data': jsonDecode(response.body),
        'duration': '150ms',
      };
      _logger.jsonInfo(responseData, label: 'API Response');
      
      return jsonDecode(response.body);
    } catch (e) {
      _logger.error('❌ API request failed: $e');
      rethrow;
    }
  }
}
```

### User Authentication Flow

```dart
class AuthService {
  final _logger = Logger(tag: 'Auth');
  
  Future<void> loginUser(String email, String password) async {
    _logger.info('🔐 User login attempt');
    
    // Log login attempt (without sensitive data)
    final loginData = {
      'email': email,
      'timestamp': DateTime.now().toIso8601String(),
      'ipAddress': '192.168.1.100',
      'userAgent': 'Flutter Web App',
    };
    _logger.jsonDebug(loginData, label: 'Login Attempt');
    
    try {
      final user = await authenticate(email, password);
      _logger.info('✅ User authenticated successfully');
      
      // Log user session
      final sessionInfo = {
        'userId': user.id,
        'sessionId': generateSessionId(),
        'expiresAt': DateTime.now().add(Duration(hours: 24)).toIso8601String(),
        'permissions': user.permissions,
      };
      _logger.jsonInfo(sessionInfo, label: 'User Session Created');
      
    } catch (e) {
      _logger.error('❌ Authentication failed: $e');
      rethrow;
    }
  }
}
```

### Error Handling with Context

```dart
class DataService {
  final _logger = Logger(tag: 'DataService');
  
  Future<void> processUserData(int userId) async {
    try {
      final userData = await fetchUserData(userId);
      await processData(userData);
      _logger.info('✅ User data processed successfully');
      
    } catch (e, stackTrace) {
      // Log comprehensive error information
      final errorContext = {
        'error': e.toString(),
        'type': e.runtimeType.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'context': {
          'operation': 'processUserData',
          'userId': userId,
          'retryCount': 2,
        },
        'stackTrace': stackTrace.toString().split('\n').take(5).toList(),
      };
      
      _logger.jsonError(errorContext, label: 'Data Processing Error');
      _logger.error('❌ Failed to process user data: ${e.toString()}');
      rethrow;
    }
  }
}
```

### Performance Monitoring

```dart
class PerformanceMonitor {
  final _logger = Logger(tag: 'Performance');
  
  void trackOperation(String operationName, Function operation) {
    final stopwatch = Stopwatch()..start();
    
    try {
      operation();
      stopwatch.stop();
      
      // Log successful operation
      final metrics = [
        {
          'operation': operationName,
          'duration': '${stopwatch.elapsedMilliseconds}ms',
          'status': 'success'
        },
      ];
      _logger.tableInfo(metrics, label: 'Operation Performance');
      
    } catch (e) {
      stopwatch.stop();
      
      // Log failed operation
      _logger.tableError([
        {
          'operation': operationName,
          'duration': '${stopwatch.elapsedMilliseconds}ms',
          'status': 'failed',
          'error': e.toString(),
        }
      ], label: 'Operation Failed');
      
      rethrow;
    }
  }
  
  void logMemoryUsage() {
    final memoryInfo = {
      'heapUsed': '45MB',
      'heapTotal': '128MB',
      'external': '12MB',
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    _logger.jsonInfo(memoryInfo, label: 'Memory Usage');
  }
}
```

## 🌐 Web Development Examples

### Flutter Web Analytics

```dart
class WebAnalytics {
  final _logger = Logger(tag: 'Analytics');
  
  void trackPageView(String pageName) {
    final pageData = {
      'event': 'page_view',
      'page': pageName,
      'timestamp': DateTime.now().toIso8601String(),
      'session': {
        'id': getSessionId(),
        'duration': getSessionDuration(),
      },
      'browser': {
        'userAgent': window.navigator.userAgent,
        'language': window.navigator.language,
        'viewport': {
          'width': window.innerWidth,
          'height': window.innerHeight,
        },
      },
    };
    
    _logger.jsonInfo(pageData, label: '📊 Page View Event');
  }
  
  void trackUserInteraction(String action, Map<String, dynamic> context) {
    final interactionData = {
      'event': 'user_interaction',
      'action': action,
      'context': context,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    _logger.jsonDebug(interactionData, label: '👤 User Interaction');
  }
}
```

### Web Performance Tracking

```dart
class WebPerformanceTracker {
  final _logger = Logger(tag: 'WebPerf');
  
  void logCoreWebVitals() {
    final vitals = [
      {'metric': 'First Contentful Paint', 'value': '1.2s', 'threshold': '1.8s'},
      {'metric': 'Largest Contentful Paint', 'value': '2.1s', 'threshold': '2.5s'},
      {'metric': 'First Input Delay', 'value': '45ms', 'threshold': '100ms'},
    ];
    
    _logger.tableInfo(vitals, label: '📈 Core Web Vitals');
  }
  
  void logResourceTiming() {
    final resources = [
      {'resource': 'main.dart.js', 'size': '2.1MB', 'loadTime': '850ms'},
      {'resource': 'flutter.js', 'size': '180KB', 'loadTime': '120ms'},
      {'resource': 'assets/logo.png', 'size': '12KB', 'loadTime': '35ms'},
    ];
    
    _logger.tableDebug(resources, label: '📦 Resource Loading');
  }
}
```

## 🎯 Environment-Specific Configuration

### Development vs Production

```dart
import 'package:flutter/foundation.dart';

void configureLogger() {
  if (kDebugMode) {
    // Development: Verbose logging
    LoggerOptions.instance.configure(
      minLogLevel: LogLevel.debug,
      enableColors: true,
      showLocation: true,
      includeTimestamp: true,
    );
  } else {
    // Production: Essential logging only
    LoggerOptions.instance.configure(
      minLogLevel: LogLevel.error,
      enableColors: false,
      showLocation: false,
      includeTimestamp: true,
      dateTimeFormat: 'yyyy-MM-dd HH:mm:ss',
    );
  }
}
```

### Platform-Specific Setup

```dart
void configurePlatformLogging() {
  if (kIsWeb) {
    // Web: Optimize for browser console
    LoggerOptions.instance.configure(
      enableColors: true,
      showFunctionName: true,
      includeTimestamp: true,
    );
  } else {
    // Mobile/Desktop: Optimize for IDE console
    LoggerOptions.instance.configure(
      enableColors: true,
      showLocation: true,
      messageTemplate: '[{timestamp}] {level} | {tag} | {message}',
    );
  }
}
```

## 🚀 Getting Started Checklist

1. **Add dependency** to `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter_logger_pro: ^0.0.1
   ```

2. **Import the package**:
   ```dart
   import 'package:flutter_logger_pro/flutter_logger_pro.dart';
   ```

3. **Create a logger**:
   ```dart
   final logger = Logger(tag: 'MyApp');
   ```

4. **Start logging**:
   ```dart
   logger.info('Hello, Flutter Logger Pro!');
   ```

5. **For web development**, run with:
   ```bash
   flutter run -d chrome
   # Open DevTools (F12) to see interactive logs!
   ```

## 💡 Pro Tips

- **Use meaningful tags** to identify different parts of your app
- **Leverage JSON logging** for complex objects and API responses
- **Use table logging** for structured data visualization
- **Configure globally** once, override per-instance when needed
- **Filter log levels** in production to reduce noise
- **Take advantage of web features** like interactive console objects

---

**🌐 Ready to enhance your Flutter Web development experience? Try these examples and see the difference!**