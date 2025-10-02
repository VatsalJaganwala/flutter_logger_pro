# Flutter Logger Pro 📝

A modern, feature-rich logging library for Dart and Flutter applications that makes debugging and monitoring effortless. **Specially optimized for web development** with interactive browser console integration, Flutter Logger Pro provides intelligent formatting, global configuration, and advanced JSON logging capabilities.

## 🌐 **Web-First Design**

Flutter Logger Pro is built with **web development as the primary focus**, offering:

- **🔍 Interactive Browser Console**: JSON objects become expandable, clickable trees in Chrome/Firefox DevTools
- **📊 Native console.table()**: Automatic table formatting using browser's built-in console.table() 
- **🎯 Dual Output**: Logs appear in both browser console AND IDE debug console simultaneously
- **⚡ Zero Configuration**: Works perfectly out-of-the-box in Flutter Web projects
- **🛠️ Developer Tools Integration**: Seamless integration with browser developer tools

## 📋 Table of Contents

- [✨ Key Features](#-key-features)
- [🚀 Quick Start](#-quick-start)
- [📖 Usage Guide](#-usage-guide)
- [🔧 Advanced Features](#-advanced-features)
- [⚙️ Configuration Reference](#️-configuration-reference)
- [🚀 Performance & Best Practices](#-performance--best-practices)
- [🌍 Platform Support](#-platform-support)
- [📚 Examples & Use Cases](#-examples--use-cases)
- [🤝 Contributing](#-contributing)

## ✨ Key Features

### 🌐 **Web-Optimized Logging**

- **Interactive Browser Console**: JSON objects become expandable, explorable trees in DevTools
- **Native console.table()**: Automatic table formatting using browser's console.table() API
- **Dual Platform Output**: Simultaneous logging to browser console AND IDE debug console
- **Smart Platform Detection**: Automatically adapts output format based on runtime environment

### 🎨 **Smart Output Formatting**

- **Colored Console Output**: ANSI color-coded log levels for instant visual recognition
- **Caller Information**: Automatic detection of class names, function names, and file locations
- **Custom Templates**: Design your own log message formats
- **Timestamp Support**: Configurable date/time formatting

### 🌐 **Global Configuration System**

- **Centralized Settings**: Configure once, apply everywhere with LoggerOptions singleton
- **Per-Instance Overrides**: Fine-tune individual loggers when needed
- **Runtime Configuration**: Change settings dynamically during app execution
- **Environment-Aware**: Different settings for development, testing, and production

### 📊 **Advanced JSON & Table Logging**

- **🌐 Web-First JSON Logging**:
  - **Browser Console**: Interactive, expandable object trees with native JavaScript object inspection
  - **IDE Console**: Pretty-printed JSON with proper indentation for development
  - **Automatic Platform Detection**: Chooses optimal format based on runtime environment
- **🔥 Interactive Table Logging**:
  - **Native console.table()**: Uses browser's built-in table rendering for web
  - **Multiple Data Formats**: Arrays of objects, single objects, arrays of arrays
  - **Column Filtering**: Display only the columns you need with `columns` parameter
  - **ASCII Tables**: Beautiful Unicode box-drawing characters for native platforms
- **🚀 Advanced Features**:
  - **Complex Object Support**: Handle deeply nested objects, arrays, and mixed data types
  - **Fallback Handling**: Graceful degradation for non-serializable objects
  - **Performance Optimized**: Lazy evaluation and efficient memory usage

### ⚡ **Performance & Reliability**

- **Lazy Evaluation**: Expensive operations only when needed
- **Early Filtering**: Log level checks before message formatting
- **Memory Efficient**: Optimized string operations and minimal allocations
- **Cross-Platform**: Works seamlessly on mobile, web, desktop, and server

## 🚀 Quick Start

### Installation

Add Flutter Logger Pro to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_logger_pro: ^0.0.1
```

**For Flutter Web projects** (recommended):
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_logger_pro: ^0.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter
```

### Import and Use

```dart
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

void main() {
  final logger = Logger(tag: 'MyApp');
  logger.info('🎉 Flutter Logger Pro is ready!');
}
```

### 🌐 **30-Second Web Setup**

```dart
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

void main() {
  // Optional: Configure for optimal web experience
  LoggerOptions.instance.configure(
    enableColors: true,
    includeTimestamp: true,
    minLogLevel: LogLevel.debug,
  );

  final logger = Logger(tag: 'WebApp');

  // Basic logging - appears in browser console with appropriate styling
  logger.debug('🔧 Debug info for developers');
  logger.info('🚀 App started successfully');
  logger.warn('⚠️ This is a warning');
  logger.error('❌ Something went wrong');

  // 🔥 Interactive JSON logging - click to expand in browser DevTools!
  logger.json({
    'user': {'id': 123, 'name': 'John', 'preferences': {'theme': 'dark'}},
    'action': 'login',
    'timestamp': DateTime.now().toIso8601String()
  }, label: 'User Event');
  
  // 📊 Interactive table logging - uses native console.table() in browser!
  final users = [
    {'id': 1, 'name': 'Alice', 'age': 25, 'country': 'USA'},
    {'id': 2, 'name': 'Bob', 'age': 30, 'country': 'Canada'},
  ];
  logger.table(users, label: 'User List');
}
```

**🎯 Pro Tip**: Run this in Flutter Web and open your browser's Developer Tools (F12) to see the interactive logging in action!

## 📖 Usage Guide

### Basic Logging

```dart
import 'package:flutter_logger_pro/flutter_logger_pro.dart';

class UserService {
  final logger = Logger(tag: 'UserService');

  Future<User> loginUser(String email) async {
    logger.debug('Starting login process for: $email');

    try {
      final user = await authenticateUser(email);
      logger.info('User logged in successfully: ${user.name}');
      return user;
    } catch (e) {
      logger.error('Login failed: $e');
      rethrow;
    }
  }
}
```

**Output:**

```
[UserService][DEBUG] Starting login process for: john@example.com
[UserService][INFO] User logged in successfully: John Doe
```

### JSON Logging

Perfect for APIs, debugging complex objects, and data analysis:

```dart
class ApiService {
  final logger = Logger(tag: 'API');

  Future<void> handleRequest(Map<String, dynamic> request) async {
    // Log incoming request
    logger.jsonInfo(request, label: 'Incoming Request');

    try {
      final response = await processRequest(request);

      // Log successful response
      logger.jsonInfo(response, label: 'API Response');

    } catch (error) {
      // Log error details
      logger.jsonError({
        'error': error.toString(),
        'request': request,
        'timestamp': DateTime.now().toIso8601String(),
        'stackTrace': StackTrace.current.toString(),
      }, label: 'API Error');
    }
  }
}
```

**IDE Output:**

```
[API][INFO] Incoming Request:
{
  "userId": 12345,
  "action": "updateProfile",
  "data": {
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

**Browser Console:**
Interactive, collapsible object tree for easy exploration.

### Global Configuration

Set up once, benefit everywhere:

```dart
void main() {
  // Development configuration
  LoggerOptions.instance.configure(
    enableColors: true,
    minLogLevel: LogLevel.debug,
    includeTimestamp: true,
    dateTimeFormat: 'HH:mm:ss.SSS',
    // showClassName: true, // Hidden for future release
    showFunctionName: true,
    showLocation: true,  // Helpful for debugging
  );

  runApp(MyApp());
}

// Production configuration
void configureForProduction() {
  LoggerOptions.instance.configure(
    enableColors: false,        // No colors in production logs
    minLogLevel: LogLevel.warn, // Only warnings and errors
    includeTimestamp: true,
    dateTimeFormat: 'yyyy-MM-dd HH:mm:ss',
    showLocation: false,        // Cleaner production logs
  );
}
```

**Environment-Specific Setup:**

```dart
import 'package:flutter/foundation.dart';

void configureLogger() {
  if (kDebugMode) {
    // Development: Verbose logging
    LoggerOptions.instance.configure(
      minLogLevel: LogLevel.debug,
      showLocation: true,
    );
  } else {
    // Production: Essential logging only
    LoggerOptions.instance.configure(
      minLogLevel: LogLevel.error,
      showLocation: false,
    );
  }
}
```

### Per-Instance Overrides

Fine-tune individual loggers for specific needs:

```dart
import 'package:flutter/foundation.dart';

class MyApp {
  void setupLoggers() {
    // Global settings: minimal logging
    LoggerOptions.instance.configure(
      enableLogging: false,
      enableColors: false,
    );

    // Critical system logger: always enabled
    final systemLogger = Logger(
      tag: 'SYSTEM',
      enableLogging: true,
      enableColors: true,
    );

    // Debug logger: only for development
    final debugLogger = Logger(
      tag: 'DEBUG',
      enableLogging: kDebugMode,
      showLocation: true,
    );

    // Performance logger: custom formatting
    final perfLogger = Logger(
      tag: 'PERF',
      enableLogging: true,
      showFunctionName: true,
      // showClassName: false, // Hidden for future release
    );

    systemLogger.error('System error occurred');  // Always logs
    debugLogger.debug('Debug info');              // Only in debug mode
    perfLogger.info('Operation completed');       // Custom format
  }
}
```

## 🔧 Advanced Features

### Custom Message Templates

Create your own log format for consistency across your application:

```dart
// Slack-style format
LoggerOptions.instance.configure(
  includeTimestamp: true,
  messageTemplate: '[{timestamp}] {level} | {tag} | {message}',
);

// JSON-style format
LoggerOptions.instance.configure(
  messageTemplate: '{"time":"{timestamp}","level":"{level}","tag":"{tag}","msg":"{message}"}',
);

// Minimal format
LoggerOptions.instance.configure(
  messageTemplate: '{level}: {message}',
);

final logger = Logger(tag: 'CUSTOM');
logger.info('Custom formatted message');
```

### Dynamic Log Level Control

Perfect for production debugging:

```dart
class LogController {
  static void setLogLevel(String level) {
    switch (level.toLowerCase()) {
      case 'debug':
        LoggerOptions.instance.configure(minLogLevel: LogLevel.debug);
        break;
      case 'info':
        LoggerOptions.instance.configure(minLogLevel: LogLevel.info);
        break;
      case 'warn':
        LoggerOptions.instance.configure(minLogLevel: LogLevel.warn);
        break;
      case 'error':
        LoggerOptions.instance.configure(minLogLevel: LogLevel.error);
        break;
    }
  }

  static void enableDebugMode() {
    LoggerOptions.instance.configure(
      minLogLevel: LogLevel.debug,
      showLocation: true,
      enableColors: true,
    );
  }
}

// Usage in your app
LogController.setLogLevel('warn');  // Only warnings and errors
LogController.enableDebugMode();    // Full debug information
```

### Platform-Optimized JSON Logging

Logger Plus automatically adapts to your environment for the best debugging experience:

#### 🌐 **Browser Console** (Primary Platform)

**The magic happens in web browsers!** Logger Plus creates interactive, explorable object trees:

```dart
logger.json({
  'user': {'id': 123, 'name': 'John', 'preferences': {'theme': 'dark'}},
  'action': 'login',
  'metadata': {'timestamp': '2024-01-15T10:30:00Z'},
  'context': {
    'session': {'id': 'sess_123', 'duration': '45min'},
    'device': {'type': 'desktop', 'browser': 'Chrome'}
  }
}, label: 'User Event');
```

**Browser Console Result:**
- 🔍 **Interactive Object Tree**: Click to expand/collapse nested objects
- 🎯 **Native JavaScript Inspection**: Full browser DevTools integration
- 📊 **Syntax Highlighting**: Automatic color coding of different data types
- 🚀 **Performance**: No JSON serialization overhead for complex objects

#### 🖥️ **IDE/Native Environment**

Clean, formatted output for development and server applications:

**IDE Console Output:**
```
[API][INFO] User Event:
{
  "user": {
    "id": 123,
    "name": "John",
    "preferences": {
      "theme": "dark"
    }
  },
  "action": "login",
  "metadata": {
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

### 🌐 **Web Development Examples**

#### Flutter Web API Debugging

```dart
class WebApiService {
  final logger = Logger(tag: 'WEB_API');

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    final stopwatch = Stopwatch()..start();
    
    // 🔍 Interactive request logging - expandable in browser console
    logger.jsonDebug({
      'method': 'GET',
      'url': '/api/users/$userId',
      'headers': {'Authorization': 'Bearer ...'},
      'timestamp': DateTime.now().toIso8601String(),
    }, label: '📤 API Request');

    try {
      final response = await http.get(Uri.parse('/api/users/$userId'));
      
      // 🎯 Interactive response - click to explore in DevTools
      logger.jsonInfo({
        'status': response.statusCode,
        'headers': response.headers,
        'data': jsonDecode(response.body),
        'duration': '${stopwatch.elapsedMilliseconds}ms',
        'cached': response.headers['x-cache'] == 'HIT',
      }, label: '📥 API Response');

      return jsonDecode(response.body);
    } catch (e) {
      // 🚨 Error context with full debugging info
      logger.jsonError({
        'error': e.toString(),
        'url': '/api/users/$userId',
        'duration': '${stopwatch.elapsedMilliseconds}ms',
        'stackTrace': StackTrace.current.toString(),
        'userAgent': window.navigator.userAgent,
      }, label: '❌ API Error');
      rethrow;
    }
  }
}
```

#### Web Performance Monitoring

```dart
class WebPerformanceLogger {
  final logger = Logger(tag: 'PERF');

  void logPageLoad() {
    // 📊 Performance metrics table - uses console.table() in browser
    final metrics = [
      {'metric': 'First Contentful Paint', 'value': '1.2s', 'threshold': '1.8s'},
      {'metric': 'Largest Contentful Paint', 'value': '2.1s', 'threshold': '2.5s'},
      {'metric': 'First Input Delay', 'value': '45ms', 'threshold': '100ms'},
    ];
    
    logger.table(metrics, label: '📈 Core Web Vitals');
  }

  void logUserInteraction(String action, Map<String, dynamic> context) {
    // 🎯 Interactive user event logging
    logger.jsonInfo({
      'action': action,
      'context': context,
      'performance': {
        'memory': window.performance.memory?.toJson(),
        'navigation': window.performance.navigation?.toJson(),
        'timing': window.performance.timing?.toJson(),
      },
      'viewport': {
        'width': window.innerWidth,
        'height': window.innerHeight,
      }
    }, label: '👤 User Interaction');
  }
}
```

#### Real-World Web App Logging

```dart
class WebAppLogger {
  final logger = Logger(tag: 'WEB_APP');

  void logUserSession() {
    // 🌐 Complete web session context
    logger.jsonInfo({
      'session': {
        'id': generateSessionId(),
        'startTime': DateTime.now().toIso8601String(),
        'user': getCurrentUser()?.toJson(),
      },
      'browser': {
        'userAgent': window.navigator.userAgent,
        'language': window.navigator.language,
        'platform': window.navigator.platform,
        'cookieEnabled': window.navigator.cookieEnabled,
      },
      'screen': {
        'width': window.screen?.width,
        'height': window.screen?.height,
        'colorDepth': window.screen?.colorDepth,
      },
      'features': {
        'localStorage': _hasLocalStorage(),
        'sessionStorage': _hasSessionStorage(),
        'webGL': _hasWebGL(),
      }
    }, label: '🚀 Web Session Started');
  }
}
```

## ⚙️ Configuration Reference

### LoggerOptions Properties

| Property           | Type        | Default      | Description                   | Example                       |
| ------------------ | ----------- | ------------ | ----------------------------- | ----------------------------- |
| `enableLogging`    | `bool?`     | `true`       | Master switch for all logging | `false` to disable all logs   |
| `enableColors`     | `bool?`     | `true`       | ANSI color codes in output    | `false` for plain text        |
| `minLogLevel`      | `LogLevel?` | `debug`      | Minimum level to display      | `LogLevel.warn` for warnings+ |
| `showFunctionName` | `bool?`     | `true`       | Display function names        | `[myFunction][TAG][INFO]`     |
| `showLocation`     | `bool?`     | `true`       | Display file:line info        | `main.dart:42`                |
| `includeTimestamp` | `bool?`     | `false`      | Add timestamps                | `[14:30:25][TAG][INFO]`       |
| `dateTimeFormat`   | `String?`   | `'HH:mm:ss'` | Timestamp format              | `'yyyy-MM-dd HH:mm:ss'`       |
| `messageTemplate`  | `String?`   | `null`       | Custom message format         | `'{level}: {message}'`        |

### Logger Constructor Parameters

| Parameter          | Type      | Description                    | Use Case                        |
| ------------------ | --------- | ------------------------------ | ------------------------------- |
| `tag`              | `String?` | Identifier for this logger     | `'API'`, `'Database'`, `'Auth'` |
| `enableLogging`    | `bool?`   | Override global logging        | Critical loggers always on      |
| `enableColors`     | `bool?`   | Override global colors         | Specific logger styling         |
| `showFunctionName` | `bool?`   | Override function name display | Debug-specific loggers          |
| `showLocation`     | `bool?`   | Override location display      | Production vs development       |

### JSON Logging API

| Method                         | Level        | Description              | Best For                     |
| ------------------------------ | ------------ | ------------------------ | ---------------------------- |
| `json(object, {level, label})` | Configurable | Main JSON logging method | Custom log levels            |
| `jsonDebug(object, {label})`   | Debug        | Development debugging    | Complex object inspection    |
| `jsonInfo(object, {label})`    | Info         | General information      | API responses, state changes |
| `jsonWarn(object, {label})`    | Warning      | Potential issues         | Deprecated usage, fallbacks  |
| `jsonError(object, {label})`   | Error        | Error conditions         | Exception details, failures  |

### Table Logging API

Logger Plus includes powerful table formatting capabilities similar to `console.table` in JavaScript, perfect for displaying structured data in a readable format.

| Method                                    | Level        | Description                    | Best For                        |
| ----------------------------------------- | ------------ | ------------------------------ | ------------------------------- |
| `table(data, {columns, level, label})`   | Configurable | Main table logging method      | Custom log levels               |
| `tableDebug(data, {columns, label})`     | Debug        | Development debugging          | Data structure inspection       |
| `tableInfo(data, {columns, label})`      | Info         | General information            | API responses, configuration    |
| `tableWarn(data, {columns, label})`      | Warning      | Potential issues               | Performance metrics, warnings   |
| `tableError(data, {columns, label})`     | Error        | Error conditions               | Error logs, failed operations   |

#### Supported Data Formats

**Array of Objects** - Each object becomes a row with keys as column headers:
```dart
final users = [
  {'id': 1, 'name': 'Alice', 'hobbies': ['Reading', 'Cycling']},
  {'id': 2, 'name': 'Bob', 'hobbies': ['Running']},
];
logger.table(users, label: 'User Data');
```

**Single Object** - Keys become row indices, values in a "Values" column:
```dart
final config = {'brand': 'Tesla', 'model': 'S', 'year': 2023};
logger.table(config, label: 'Car Configuration');
```

**Array of Arrays** - Each inner array is a row with numeric column headers:
```dart
final matrix = [
  ['Name', 'Age', 'City'],
  ['Alice', 25, 'Boston'],
  ['Bob', 30, 'Seattle'],
];
logger.table(matrix, label: 'Data Matrix');
```

**Column Filtering** - Display only specific columns:
```dart
logger.table(users, columns: ['name', 'id'], label: 'Filtered Data');
```

#### Platform-Specific Behavior

- **Native/IDE**: Generates clean ASCII tables with Unicode box-drawing characters
- **Web Browser**: Uses native `console.table()` for interactive, expandable tables when possible, falls back to ASCII format

### Message Template Variables

| Variable         | Description        | Example Output   |
| ---------------- | ------------------ | ---------------- |
| `{timestamp}`    | Current timestamp  | `14:30:25`       |
| `{level}`        | Log level name     | `INFO`, `ERROR`  |
| `{message}`      | The log message    | `User logged in` |
| `{className}`    | Calling class name | `UserService`    |
| `{tag}`          | Logger tag         | `API`            |
| `{functionName}` | Calling function   | `loginUser`      |
| `{location}`     | File location      | `main.dart:42`   |

## 🚀 Performance & Best Practices

### Performance Optimizations

Logger Plus is built for production use with several performance optimizations:

```dart
// ✅ Good: Early filtering prevents expensive operations
LoggerOptions.instance.configure(minLogLevel: LogLevel.warn);
logger.debug('This expensive ${computeExpensiveValue()}'); // Never computed

// ✅ Good: Lazy evaluation
logger.info('User count: ${users.length}'); // Only computed if logging enabled

// ✅ Good: Efficient singleton pattern
final logger1 = Logger(tag: 'Service1'); // Fast
final logger2 = Logger(tag: 'Service2'); // Fast
```

### Best Practices

#### 1. **Use Appropriate Log Levels**

```dart
logger.debug('Variable value: $variable');        // Development only
logger.info('User logged in: ${user.email}');     // Important events
logger.warn('API rate limit approaching');        // Potential issues
logger.error('Database connection failed: $e');   // Critical problems
```

#### 2. **Leverage Global Configuration**

```dart
import 'package:flutter/foundation.dart';

// Configure once at app startup
void configureLogging() {
  if (kReleaseMode) {
    LoggerOptions.instance.configure(
      minLogLevel: LogLevel.warn,  // Production: warnings and errors only
      enableColors: false,         // No colors in production logs
      showLocation: false,         // Cleaner production output
    );
  } else {
    LoggerOptions.instance.configure(
      minLogLevel: LogLevel.debug, // Development: all logs
      showLocation: true,          // Helpful for debugging
    );
  }
}
```

#### 3. **Use Meaningful Tags**

```dart
// ✅ Good: Descriptive tags
final authLogger = Logger(tag: 'Auth');
final dbLogger = Logger(tag: 'Database');
final apiLogger = Logger(tag: 'API');

// ❌ Avoid: Generic or unclear tags
final logger = Logger(tag: 'Log');
final myLogger = Logger(tag: 'MyClass');
```

## 🌍 Platform Support

| Platform                            | Status              | Features                                    |
| ----------------------------------- | ------------------- | ------------------------------------------- |
| **🌐 Flutter Web**                  | ⭐ **Primary Focus** | Interactive console, console.table(), dual output |
| **Flutter Mobile** (iOS/Android)    | ✅ Full Support     | Colors, JSON, ASCII tables, all features   |
| **Flutter Desktop** (Win/Mac/Linux) | ✅ Full Support     | Native console output, ASCII tables        |
| **Dart Server**                     | ✅ Full Support     | Perfect for backend logging, JSON output   |
| **Dart CLI**                        | ✅ Full Support     | Command-line applications, colored output   |

### 🌐 **Why Web-First?**

Logger Plus is designed with **web development as the primary platform** because:

- **🔥 Modern Development**: Most Flutter development happens in web browsers during development
- **🛠️ Superior DevTools**: Browser developer tools provide the best debugging experience
- **📊 Interactive Data**: Native browser console allows real-time object exploration
- **⚡ Performance**: Direct JavaScript object logging without serialization overhead
- **🎯 Developer Experience**: Seamless integration with existing web development workflows

## 📚 Examples & Use Cases

### 🌐 **Web-First Examples**

#### Flutter Web E-Commerce App

```dart
class WebECommerceLogger {
  final _logger = Logger(tag: 'E_COMMERCE');

  void logProductView(Product product) {
    // 🛍️ Interactive product data - expandable in browser DevTools
    _logger.jsonInfo({
      'event': 'product_view',
      'product': {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'category': product.category,
        'inStock': product.inventory > 0,
      },
      'user': getCurrentUser()?.toAnalyticsJson(),
      'session': {
        'id': getSessionId(),
        'pageViews': getPageViewCount(),
        'timeOnSite': getTimeOnSite(),
      },
      'context': {
        'referrer': window.document.referrer,
        'url': window.location.href,
        'timestamp': DateTime.now().toIso8601String(),
      }
    }, label: '👁️ Product View Event');
  }

  void logPurchaseFlow(List<CartItem> items) {
    // 📊 Purchase analytics table - uses console.table() in browser
    final purchaseData = items.map((item) => {
      'productId': item.product.id,
      'name': item.product.name,
      'quantity': item.quantity,
      'unitPrice': item.product.price,
      'totalPrice': item.quantity * item.product.price,
      'category': item.product.category,
    }).toList();

    _logger.table(purchaseData, label: '🛒 Purchase Items');
    
    // 💰 Purchase summary
    _logger.jsonInfo({
      'event': 'purchase_initiated',
      'summary': {
        'itemCount': items.length,
        'totalValue': items.fold(0.0, (sum, item) => sum + (item.quantity * item.product.price)),
        'categories': items.map((item) => item.product.category).toSet().toList(),
      },
      'paymentMethod': getSelectedPaymentMethod(),
      'shippingAddress': getShippingAddress()?.toJson(),
    }, label: '💳 Purchase Summary');
  }
}
```

#### Web Analytics & User Behavior

```dart
class WebAnalyticsLogger {
  final _logger = Logger(tag: 'ANALYTICS');

  void logUserJourney() {
    // 🗺️ User journey tracking with interactive timeline
    final journeyData = getUserJourneySteps().map((step) => {
      'timestamp': step.timestamp.toIso8601String(),
      'page': step.pageName,
      'action': step.action,
      'duration': '${step.duration.inSeconds}s',
      'exitIntent': step.hasExitIntent,
    }).toList();

    _logger.table(journeyData, 
      columns: ['timestamp', 'page', 'action', 'duration'],
      label: '🗺️ User Journey'
    );
  }

  void logPerformanceMetrics() {
    // ⚡ Real-time performance monitoring
    _logger.jsonWarn({
      'performance': {
        'loadTime': getPageLoadTime(),
        'renderTime': getRenderTime(),
        'interactiveTime': getTimeToInteractive(),
        'memoryUsage': getMemoryUsage(),
      },
      'vitals': {
        'fcp': getFirstContentfulPaint(),
        'lcp': getLargestContentfulPaint(),
        'fid': getFirstInputDelay(),
        'cls': getCumulativeLayoutShift(),
      },
      'resources': getResourceTimings().map((r) => {
        'name': r.name,
        'duration': '${r.duration}ms',
        'size': '${r.transferSize} bytes',
      }).toList(),
    }, label: '📊 Performance Metrics');
  }
}
```

#### Web API Integration Debugging

```dart
class WebApiDebugger {
  final _logger = Logger(tag: 'API_DEBUG');

  Future<void> debugApiCall(String endpoint, Map<String, dynamic> payload) async {
    final requestId = generateRequestId();
    final stopwatch = Stopwatch()..start();

    // 📤 Request logging with full context
    _logger.jsonDebug({
      'requestId': requestId,
      'endpoint': endpoint,
      'method': 'POST',
      'headers': {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${getAuthToken()}',
        'X-Request-ID': requestId,
      },
      'payload': payload,
      'browser': {
        'userAgent': window.navigator.userAgent,
        'language': window.navigator.language,
      },
      'network': {
        'connection': getNetworkInfo(),
        'online': window.navigator.onLine,
      }
    }, label: '📤 API Request Debug');

    try {
      final response = await makeApiCall(endpoint, payload);
      
      // 📥 Success response with performance data
      _logger.jsonInfo({
        'requestId': requestId,
        'status': response.statusCode,
        'headers': response.headers,
        'data': response.data,
        'performance': {
          'duration': '${stopwatch.elapsedMilliseconds}ms',
          'size': '${response.data.toString().length} chars',
          'cached': response.headers['x-cache-status'],
        },
        'rateLimit': {
          'remaining': response.headers['x-ratelimit-remaining'],
          'reset': response.headers['x-ratelimit-reset'],
        }
      }, label: '✅ API Success');

    } catch (error) {
      // 🚨 Comprehensive error logging
      _logger.jsonError({
        'requestId': requestId,
        'error': {
          'type': error.runtimeType.toString(),
          'message': error.toString(),
          'statusCode': error.statusCode,
        },
        'context': {
          'endpoint': endpoint,
          'payload': payload,
          'duration': '${stopwatch.elapsedMilliseconds}ms',
          'retryCount': getRetryCount(requestId),
        },
        'debugging': {
          'stackTrace': StackTrace.current.toString(),
          'timestamp': DateTime.now().toIso8601String(),
          'sessionId': getSessionId(),
        }
      }, label: '❌ API Error Debug');
      
      rethrow;
    }
  }
}
```

### 🖥️ **Cross-Platform Examples**

#### Service Layer Logging

```dart
class UserService {
  final _logger = Logger(tag: 'UserService');

  Future<User> getUser(String id) async {
    _logger.debug('Fetching user: $id');

    try {
      final user = await userRepository.findById(id);
      _logger.info('User retrieved: ${user.email}');
      return user;
    } catch (e) {
      _logger.error('Failed to get user $id: $e');
      rethrow;
    }
  }
}
```

#### State Management Debugging

```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final _logger = Logger(tag: 'CounterBloc');

  @override
  void onTransition(Transition<CounterEvent, CounterState> transition) {
    _logger.jsonDebug({
      'event': transition.event.runtimeType.toString(),
      'currentState': transition.currentState.value,
      'nextState': transition.nextState.value,
    }, label: 'State Transition');

    super.onTransition(transition);
  }
}
```

## 🌐 **Web-Specific Features**

### Browser Console Integration

Logger Plus provides seamless integration with browser developer tools:

```dart
// 🔍 Interactive object exploration
logger.json(complexApiResponse, label: 'API Data');
// Result: Expandable object tree in browser console

// 📊 Native table rendering  
logger.table(userAnalytics, label: 'User Metrics');
// Result: Native console.table() with sortable columns

// 🎯 Dual output logging
logger.info('Processing user data...');
// Result: Appears in BOTH browser console AND IDE debug console
```

### Web Performance Monitoring

Built-in support for web performance APIs:

```dart
class WebPerformanceLogger {
  final logger = Logger(tag: 'PERF');

  void logWebVitals() {
    logger.table([
      {'metric': 'FCP', 'value': '${performance.getEntriesByName('first-contentful-paint').first.startTime}ms'},
      {'metric': 'LCP', 'value': '${getLargestContentfulPaint()}ms'},
      {'metric': 'FID', 'value': '${getFirstInputDelay()}ms'},
    ], label: 'Core Web Vitals');
  }
}
```

### Browser-Specific Debugging

```dart
// 🌐 Browser environment detection
logger.jsonInfo({
  'browser': window.navigator.userAgent,
  'viewport': {'width': window.innerWidth, 'height': window.innerHeight},
  'connection': navigator.connection?.effectiveType,
  'memory': performance.memory?.usedJSHeapSize,
}, label: 'Browser Context');
```

## 🚀 **Getting Started with Web Development**

### Quick Web Setup

1. **Create a new Flutter Web project**:
   ```bash
   flutter create my_web_app
   cd my_web_app
   ```

2. **Add Flutter Logger Pro**:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutter_logger_pro: ^0.0.1
   ```

3. **Start logging**:
   ```dart
   import 'package:flutter_logger_pro/flutter_logger_pro.dart';
   
   void main() {
     final logger = Logger(tag: 'WebApp');
     logger.info('🌐 Web app started!');
     runApp(MyApp());
   }
   ```

4. **Run and debug**:
   ```bash
   flutter run -d chrome
   # Open DevTools (F12) to see interactive logs!
   ```

### Web Development Workflow

1. **🔧 Development**: Use `logger.debug()` and `logger.json()` for detailed debugging
2. **🧪 Testing**: Use `logger.table()` to visualize test data and results  
3. **📊 Monitoring**: Use `logger.jsonInfo()` for performance and analytics tracking
4. **🚨 Error Handling**: Use `logger.jsonError()` for comprehensive error context

## 🤝 Contributing

We welcome contributions! Here's how you can help:

- 🐛 **Report bugs** by opening an issue
- 💡 **Suggest features** for new functionality  
- 📖 **Improve documentation** with better examples
- 🔧 **Submit pull requests** for bug fixes or features
- 🌐 **Web-specific improvements** are especially welcome!

### Development Setup

```bash
git clone https://github.com/VatsalJaganwala/flutter_logger_pro.git
cd flutter_logger_pro
dart pub get
dart test

# For web-specific testing
flutter run -d chrome example/
```

### Testing Web Features

```bash
# Run the web example to test browser console integration
cd example
flutter run -d chrome

# Open browser DevTools (F12) to see:
# - Interactive JSON objects
# - Native console.table() rendering
# - Dual-output logging
```


## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🚀 **Quick Web Deployment**

Ready to deploy your Flutter Web app with Logger Plus? Here's how:

### Production Configuration

```dart
import 'package:flutter/foundation.dart';

void configureProductionLogging() {
  if (kReleaseMode) {
    // Production: Essential logging only
    LoggerOptions.instance.configure(
      minLogLevel: LogLevel.warn,  // Only warnings and errors
      enableColors: false,         // No colors in production
      showLocation: false,         // Cleaner production logs
      includeTimestamp: true,      // Keep timestamps for debugging
    );
  } else {
    // Development: Full interactive logging
    LoggerOptions.instance.configure(
      minLogLevel: LogLevel.debug,
      enableColors: true,
      showLocation: true,
      includeTimestamp: true,
    );
  }
}
```

### Build and Deploy

```bash
# Build for web with optimizations
flutter build web --release

# Deploy to your favorite hosting platform
# - Firebase Hosting
# - Netlify  
# - Vercel
# - GitHub Pages
# - Your own server
```

## 🎯 **Why Choose Logger Plus?**

### ✅ **Perfect for Web Development**
- **Interactive Debugging**: Click and explore objects in browser DevTools
- **Native Integration**: Uses browser's console.table() and object inspection
- **Dual Output**: See logs in both browser and IDE simultaneously
- **Zero Config**: Works perfectly out-of-the-box

### ✅ **Production Ready**
- **Performance Optimized**: Lazy evaluation and minimal overhead
- **Configurable**: Fine-tune logging for different environments
- **Cross-Platform**: Same API works on web, mobile, desktop, and server
- **Reliable**: Comprehensive error handling and fallbacks

### ✅ **Developer Experience**
- **Intuitive API**: Simple, consistent methods across all platforms
- **Rich Documentation**: Comprehensive examples and use cases
- **Active Development**: Regular updates and improvements
- **Community Driven**: Open source with welcoming contribution guidelines

---

**🌐 Made with ❤️ for the modern web-first Flutter development community**

*Logger Plus - Where logging meets the web! 🚀*
#   l o g g e r _ p l u s 
 
 
#   f l u t t e r _ l o g g e r _ p r o  
 