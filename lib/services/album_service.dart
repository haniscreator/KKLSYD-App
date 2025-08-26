// lib/services/album_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/album.dart';

class AlbumService {
  Future<List<Album>> fetchAlbums() async {
    final response = await http.get(Uri.parse(AppConfig.albums));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data'];

      return data.map((albumJson) => Album.fromJson(albumJson)).toList();
    } else {
      throw Exception("Failed to load albums");
    }
  }
}
