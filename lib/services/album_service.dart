import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/album.dart';

class AlbumService {
  /// Fetch albums with caching
  Future<List<Album>> fetchAlbums({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    const cacheKey = 'albums_cache';

    // Return cached albums if available and not forcing refresh
    if (!forceRefresh && prefs.containsKey(cacheKey)) {
      final cachedJson = prefs.getString(cacheKey);
      if (cachedJson != null) {
        final List<dynamic> cachedList = jsonDecode(cachedJson);
        return cachedList.map((json) => Album.fromJson(json)).toList();
      }
    }

    // Fetch from API
    final response = await http.get(Uri.parse(AppConfig.albums));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data'];

      // Save to cache
      await prefs.setString(cacheKey, jsonEncode(data));

      return data.map((albumJson) => Album.fromJson(albumJson)).toList();
    } else {
      throw Exception("Failed to load albums: ${response.statusCode}");
    }
  }
}

