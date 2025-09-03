import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kklsyd_app/models/item.dart';
import 'package:kklsyd_app/services/item_service.dart';

final detailItemsListProvider =
    FutureProvider.family.autoDispose<List<Item>, int>((ref, albumId) async {
  // Always call API, never return old cache
  final service = ItemService();
  return service.fetchItems(
    albumId,
    forceRefresh: true, // make sure ItemService bypasses local cache
  );
});
