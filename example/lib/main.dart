import 'package:flutter_logger_pro/flutter_logger_pro.dart';

/// 🌐 Logger Plus Web Demo
/// 
/// This example showcases Logger Plus's powerful web capabilities including:
/// - Interactive browser console JSON objects
/// - Native console.table() integration
/// - Dual-output logging (browser + IDE)
/// - Platform-optimized formatting
/// 
/// 🚀 Run this in Flutter Web to see the magic!
void main() {
  print('🌐 Logger Plus Web Demo Starting...');
  print('Open your browser\'s Developer Tools (F12) to see the enhanced web logging!');
  
  // Configure for optimal web experience
  LoggerOptions.instance.configure(
    enableLogging: true,
    enableColors: true,
    minLogLevel: LogLevel.debug,
    includeTimestamp: true,
    showFunctionName: true,
  );

  // Run all demos
  _demoBasicLogging();
  _demoWebJsonLogging();
  _demoWebTableLogging();
  _demoRealWorldExamples();
  
  print('\n✨ Demo complete! Check your browser console for interactive logs.');
}

/// Basic logging demonstration
void _demoBasicLogging() {
  final logger = Logger(tag: 'WEB_DEMO');
  
  logger.info('🎯 === Basic Web Logging Demo ===');
  logger.debug('Debug: Detailed information for developers');
  logger.info('Info: General application flow');
  logger.warn('Warning: Something needs attention');
  logger.error('Error: Something went wrong');
}

/// Web-optimized JSON logging demonstration
void _demoWebJsonLogging() {
  final logger = Logger(tag: 'JSON_WEB');
  
  logger.info('\n🔍 === Interactive JSON Logging (Web Optimized) ===');
  
  // Complex nested object - becomes interactive in browser console
  final userProfile = {
    'user': {
      'id': 12345,
      'name': 'Sarah Developer',
      'email': 'sarah@webdev.com',
      'preferences': {
        'theme': 'dark',
        'language': 'en',
        'notifications': {
          'email': true,
          'push': false,
          'sms': true
        }
      },
      'projects': [
        {
          'id': 'proj_001',
          'name': 'E-Commerce Platform',
          'status': 'active',
          'technologies': ['Flutter', 'Firebase', 'Stripe'],
          'team': ['Alice', 'Bob', 'Charlie']
        },
        {
          'id': 'proj_002', 
          'name': 'Mobile Banking App',
          'status': 'completed',
          'technologies': ['Flutter', 'AWS', 'Plaid'],
          'team': ['David', 'Eve']
        }
      ]
    },
    'session': {
      'id': 'sess_abc123',
      'startTime': DateTime.now().toIso8601String(),
      'device': 'Chrome 118.0 on macOS',
      'location': {'country': 'US', 'city': 'San Francisco'}
    }
  };
  
  // This creates an interactive, expandable object in browser console
  logger.jsonInfo(userProfile, label: '👤 User Profile (Click to expand in browser!)');
  
  // API response simulation
  final apiResponse = {
    'success': true,
    'data': {
      'users': List.generate(5, (i) => {
        'id': i + 1,
        'name': 'User ${i + 1}',
        'active': i % 2 == 0,
        'lastLogin': DateTime.now().subtract(Duration(days: i)).toIso8601String()
      }),
      'pagination': {
        'page': 1,
        'limit': 5,
        'total': 25,
        'hasNext': true
      }
    },
    'meta': {
      'requestId': 'req_${DateTime.now().millisecondsSinceEpoch}',
      'duration': '${150 + (DateTime.now().millisecond % 100)}ms',
      'cached': false
    }
  };
  
  logger.jsonInfo(apiResponse, label: '🌐 API Response');
  
  // Error logging with context
  final errorContext = {
    'error': {
      'type': 'ValidationError',
      'message': 'Invalid email format',
      'field': 'email',
      'value': 'invalid-email',
      'code': 'EMAIL_INVALID'
    },
    'request': {
      'method': 'POST',
      'url': '/api/users',
      'headers': {'Content-Type': 'application/json'},
      'body': {'name': 'John', 'email': 'invalid-email'}
    },
    'context': {
      'userId': null,
      'sessionId': 'sess_abc123',
      'timestamp': DateTime.now().toIso8601String(),
      'userAgent': 'Flutter Web App'
    }
  };
  
  logger.jsonError(errorContext, label: '❌ Validation Error');
}

