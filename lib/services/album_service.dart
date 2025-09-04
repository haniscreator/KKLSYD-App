import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/config.dart';
import '../models/album.dart';

class AlbumService {
  Future<List<Album>> fetchAlbums({
    int page = 1,
    int perPage = 10,
    String? searchTerm,
    bool forceRefresh = false,
    Duration? cacheTTL,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Cache key and timestamp key
    String cacheKey = 'albums_cache_page_${page}_per_$perPage';
    String tsKey = '${cacheKey}_ts';
    if (searchTerm != null && searchTerm.isNotEmpty) {
      cacheKey += '_search_${searchTerm.toLowerCase()}';
      tsKey += '_search_${searchTerm.toLowerCase()}';
    }

    // Check if cache is still valid
    bool isFresh() {
      if (cacheTTL == null) return true;
      final ts = prefs.getInt(tsKey);
      if (ts == null) return false;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      return age <= cacheTTL.inMilliseconds;
    }

    if (!forceRefresh && prefs.containsKey(cacheKey) && isFresh()) {
      final cachedJson = prefs.getString(cacheKey);
      if (cachedJson != null) {
        final List<dynamic> cachedList = jsonDecode(cachedJson);
        return cachedList.map((json) => Album.fromJson(json)).toList();
      }
    }

    // POST body
    final uri = Uri.parse(AppConfig.albums);
    final body = {
      "page": page,
      "per_page": perPage,
      if (searchTerm != null && searchTerm.isNotEmpty)
        "search_term": searchTerm,
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      List<dynamic> data = [];
      if (decoded is Map && decoded.containsKey("data")) {
        data = decoded["data"];
      } else if (decoded is List) {
        data = decoded;
      }

      // Save to cache
      await prefs.setString(cacheKey, jsonEncode(data));
      await prefs.setInt(tsKey, DateTime.now().millisecondsSinceEpoch);

      return data.map((e) => Album.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load albums: ${response.statusCode}");
    }
  }
}
