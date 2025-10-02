/// Utility class for formatting data into table format
class TableFormatter {
  /// Format data into a table structure similar to console.table
  static TableData formatTable(Object? data, List<String>? columns) {
    if (data == null) {
      return TableData(headers: ['(index)', 'Values'], rows: []);
    }

    if (data is List) {
      return _formatList(data, columns);
    } else if (data is Map) {
      return _formatMap(data, columns);
    } else {
      // Single value - treat as single row table
      return TableData(
        headers: ['(index)', 'Values'],
        rows: [
          ['0', _formatValue(data)],
        ],
      );
    }
  }

  /// Format a List into table structure
  static TableData _formatList(List data, List<String>? columns) {
    if (data.isEmpty) {
      return TableData(headers: ['(index)'], rows: []);
    }

    // Check if it's an array of objects (Maps)
    if (data.every((item) => item is Map)) {
      return _formatArrayOfObjects(data.cast<Map>(), columns);
    }

    // Check if it's an array of arrays
    if (data.every((item) => item is List)) {
      return _formatArrayOfArrays(data.cast<List>(), columns);
    }

    // Mixed array or array of primitives
    return _formatMixedArray(data, columns);
  }

  /// Format an array of objects (Maps)
  static TableData _formatArrayOfObjects(
    List<Map> data,
    List<String>? columns,
  ) {
    if (data.isEmpty) {
      return TableData(headers: ['(index)'], rows: []);
    }

    // Collect all unique keys from all objects
    final allKeys = <String>{};
    for (final obj in data) {
      allKeys.addAll(obj.keys.map((k) => k.toString()));
    }

    // Filter columns if specified
    final filteredKeys = columns != null
        ? allKeys.where((key) => columns.contains(key)).toList()
        : allKeys.toList();

    filteredKeys.sort(); // Sort for consistent output

    final headers = ['(index)', ...filteredKeys];
    final rows = <List<String>>[];

    for (int i = 0; i < data.length; i++) {
      final obj = data[i];
      final row = <String>[i.toString()];

      for (final key in filteredKeys) {
        final value = obj[key];
        row.add(_formatValue(value));
      }

      rows.add(row);
    }

    return TableData(headers: headers, rows: rows);
  }

  /// Format an array of arrays
  static TableData _formatArrayOfArrays(
    List<List> data,
    List<String>? columns,
  ) {
    if (data.isEmpty) {
      return TableData(headers: ['(index)'], rows: []);
    }

    // Find the maximum length to determine column count
    final maxLength = data
        .map((arr) => arr.length)
        .reduce((a, b) => a > b ? a : b);

    // Create numeric column headers
    final numericHeaders = List.generate(maxLength, (i) => i.toString());

    // Filter columns if specified (treat as indices)
    final filteredIndices = columns != null
        ? numericHeaders.where((header) => columns.contains(header)).toList()
        : numericHeaders;

    final headers = ['(index)', ...filteredIndices];
    final rows = <List<String>>[];

    for (int i = 0; i < data.length; i++) {
      final arr = data[i];
      final row = <String>[i.toString()];

      for (final indexStr in filteredIndices) {
        final index = int.tryParse(indexStr) ?? 0;
        final value = index < arr.length ? arr[index] : null;
        row.add(_formatValue(value));
      }

      rows.add(row);
    }

    return TableData(headers: headers, rows: rows);
  }

  /// Format a mixed array (primitives, objects, etc.)
  static TableData _formatMixedArray(List data, List<String>? columns) {
    final headers = ['(index)', 'Values'];
    final rows = <List<String>>[];

    for (int i = 0; i < data.length; i++) {
      rows.add([i.toString(), _formatValue(data[i])]);
    }

    return TableData(headers: headers, rows: rows);
  }

  /// Format a Map into table structure
  static TableData _formatMap(Map data, List<String>? columns) {
    if (data.isEmpty) {
      return TableData(headers: ['(index)', 'Values'], rows: []);
    }

    final keys = data.keys.map((k) => k.toString()).toList();

    // Filter keys if columns specified
    final filteredKeys = columns != null
        ? keys.where((key) => columns.contains(key)).toList()
        : keys;

    final headers = ['(index)', 'Values'];
    final rows = <List<String>>[];

    for (final key in filteredKeys) {
      final value = data[key];
      rows.add([key, _formatValue(value)]);
    }

    return TableData(headers: headers, rows: rows);
  }

  /// Format a value for display in table cell
  static String _formatValue(Object? value) {
    if (value == null) {
      return 'null';
    } else if (value is String) {
      return value;
    } else if (value is num || value is bool) {
      return value.toString();
    } else if (value is List) {
      // Convert array to comma-separated string
      return value.map((e) => e?.toString() ?? 'null').join(',');
    } else if (value is Map) {
      // Show as [object Object] to mimic console.table behavior
      return '[object Object]';
    } else {
      return value.toString();
    }
  }

  /// Generate ASCII table string from table data
  static String generateAsciiTable(
    TableData tableData, {
    bool enableColors = false,
  }) {
    if (tableData.rows.isEmpty) {
      return 'Empty table';
    }

    final headers = tableData.headers;
    final rows = tableData.rows;

    // Calculate column widths
    final columnWidths = <int>[];
    for (int i = 0; i < headers.length; i++) {
      int maxWidth = headers[i].length;
      for (final row in rows) {
        if (i < row.length) {
          maxWidth = maxWidth > row[i].length ? maxWidth : row[i].length;
        }
      }
      columnWidths.add(maxWidth + 2); // Add padding
    }

    final buffer = StringBuffer();

    // Top border
    buffer.write('┌');
    for (int i = 0; i < headers.length; i++) {
      buffer.write('─' * columnWidths[i]);
      if (i < headers.length - 1) {
        buffer.write('┬');
      }
    }
    buffer.writeln('┐');

    // Headers
    buffer.write('│');
    for (int i = 0; i < headers.length; i++) {
      final header = headers[i];
      final padding = columnWidths[i] - header.length;
      buffer.write(' $header${' ' * (padding - 1)}');
      buffer.write('│');
    }
    buffer.writeln();

    // Header separator
    buffer.write('├');
    for (int i = 0; i < headers.length; i++) {
      buffer.write('─' * columnWidths[i]);
      if (i < headers.length - 1) {
        buffer.write('┼');
      }
    }
    buffer.writeln('┤');

    // Data rows
    for (final row in rows) {
      buffer.write('│');
      for (int i = 0; i < headers.length; i++) {
        final cellValue = i < row.length ? row[i] : '';
        final padding = columnWidths[i] - cellValue.length;
        buffer.write(' $cellValue${' ' * (padding - 1)}');
        buffer.write('│');
      }
      buffer.writeln();
    }

    // Bottom border
    buffer.write('└');
    for (int i = 0; i < headers.length; i++) {
      buffer.write('─' * columnWidths[i]);
      if (i < headers.length - 1) {
        buffer.write('┴');
      }
    }
    buffer.write('┘');

    return buffer.toString();
  }
}

/// Data structure to hold table information
class TableData {
  final List<String> headers;
  final List<List<String>> rows;

  const TableData({required this.headers, required this.rows});
}