/// Web-optimized table logging demonstration  
void _demoWebTableLogging() {
  final logger = Logger(tag: 'TABLE_WEB');
  
  logger.info('\n📊 === Interactive Table Logging (Web Optimized) ===');
  
  // User analytics data - perfect for console.table()
  final analyticsData = [
    {
      'userId': 1001,
      'name': 'Alice Johnson',
      'email': 'alice@example.com',
      'country': 'USA',
      'signupDate': '2024-01-15',
      'loginCount': 45,
      'revenue': 299.99,
      'plan': 'Premium'
    },
    {
      'userId': 1002,
      'name': 'Bob Smith', 
      'email': 'bob@example.com',
      'country': 'Canada',
      'signupDate': '2024-02-03',
      'loginCount': 23,
      'revenue': 0.0,
      'plan': 'Free'
    },
    {
      'userId': 1003,
      'name': 'Charlie Brown',
      'email': 'charlie@example.com', 
      'country': 'UK',
      'signupDate': '2024-01-28',
      'loginCount': 67,
      'revenue': 599.98,
      'plan': 'Enterprise'
    },
    {
      'userId': 1004,
      'name': 'Diana Prince',
      'email': 'diana@example.com',
      'country': 'Australia', 
      'signupDate': '2024-03-10',
      'loginCount': 12,
      'revenue': 149.99,
      'plan': 'Standard'
    }
  ];
  
  // Full table - interactive in browser console
  logger.tableInfo(analyticsData, label: '📈 User Analytics Dashboard');
  
  // Filtered columns - focus on key metrics
  logger.tableInfo(
    analyticsData, 
    columns: ['name', 'country', 'plan', 'revenue'],
    label: '💰 Revenue by User'
  );
  
  // Performance metrics table
  final performanceMetrics = [
    {'endpoint': '/api/users', 'avgResponseTime': '120ms', 'requests': 1250, 'errors': 3},
    {'endpoint': '/api/orders', 'avgResponseTime': '85ms', 'requests': 890, 'errors': 0},
    {'endpoint': '/api/products', 'avgResponseTime': '200ms', 'requests': 2100, 'errors': 12},
    {'endpoint': '/api/auth', 'avgResponseTime': '50ms', 'requests': 450, 'errors': 1},
  ];
  
  logger.tableWarn(performanceMetrics, label: '⚡ API Performance Metrics');
  
  // Error tracking table
  final errorLogs = [
    {
      'timestamp': '2024-10-02 14:30:15',
      'level': 'ERROR',
      'service': 'PaymentService',
      'message': 'Credit card declined',
      'userId': 1001,
      'amount': 299.99
    },
    {
      'timestamp': '2024-10-02 14:28:42', 
      'level': 'WARN',
      'service': 'AuthService',
      'message': 'Multiple login attempts',
      'userId': 1002,
      'amount': null
    },
    {
      'timestamp': '2024-10-02 14:25:33',
      'level': 'ERROR', 
      'service': 'DatabaseService',
      'message': 'Connection timeout',
      'userId': null,
      'amount': null
    }
  ];
  
  logger.tableError(errorLogs, label: '🚨 Recent Error Logs');
}

/// Real-world web development examples
void _demoRealWorldExamples() {
  logger.info('\n🛠️ === Real-World Web Development Examples ===');
  
  // Simulate a web app workflow
  _simulateWebAppWorkflow();
  _simulateApiDebugging();
  _simulatePerformanceMonitoring();
}

final logger = Logger(tag: 'WEB_APP');

