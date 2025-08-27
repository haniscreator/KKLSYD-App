import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/item.dart';

class ItemService {
  Future<List<Item>> fetchItems(int albumId, {int perPage = 5}) async {
    final url = Uri.parse(AppConfig.items);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "album_id": albumId,
        "per_page": perPage,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> itemsJson = body['data'];
      return itemsJson.map((json) => Item.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load items");
    }
  }
}
