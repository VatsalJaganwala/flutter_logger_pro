/// A modern, web-first logging library for Dart and Flutter applications.
/// 
/// **🌐 Web-Optimized Features:**
/// - Interactive browser console with expandable JSON objects
/// - Native console.table() integration for data visualization
/// - Dual-output logging (browser console + IDE debug console)
/// - Platform-aware formatting and optimization
/// 
/// **🎨 Core Features:**
/// - Colored console output with ANSI escape codes
/// - Caller information (class name, function name, file location)
/// - Global configuration through LoggerOptions singleton
/// - Per-instance configuration overrides
/// - Advanced JSON and table logging capabilities
/// - Log level filtering and custom message formatting
/// 
/// ## 🌐 Web-First Usage
/// 
/// ```dart
/// import 'package:flutter_logger_pro/flutter_logger_pro.dart';
/// 
/// void main() {
///   // Configure for optimal web experience
///   LoggerOptions.instance.configure(
///     enableColors: true,
///     minLogLevel: LogLevel.debug,
///     includeTimestamp: true,
///   );
///   
///   final logger = Logger(tag: 'WebApp');
///   
///   // Interactive JSON logging - expandable in browser DevTools!
///   logger.json({
///     'user': {'id': 123, 'name': 'John'},
///     'session': {'duration': '45min'},
///     'analytics': {'pageViews': 12}
///   }, label: 'User Session');
///   
///   // Native table logging - uses console.table() in browser!
///   logger.table([
///     {'name': 'Alice', 'revenue': 299.99},
///     {'name': 'Bob', 'revenue': 149.99},
///   ], label: 'User Analytics');
/// }
/// ```
/// 
/// ## 📊 Advanced Logging
/// 
/// **JSON Logging Methods:**
/// - `json()` - Configurable level JSON logging
/// - `jsonDebug()`, `jsonInfo()`, `jsonWarn()`, `jsonError()` - Level-specific JSON logging
/// 
/// **Table Logging Methods:**
/// - `table()` - Configurable level table logging  
/// - `tableDebug()`, `tableInfo()`, `tableWarn()`, `tableError()` - Level-specific table logging
/// 
/// **Global Configuration:**
/// Use [LoggerOptions] to set application-wide defaults for logging behavior,
/// output formatting, colors, timestamps, and message templates.
/// Individual [Logger] instances can override global settings through constructor parameters.
/// 
/// ## 🌍 Platform Support
/// 
/// - **🌐 Flutter Web** (Primary): Interactive console, console.table(), dual output
/// - **📱 Flutter Mobile**: Full feature support with colored output
/// - **🖥️ Flutter Desktop**: Native console output with ASCII tables
/// - **⚙️ Dart Server**: Perfect for backend logging and monitoring
/// - **🔧 Dart CLI**: Command-line applications with colored output
library;

export 'src/logger.dart';
export 'src/log_level.dart';
export 'src/logger_options.dart';
export 'src/ansi_colors.dart';
