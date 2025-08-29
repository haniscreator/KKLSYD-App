import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/album.dart';

class AlbumService {
  Future<List<Album>> fetchAlbums({
    int page = 1,
    int perPage = 10,
    String? searchTerm,
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Cache key
    String cacheKey = 'albums_cache_page_${page}_per_${perPage}';
    if (searchTerm != null && searchTerm.isNotEmpty) {
      cacheKey += '_search_${searchTerm.toLowerCase()}';
    }

    if (!forceRefresh && prefs.containsKey(cacheKey)) {
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
      if (searchTerm != null && searchTerm.isNotEmpty) "search_term": searchTerm,
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    
    print("API response: ${response.body}");


    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      List<dynamic> data = [];

      if (decoded is Map && decoded.containsKey("data")) {
        data = decoded["data"];
      } else if (decoded is List) {
        data = decoded;
      }

      await prefs.setString(cacheKey, jsonEncode(data));

      print("POST body: ${jsonEncode(body)}");
      print("API response: ${response.body}");

      return data.map((e) => Album.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load albums: ${response.statusCode}");
    }
  }
}
