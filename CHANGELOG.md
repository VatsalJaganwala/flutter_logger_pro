# Changelog

All notable changes to Logger Plus will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.3]

### ✨ Added

#### LoggerOptions Static Methods & Individual Property Setters

- **Static Configuration Methods**: Added `LoggerOptions.configure()` and `LoggerOptions.reset()` static methods for cleaner API usage
- **Individual Property Setters**: Added static methods for updating specific configuration properties:
  - `LoggerOptions.setEnableLogging(bool)`
  - `LoggerOptions.setEnableColors(bool)`
  - `LoggerOptions.setMinLogLevel(LogLevel)`
  - `LoggerOptions.setShowFunctionName(bool)`
  - `LoggerOptions.setShowLocation(bool)`
  - `LoggerOptions.setIncludeTimestamp(bool)`
  - `LoggerOptions.setDateTimeFormat(String)`
  - `LoggerOptions.setMessageTemplate(String)`

#### Logger Instance Configuration Methods

- **Per-Instance Configuration**: Added `logger.configure()` method for updating multiple local settings at once
- **Per-Instance Reset**: Added `logger.reset()` method to reset logger to global defaults
- **Individual Instance Setters**: Added methods for updating specific logger instance properties:
  - `logger.setEnableLogging(bool)`
  - `logger.setEnableColors(bool)`
  - `logger.setShowFunctionName(bool)`
  - `logger.setShowLocation(bool)`

### 🔄 Changed

#### API Improvements

- **Simplified Global Configuration**: Users can now call `LoggerOptions.configure()` directly instead of `LoggerOptions.instance.configure()`
- **Granular Global Updates**: Individual property setters allow updating specific global settings without full reconfiguration
- **Per-Instance Configuration**: Logger instances now support local configuration that overrides global settings
- **Flexible Configuration Levels**: Three levels of configuration hierarchy: global defaults → constructor parameters → runtime instance methods
- **Backward Compatibility**: All existing instance methods remain functional for backward compatibility

### 📚 Documentation

- **Updated Examples**: All documentation examples now use the new static methods
- **API Reference**: Added comprehensive documentation for new static methods and individual property setters
- **Usage Patterns**: Added examples showing both bulk configuration and individual property updates

### 📦 Package Compatibility

#### Dart SDK Constraint Widening

- **Broader Compatibility**: Updated Dart SDK constraint from `^3.9.2` to `>3.3.0 <4.0.0`
- **Enhanced Accessibility**: Package now supports a wider range of Dart SDK versions
- **Future-Proof**: Ensures compatibility with upcoming Dart releases while maintaining stability

## [0.0.2] - 2024-10-02

### 🔧 Fixed

#### Pub.dev Analysis Improvements

- **Package Description**: Shortened description from 194 to 127 characters to meet pub.dev recommendations (60-180 characters)
- **Pub.dev Compliance**: Improved package metadata for better search engine visibility and pub.dev scoring

### 📦 Package Metadata

- Optimized description for search engines while maintaining key feature highlights
- Enhanced package discoverability on pub.dev

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
