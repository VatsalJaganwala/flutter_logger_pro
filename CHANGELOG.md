# Changelog

All notable changes to Logger Plus will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2024-10-02

### 🌐 Web-First Release

Initial release of Logger Plus with a focus on **web development** and **browser console integration**.

### ✨ Added

#### Core Logging Features
- **Basic Logging**: Debug, Info, Warning, Error levels with colored output
- **Global Configuration**: Centralized settings via `LoggerOptions` singleton
- **Per-Instance Overrides**: Fine-tune individual loggers as needed
- **Custom Message Templates**: Design your own log message formats
- **Timestamp Support**: Configurable date/time formatting

#### 🌐 Web-Optimized Features
- **Interactive Browser Console**: JSON objects become expandable trees in DevTools
- **Native console.table()**: Automatic table formatting using browser's built-in API
- **Dual-Output Logging**: Simultaneous logging to browser console AND IDE debug console
- **Platform Detection**: Automatically adapts output format based on runtime environment
- **JavaScript Integration**: Direct object passing without JSON serialization overhead

#### 📊 Advanced JSON & Table Logging
- **JSON Logging Methods**: `json()`, `jsonDebug()`, `jsonInfo()`, `jsonWarn()`, `jsonError()`
- **Table Logging Methods**: `table()`, `tableDebug()`, `tableInfo()`, `tableWarn()`, `tableError()`
- **Multiple Data Formats**: Support for arrays of objects, single objects, arrays of arrays
- **Column Filtering**: Display only specific columns with `columns` parameter
- **Complex Object Support**: Handle deeply nested objects, arrays, and mixed data types
- **Fallback Handling**: Graceful degradation for non-serializable objects

#### 🎨 Smart Output Formatting
- **ANSI Color Support**: Color-coded log levels for instant visual recognition
- **Caller Information**: Automatic detection of function names and file locations
- **ASCII Tables**: Beautiful Unicode box-drawing characters for native platforms
- **Performance Optimized**: Lazy evaluation and efficient memory usage

#### 🌍 Platform Support
- **Flutter Web** (Primary Focus): Interactive console, console.table(), dual output
- **Flutter Mobile** (iOS/Android): Colors, JSON, ASCII tables, all features
- **Flutter Desktop** (Windows/macOS/Linux): Native console output, ASCII tables
- **Dart Server**: Perfect for backend logging, JSON output
- **Dart CLI**: Command-line applications, colored output

### 🔧 Configuration Options

#### LoggerOptions Properties
- `enableLogging`: Master switch for all logging
- `enableColors`: ANSI color codes in output
- `minLogLevel`: Minimum level to display (debug, info, warn, error)
- `showFunctionName`: Display function names in logs
- `showLocation`: Display file:line information
- `includeTimestamp`: Add timestamps to log messages
- `dateTimeFormat`: Customize timestamp format
- `messageTemplate`: Custom message format with variables

#### Logger Constructor Parameters
- `tag`: Identifier for the logger instance
- `enableLogging`: Override global logging setting
- `enableColors`: Override global color setting
- `showFunctionName`: Override function name display
- `showLocation`: Override location display

### 📚 Documentation & Examples

- **Comprehensive README**: Detailed usage guide with web-first examples
- **Web Demo Application**: Interactive example showcasing all features
- **Real-World Use Cases**: E-commerce, API debugging, performance monitoring
- **Platform-Specific Examples**: Web, mobile, desktop, and server scenarios
- **Best Practices Guide**: Performance tips and recommended patterns

### 🎯 Web Development Focus

This release prioritizes **web development** as the primary platform because:

- **Modern Development Workflow**: Most Flutter development happens in web browsers
- **Superior Developer Tools**: Browser DevTools provide the best debugging experience
- **Interactive Data Exploration**: Native browser console allows real-time object inspection
- **Performance Benefits**: Direct JavaScript object logging without serialization overhead
- **Seamless Integration**: Works perfectly with existing web development workflows

### 🚀 Getting Started

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

  // Interactive JSON logging - expandable in browser DevTools!
  logger.json({
    'user': {'id': 123, 'name': 'John'},
    'action': 'login',
    'timestamp': DateTime.now().toIso8601String()
  }, label: 'User Event');

  // Native table logging - uses console.table() in browser!
  logger.table([
    {'id': 1, 'name': 'Alice', 'country': 'USA'},
    {'id': 2, 'name': 'Bob', 'country': 'Canada'},
  ], label: 'User Data');
}
```

### 🔮 Future Plans

- Enhanced web performance monitoring integration
- Additional browser-specific debugging features
- Improved mobile and desktop platform optimizations
- Plugin system for custom formatters and outputs
- Integration with popular Flutter packages and frameworks

---

**🌐 Logger Plus - Built for the modern web-first Flutter development workflow!**