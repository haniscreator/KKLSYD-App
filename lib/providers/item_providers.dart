import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item.dart';
import '../services/item_service.dart';

/// Service provider
final itemServiceProvider = Provider<ItemService>((ref) {
  return ItemService();
});

/// FutureProvider for fetching latest items
final latestItemsProvider =
    FutureProvider.autoDispose<List<Item>>((ref) async {
  final service = ref.read(itemServiceProvider);
  return service.fetchItems(
    0,
    perPage: 5,
    orderBy: "created_at",
    orderDir: "desc",
    forceRefresh: false,
    cacheTTL: const Duration(minutes: 5),
  );
});
