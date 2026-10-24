import 'package:shared_preferences/shared_preferences.dart';

class NotificationReadStore {
  static const _seenKey = 'backend_notifications.seen_keys';

  List<String> keys(Map<String, dynamic> data) {
    final result = <String>{};
    for (final row in _list(data['payments'])) {
      result.add(
        'payment:${row['receipt'] ?? row['id'] ?? ''}:${row['paid_at'] ?? ''}',
      );
    }
    final records = data['records'] as Map? ?? const {};
    for (final row in _list(records['pre-invoices'])) {
      result.add(
        'invoice:${row['id'] ?? row['invoice_no'] ?? ''}:${row['updated_at'] ?? row['released_at'] ?? ''}',
      );
    }
    for (final row in _list(records['setting-announcement'])) {
      result.add(
        'school:${row['id'] ?? row['Title'] ?? ''}:${row['updated_at'] ?? row['UpdatedAt'] ?? row['created_at'] ?? ''}',
      );
    }
    result.removeWhere((key) => key.endsWith('::'));
    return result.toList();
  }

  Future<int> unreadCount(Map<String, dynamic> data) async {
    final preferences = await SharedPreferences.getInstance();
    final seen = (preferences.getStringList(_seenKey) ?? const []).toSet();
    return keys(data).where((key) => !seen.contains(key)).length;
  }

  Future<Set<String>> unreadKeys(Map<String, dynamic> data) async {
    final preferences = await SharedPreferences.getInstance();
    final seen = (preferences.getStringList(_seenKey) ?? const []).toSet();
    return keys(data).where((key) => !seen.contains(key)).toSet();
  }

  Future<void> markRead(String key) async {
    if (key.isEmpty) return;
    final preferences = await SharedPreferences.getInstance();
    final seen = (preferences.getStringList(_seenKey) ?? const []).toSet();
    seen.add(key);
    await preferences.setStringList(_seenKey, seen.toList());
  }

  String itemKey(Map<String, dynamic> row, String type) {
    if (type == 'payment') {
      return 'payment:${row['receipt'] ?? row['id'] ?? ''}:${row['paid_at'] ?? ''}';
    }
    if (type == 'invoice') {
      return 'invoice:${row['id'] ?? row['invoice_no'] ?? ''}:${row['updated_at'] ?? row['released_at'] ?? ''}';
    }
    return 'school:${row['id'] ?? row['Title'] ?? ''}:${row['updated_at'] ?? row['UpdatedAt'] ?? row['created_at'] ?? ''}';
  }

  Future<void> markAllRead(Map<String, dynamic> data) async {
    final preferences = await SharedPreferences.getInstance();
    final seen = (preferences.getStringList(_seenKey) ?? const []).toSet();
    seen.addAll(keys(data));
    await preferences.setStringList(_seenKey, seen.toList());
  }

  List<Map<String, dynamic>> _list(Object? value) =>
      (value as List? ?? const [])
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .toList();
}
