import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/item.dart';

class ItemService {
  Future<List<Item>> fetchItems(
    int albumId, {
    int perPage = 5,
    String orderBy = "created_at",
    String orderDir = "desc",
    String? searchTerm,
  }) async {
    final url = Uri.parse(AppConfig.items);

    final body = {
      "album_id": albumId,
      "per_page": perPage,
      "order_by": orderBy,
      "order_dir": orderDir,
      "search_term": searchTerm, // nullable
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> itemsJson = body['data'];
      return itemsJson.map((json) => Item.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load items: ${response.statusCode}");
    }
  }
}