/// Simulate typical web application workflow
void _simulateWebAppWorkflow() {
  logger.info('🚀 Starting web application...');
  
  // App initialization
  final initData = {
    'appVersion': '2.1.0',
    'buildNumber': '142',
    'environment': 'production',
    'features': {
      'darkMode': true,
      'analytics': true,
      'pushNotifications': false
    },
    'config': {
      'apiBaseUrl': 'https://api.myapp.com',
      'cdnUrl': 'https://cdn.myapp.com',
      'maxRetries': 3,
      'timeout': 30000
    }
  };
  
  logger.jsonInfo(initData, label: '⚙️ App Configuration');
  
  // User session start
  final sessionData = {
    'sessionId': 'sess_${DateTime.now().millisecondsSinceEpoch}',
    'userId': 12345,
    'deviceInfo': {
      'platform': 'web',
      'browser': 'Chrome',
      'version': '118.0.5993.88',
      'viewport': {'width': 1920, 'height': 1080},
      'touchSupport': false
    },
    'location': {
      'country': 'US',
      'region': 'CA', 
      'city': 'San Francisco',
      'timezone': 'America/Los_Angeles'
    }
  };
  
  logger.jsonInfo(sessionData, label: '👤 User Session Started');
}

/// Simulate API debugging scenario
void _simulateApiDebugging() {
  final apiLogger = Logger(tag: 'API_DEBUG');
  
  // API request logging
  final requestData = {
    'method': 'POST',
    'url': 'https://api.myapp.com/v1/orders',
    'headers': {
      'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...',
      'Content-Type': 'application/json',
      'X-Request-ID': 'req_abc123'
    },
    'body': {
      'items': [
        {'productId': 'prod_001', 'quantity': 2, 'price': 29.99},
        {'productId': 'prod_002', 'quantity': 1, 'price': 49.99}
      ],
      'shippingAddress': {
        'street': '123 Main St',
        'city': 'San Francisco',
        'state': 'CA',
        'zipCode': '94105'
      },
      'paymentMethod': 'card_1234'
    }
  };
  
  apiLogger.jsonDebug(requestData, label: '📤 Outgoing API Request');
  
  // Simulate API response
  final responseData = {
    'success': true,
    'data': {
      'orderId': 'ord_789xyz',
      'status': 'confirmed',
      'total': 109.97,
      'estimatedDelivery': '2024-10-05',
      'trackingNumber': 'TRK123456789'
    },
    'meta': {
      'requestId': 'req_abc123',
      'processingTime': '245ms',
      'rateLimit': {
        'remaining': 98,
        'resetTime': '2024-10-02T15:00:00Z'
      }
    }
  };
  
  apiLogger.jsonInfo(responseData, label: '📥 API Response');
  
  // Error scenario
  final errorResponse = {
    'success': false,
    'error': {
      'code': 'PAYMENT_DECLINED',
      'message': 'The payment method was declined',
      'details': {
        'paymentMethod': 'card_1234',
        'declineCode': 'insufficient_funds',
        'canRetry': true
      }
    },
    'meta': {
      'requestId': 'req_def456',
      'timestamp': DateTime.now().toIso8601String()
    }
  };
  
  apiLogger.jsonError(errorResponse, label: '❌ Payment Failed');
}

