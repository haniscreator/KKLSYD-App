import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/item.dart';

class ItemService {
  /// Fetch items with caching
  Future<List<Item>> fetchItems(
    int albumId, {
    int perPage = 5,
    String orderBy = "created_at",
    String orderDir = "desc",
    String? searchTerm,
  }) async {
    final url = Uri.parse(AppConfig.items);
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'items_album_$albumId';

    // Try to load cached data first
    if (prefs.containsKey(cacheKey)) {
      final cachedJson = prefs.getString(cacheKey);
      if (cachedJson != null) {
        final List<dynamic> cachedList = jsonDecode(cachedJson);
        final cachedItems =
            cachedList.map((json) => Item.fromJson(json)).toList();
        // Return cached items immediately
        return cachedItems;
      }
    }

    // Network request
    final body = {
      "album_id": albumId,
      "per_page": perPage,
      "order_by": orderBy,
      "order_dir": orderDir,
      "search_term": searchTerm,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> itemsJson = data['data'];
      final items = itemsJson.map((json) => Item.fromJson(json)).toList();

      // Save to cache for next time
      await prefs.setString(cacheKey, jsonEncode(itemsJson));

      return items;
    } else {
      throw Exception("Failed to load items: ${response.statusCode}");
    }
  }

  /// Optional: clear cached items
  Future<void> clearCache(int albumId) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'items_album_$albumId';
    await prefs.remove(cacheKey);
  }
}
