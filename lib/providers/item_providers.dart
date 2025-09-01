import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_in_chiangmai/models/item.dart';
import 'package:travel_in_chiangmai/services/item_service.dart';

/// --------------------
/// ItemList State (Paginated + Searchable + Filterable)
/// --------------------
class ItemListState {
  final List<Item> items;
  final bool isLoading;
  final bool hasMore;
  final int page;
  final String searchTerm;
  final int albumId;
  final String? albumName;
  final String orderDir;

  const ItemListState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.searchTerm = "",
    this.albumId = 0,
    this.albumName,
    this.orderDir = "desc",
  });

  ItemListState copyWith({
    List<Item>? items,
    bool? isLoading,
    bool? hasMore,
    int? page,
    String? searchTerm,
    int? albumId,
    String? albumName,
    String? orderDir,
  }) {
    return ItemListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchTerm: searchTerm ?? this.searchTerm,
      albumId: albumId ?? this.albumId,
      albumName: albumName != null
          ? albumName
          : (albumId == 0 ? null : this.albumName),
      orderDir: orderDir ?? this.orderDir,
    );
  }
}

class ItemListNotifier extends StateNotifier<ItemListState> {
  final ItemService _itemService;

  ItemListNotifier(this._itemService) : super(const ItemListState());

  Future<void> fetchItems({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = refresh ? 1 : state.page;
      final newItems = await _itemService.fetchItems(
        state.albumId,
        perPage: 10,
        orderBy: "created_at",
        orderDir: state.orderDir,
        searchTerm: state.searchTerm,
        forceRefresh: refresh || nextPage == 1,
        cacheTTL: const Duration(minutes: 10), // Use 10 min cache
      );

      state = state.copyWith(
        items: refresh ? newItems : [...state.items, ...newItems],
        hasMore: newItems.length == 10,
        page: refresh ? 2 : nextPage + 1,
      );
    } catch (e) {
      // Handle error if needed
      print("Failed to fetch items: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Update filters (album, keyword, sorting)
  void setFilters({
    int? albumId,
    String? albumName,
    String? searchTerm,
    String? orderDir,
  }) {
    final resolvedAlbumName = (albumId != null && albumId == 0)
        ? null
        : (albumName ?? state.albumName);

    state = state.copyWith(
      albumId: albumId ?? state.albumId,
      albumName: resolvedAlbumName,
      searchTerm: searchTerm ?? state.searchTerm,
      orderDir: orderDir ?? state.orderDir,
      items: [],
      hasMore: true,
      page: 1,
    );

    print("🔹 setFilters called:");
    print("   albumId: ${state.albumId}");
    print("   albumName: ${state.albumName}");
    print("   searchTerm: ${state.searchTerm}");
    print("   orderDir: ${state.orderDir}");

    fetchItems(refresh: true);
  }

  /// Reset all filters
  void resetFilters() {
    state = const ItemListState();
    fetchItems(refresh: true);
  }

  /// Quick keyword setter
  void setSearchTerm(String term) {
    state = state.copyWith(
      searchTerm: term,
      page: 1,
      items: [],
      hasMore: true,
    );
    fetchItems(refresh: true);
  }
}

final itemListProvider =
    StateNotifierProvider<ItemListNotifier, ItemListState>(
  (ref) => ItemListNotifier(ItemService()),
);

/// --------------------
/// Latest Items Provider (Homepage Preview with Cache)
/// --------------------
final latestItemsProvider = FutureProvider<List<Item>>((ref) async {
  final service = ItemService();

  // Use SharedPreferences cache with TTL
  final items = await service.fetchItems(
    0, // albumId 0 = latest items
    perPage: 5,
    orderBy: "created_at",
    orderDir: "desc",
    forceRefresh: false,             // use cache by default
    cacheTTL: const Duration(minutes: 10),
  );

  return items;
});