/// Simulate performance monitoring
void _simulatePerformanceMonitoring() {
  final perfLogger = Logger(tag: 'PERFORMANCE');
  
  // Page load metrics
  final pageMetrics = [
    {'metric': 'First Contentful Paint', 'value': '1.2s', 'threshold': '1.8s', 'status': 'good'},
    {'metric': 'Largest Contentful Paint', 'value': '2.1s', 'threshold': '2.5s', 'status': 'good'},
    {'metric': 'First Input Delay', 'value': '45ms', 'threshold': '100ms', 'status': 'good'},
    {'metric': 'Cumulative Layout Shift', 'value': '0.08', 'threshold': '0.1', 'status': 'good'},
  ];
  
  perfLogger.tableInfo(pageMetrics, label: '📊 Core Web Vitals');
  
  // Resource loading times
  final resourceMetrics = [
    {'resource': 'main.dart.js', 'size': '2.1MB', 'loadTime': '850ms', 'cached': false},
    {'resource': 'flutter.js', 'size': '180KB', 'loadTime': '120ms', 'cached': true},
    {'resource': 'assets/fonts/roboto.woff2', 'size': '45KB', 'loadTime': '80ms', 'cached': false},
    {'resource': 'assets/images/logo.png', 'size': '12KB', 'loadTime': '35ms', 'cached': true},
  ];
  
  perfLogger.tableDebug(resourceMetrics, label: '📦 Resource Loading Performance');
  
  // Memory usage tracking
  final memoryData = {
    'jsHeapSizeLimit': 4294705152,
    'totalJSHeapSize': 125829120,
    'usedJSHeapSize': 98234880,
    'memoryUsagePercent': 2.3,
    'timestamp': DateTime.now().toIso8601String()
  };
  
  perfLogger.jsonWarn(memoryData, label: '🧠 Memory Usage Stats');
}


  void demoTableLogger() {
    final tableLogger = Logger(tag: 'TABLE');

    // 1. Array of Objects (basic)
    final users = [
      {
        'id': 1,
        'name': 'Alice',
        'hobbies': ['Reading', 'Cycling'],
      },
      {
        'id': 2,
        'name': 'Bob',
        'hobbies': ['Running'],
      },
      {'id': 3, 'name': 'Charlie', 'age': 30, 'city': 'New York'},
    ];
    tableLogger.table(users, label: 'User Data');

    // 2. Single Object
    final config = {
      'brand': 'Tesla',
      'model': 'Model S',
      'year': 2023,
      'features': ['Autopilot', 'Supercharging'],
    };
    tableLogger.table(config, label: 'Car Configuration');

    // 3. Array of Arrays
    final matrix = [
      ['Name', 'Age', 'City'],
      ['Alice', 25, 'Boston'],
      ['Bob', 30, 'Seattle'],
      ['Charlie', 35, 'Denver'],
    ];
    tableLogger.table(matrix, label: 'Data Matrix');

    // 4. Column Filtering
    tableLogger.table(users, columns: ['name', 'id'], label: 'Filtered User Data');

    // 5. API Response (nested data)
    final apiResponse = [
      {
        'id': 101,
        'username': 'alice_dev',
        'email': 'alice@example.com',
        'roles': ['admin', 'editor'],
        'profile': {'age': 27, 'country': 'USA'},
      },
      {
        'id': 102,
        'username': 'bob_coder',
        'email': 'bob@example.com',
        'roles': ['viewer'],
        'profile': {'age': 32, 'country': 'Canada'},
      },
    ];
    tableLogger.table(apiResponse, label: 'API Response: Users');

    // 6. E-Commerce Orders (realistic dataset)
    final orders = [
      {
        'orderId': 'ORD123',
        'customer': 'John Doe',
        'items': ['Laptop', 'Mouse'],
        'total': 1299.99,
        'status': 'Shipped',
      },
      {
        'orderId': 'ORD124',
        'customer': 'Jane Smith',
        'items': ['Phone'],
        'total': 899.50,
        'status': 'Pending',
      },
      {
        'orderId': 'ORD125',
        'customer': 'Alice Brown',
        'items': ['Monitor', 'Keyboard', 'Speakers'],
        'total': 499.00,
        'status': 'Delivered',
      },
    ];
    tableLogger.table(orders, label: 'E-Commerce Orders');

    // 7. IoT Sensor Data (time-series with warnings)
    final sensors = List.generate(20, (i) {
      return {
        'timestamp': '2025-10-02 10:${(i * 5).toString().padLeft(2, '0')}:00',
        'temp': 20 + i * 0.5,
        'humidity': 40 + i,
        'status': (i % 7 == 0) ? 'Critical' : (i % 5 == 0 ? 'Warning' : 'OK'),
      };
    });
    tableLogger.tableWarn(sensors, label: 'IoT Sensor Data (20 rows)');

    // 8. Deeply Nested Project Data
    final deepNested = [
      {
        'id': 1,
        'project': 'Digital Twin',
        'team': [
          {
            'name': 'Alice',
            'tasks': [
              {'title': '3D Modeling', 'status': 'Done'},
              {'title': 'Mapping Integration', 'status': 'In Progress'},
            ],
          },
          {
            'name': 'Bob',
            'tasks': [
              {'title': 'API Development', 'status': 'Pending'},
            ],
          },
        ],
      },
    ];
    tableLogger.table(deepNested, label: 'Deeply Nested Project Data');

    // 9. Financial Transactions (edge cases: nulls, negatives, large numbers)
    final transactions = [
      {'txnId': 'TXN001', 'amount': 1000, 'currency': 'USD', 'status': 'Completed'},
      {'txnId': 'TXN002', 'amount': -250, 'currency': 'USD', 'status': 'Refunded'},
      {'txnId': 'TXN003', 'amount': null, 'currency': 'EUR', 'status': 'Failed'},
      {'txnId': 'TXN004', 'amount': 999999999, 'currency': 'JPY', 'status': 'Completed'},
    ];
    tableLogger.tableError(transactions, label: 'Financial Transactions');

    // 10. Large Dataset (simulate logs)
    final logs = List.generate(50, (i) {
      return {
        'timestamp': '2025-10-02 12:${(i % 60).toString().padLeft(2, '0')}:00',
        'level': (i % 3 == 0) ? 'INFO' : (i % 3 == 1 ? 'WARN' : 'ERROR'),
        'message': 'Log message number $i',
      };
    });
    tableLogger.table(logs, label: 'Application Logs (50 entries)');

    // 11. Mixed Data Types
    final mixedData = [
      'Simple string',
      42,
      true,
      null,
      {'nested': 'object'},
      [1, 2, 3],
    ];
    tableLogger.table(mixedData, label: 'Mixed Data Types');

    // 12. Empty Data
    tableLogger.table([], label: 'Empty Dataset');
    tableLogger.table({}, label: 'Empty Object');

    // === DEMONSTRATION: Large Dataset Table Logging ===

    final largeLogger = Logger(tag: 'LARGE_TABLE');

// Generate a large dataset with many rows and columns
    final List<Map<String, dynamic>> analyticsData = List.generate(50, (rowIndex) {
      return {
        'user_id': rowIndex + 1,
        'name': 'User_${rowIndex + 1}',
        'country': ['USA', 'India', 'UK', 'Germany', 'Canada', 'Australia'][rowIndex % 6],
        'age': 18 + (rowIndex % 50),
        'login_count': (rowIndex * 7) % 1000,
        'purchase_count': (rowIndex * 3) % 200,
        'avg_session_time': '${10 + (rowIndex % 120)} min',
        'last_login': '2025-09-${(rowIndex % 30) + 1} ${(rowIndex % 24).toString().padLeft(2, "0")}:00',
        'premium_member': rowIndex % 2 == 0,
        'device': ['Android', 'iOS', 'Web'][rowIndex % 3],
        'referrer': ['Google', 'Facebook', 'Twitter', 'LinkedIn', 'Email'][rowIndex % 5],
        'revenue': ((rowIndex * 123.45) % 5000).toStringAsFixed(2),
      };
    });

    largeLogger.table(analyticsData, label: 'User Analytics Dataset (50 rows, 12 cols)');

// Example with column filtering on a large dataset
    largeLogger.table(
      analyticsData,
      columns: ['user_id', 'name', 'country', 'revenue'],
      label: 'Filtered User Analytics (Essential Columns Only)',
    );

// Example warning table with a subset of large data
    largeLogger.tableWarn(
      analyticsData.where((row) => row['purchase_count'] > 150).toList(),
      label: 'High Purchase Users',
    );

// Example error table with invalid data
    final corruptedData = List.generate(10, (i) => {
      'id': i,
      'status': i % 3 == 0 ? null : 'OK',
      'error': i % 3 == 0 ? 'Data Missing' : '',
      'timestamp': '2025-10-${i + 1} 12:00'
    });

    largeLogger.tableError(corruptedData, label: 'Corrupted Records');
  }

