import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/album.dart';

class AlbumService {
  /// Fetch albums with caching and optional pagination
  Future<List<Album>> fetchAlbums({
    int page = 1,
    int perPage = 10,
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'albums_cache_page_${page}_per_${perPage}';

    // ✅ Return cached albums if available and not forcing refresh
    if (!forceRefresh && prefs.containsKey(cacheKey)) {
      final cachedJson = prefs.getString(cacheKey);
      if (cachedJson != null) {
        final List<dynamic> cachedList = jsonDecode(cachedJson);
        return cachedList.map((json) => Album.fromJson(json)).toList();
      }
    }

    // ✅ Fetch from API with pagination
    final uri = Uri.parse(
      "${AppConfig.albums}?page=$page&per_page=$perPage",
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      // 🔥 Handle API format: make sure your API returns {"data": [...]}
      final List<dynamic> data =
          jsonData['data'] ?? (jsonData is List ? jsonData : []);

      // ✅ Save to cache
      await prefs.setString(cacheKey, jsonEncode(data));

      return data.map((albumJson) => Album.fromJson(albumJson)).toList();
    } else {
      throw Exception("Failed to load albums: ${response.statusCode}");
    }
  }
}
