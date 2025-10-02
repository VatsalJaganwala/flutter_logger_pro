# Logger Plus Web Demo 🌐

This example showcases Logger Plus's powerful **web-first** capabilities, demonstrating why it's the perfect logging solution for Flutter Web development.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/VatsalJaganwala/flutter_logger_pro.git
cd flutter_logger_pro/example

# Install dependencies
flutter pub get

# Run the web demo
flutter run -d chrome
```

## 🔍 What You'll See

### 1. **Interactive Browser Console Logging**
- Open your browser's Developer Tools (F12)
- See JSON objects as expandable, clickable trees
- Explore nested data structures with native browser tools

### 2. **Native console.table() Integration**
- Tables automatically use browser's built-in console.table()
- Sortable columns and interactive data exploration
- Perfect for debugging API responses and analytics data

### 3. **Dual-Output Logging**
- Logs appear in BOTH browser console AND IDE debug console
- Optimal experience for both development and debugging
- No configuration needed - works automatically

## 🌟 Key Features Demonstrated

### 📊 **Interactive JSON Logging**
```dart
// Creates expandable object tree in browser DevTools
logger.jsonInfo({
  'user': {'id': 123, 'preferences': {'theme': 'dark'}},
  'session': {'duration': '45min', 'pages': 12},
  'analytics': {'clicks': 89, 'scrollDepth': 0.75}
}, label: 'User Session Data');
```

### 🔥 **Native Table Rendering**
```dart
// Uses browser's console.table() for interactive tables
logger.table([
  {'name': 'Alice', 'revenue': 299.99, 'country': 'USA'},
  {'name': 'Bob', 'revenue': 149.99, 'country': 'Canada'},
], label: 'User Analytics');
```

### ⚡ **Performance Monitoring**
```dart
// Real-time web performance tracking
logger.table([
  {'metric': 'First Contentful Paint', 'value': '1.2s'},
  {'metric': 'Largest Contentful Paint', 'value': '2.1s'},
], label: 'Core Web Vitals');
```

## 🎯 Web Development Use Cases

This demo shows real-world scenarios:

- **E-Commerce Analytics**: Product views, purchase tracking, user behavior
- **API Debugging**: Request/response logging with full context
- **Performance Monitoring**: Core Web Vitals, resource loading, memory usage
- **User Session Tracking**: Login flows, navigation patterns, error handling

## 🛠️ Development Tips

1. **Always open DevTools**: The magic happens in the browser console
2. **Use JSON logging**: Perfect for complex objects and API responses  
3. **Leverage table logging**: Great for analytics data and performance metrics
4. **Check both consoles**: Browser for interaction, IDE for development

## 📱 Try Other Platforms

While this demo focuses on web, Logger Plus works everywhere:

```bash
# Mobile
flutter run -d android
flutter run -d ios

# Desktop  
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

## 🌐 Why Web-First?

Logger Plus prioritizes web development because:

- **Modern workflow**: Most Flutter development happens in browsers
- **Superior tools**: Browser DevTools provide the best debugging experience
- **Interactive data**: Native object exploration without serialization
- **Performance**: Direct JavaScript integration for optimal speed

---

**🎉 Enjoy exploring Logger Plus's web capabilities!**

Open those DevTools and see the difference interactive logging makes! 🚀