import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/item.dart';

class ItemService {
  
  Future<List<Item>> fetchItems(
  int albumId, {
  int page = 1,
  int perPage = 5,
  String orderBy = "created_at",
  String orderDir = "desc",
  String? searchTerm,
  bool forceRefresh = false,
  Duration? cacheTTL,
}) async {
  final url = Uri.parse(AppConfig.items);
  final prefs = await SharedPreferences.getInstance();

  final st = (searchTerm ?? '').trim();
  final base = 'items_album_${albumId}_page${page}_pp${perPage}_ob${orderBy}_od${orderDir}_st${st}';
  final dataKey = '${base}_data';
  final tsKey = '${base}_ts';

  bool isFresh() {
    if (cacheTTL == null) return true;
    final ts = prefs.getInt(tsKey);
    if (ts == null) return false;
    final age = DateTime.now().millisecondsSinceEpoch - ts;
    return age <= cacheTTL.inMilliseconds;
  }

  if (!forceRefresh && prefs.containsKey(dataKey) && isFresh()) {
    final cachedJson = prefs.getString(dataKey);
    if (cachedJson != null) {
      final List<dynamic> cachedList = jsonDecode(cachedJson);
      return cachedList.map((j) => Item.fromJson(j)).toList();
    }
  }

  final body = {
    "album_id": albumId,
    "page": page,
    "per_page": perPage,
    "order_by": orderBy,
    "order_dir": orderDir,
    "search_term": st.isEmpty ? null : st,
  };

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> itemsJson = data['data'];
    final items = itemsJson.map((j) => Item.fromJson(j)).toList();

    await prefs.setString(dataKey, jsonEncode(itemsJson));
    await prefs.setInt(tsKey, DateTime.now().millisecondsSinceEpoch);

    return items;
  } else {
    throw Exception("Failed to load items: ${response.statusCode}");
  }
}



Future<void> clearCache(int albumId) async {
  final prefs = await SharedPreferences.getInstance();
  final prefix = 'items_album_${albumId}_';
  final keys = prefs.getKeys().where((k) => k.startsWith(prefix)).toList();
  for (final key in keys) {
    await prefs.remove(key);
  }
}

}
