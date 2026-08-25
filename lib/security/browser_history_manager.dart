import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'browser_encryption.dart';

class HistoryItem {
  final String encryptedUrl;
  final int timestamp;

  HistoryItem({required this.encryptedUrl, required this.timestamp});

  Map<String, dynamic> toJson() => {
        'url': encryptedUrl,
        'time': timestamp,
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        encryptedUrl: json['url'],
        timestamp: json['time'],
      );
}

class BrowserHistoryManager {
  final BrowserEncryptionService _encryptionService = BrowserEncryptionService();
  static const String _storageKey = 'encrypted_browser_history_v1';

  Future<void> addUrlToHistory(String rawUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedUrl = await _encryptionService.encryptData(rawUrl);
    final newItem = HistoryItem(
      encryptedUrl: encryptedUrl,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    List<String> historyJsonList = prefs.getStringList(_storageKey) ?? [];
    historyJsonList.add(jsonEncode(newItem.toJson()));

    await prefs.setStringList(_storageKey, historyJsonList);
  }

  Future<List<Map<String, dynamic>>> getDecryptedHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyJsonList = prefs.getStringList(_storageKey) ?? [];
    
    List<Map<String, dynamic>> decryptedHistory = [];

    for (var jsonStr in historyJsonList) {
      final Map<String, dynamic> map = jsonDecode(jsonStr);
      final item = HistoryItem.fromJson(map);

      try {
        final decryptedUrl = await _encryptionService.decryptData(item.encryptedUrl);
        
        decryptedHistory.add({
          'url': decryptedUrl,
          'time': DateTime.fromMillisecondsSinceEpoch(item.timestamp),
        });
      } catch (e) {
        decryptedHistory.add({
          'url': '[Dados Cifrados Indescriptografáveis]',
          'time': DateTime.fromMillisecondsSinceEpoch(item.timestamp),
        });
      }
    }
    return decryptedHistory.reversed.toList();
  }
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
