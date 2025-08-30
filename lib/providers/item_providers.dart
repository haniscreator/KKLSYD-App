import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_in_chiangmai/models/item.dart';
import 'package:travel_in_chiangmai/services/item_service.dart';

/// --------------------
/// ItemList State (Paginated + Searchable)
/// --------------------
class ItemListState {
  final List<Item> items;
  final bool isLoading;
  final bool hasMore;
  final int page;
  final String searchTerm;

  const ItemListState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.searchTerm = "",
  });

  ItemListState copyWith({
    List<Item>? items,
    bool? isLoading,
    bool? hasMore,
    int? page,
    String? searchTerm,
  }) {
    return ItemListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchTerm: searchTerm ?? this.searchTerm,
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
      int nextPage = refresh ? 1 : state.page;

      final newItems = await _itemService.fetchItems(
        0,
        perPage: 10,
        orderBy: "created_at",
        orderDir: "desc",
        searchTerm: state.searchTerm,
        forceRefresh: refresh || nextPage == 1,
      );

      state = state.copyWith(
        items: refresh ? newItems : [...state.items, ...newItems],
        hasMore: newItems.length == 10,
        page: refresh ? 2 : nextPage + 1,
      );
    } catch (e) {
      // You might log or handle error here
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void setSearchTerm(String term) {
    state = state.copyWith(searchTerm: term);
    fetchItems(refresh: true);
  }
}

final itemListProvider =
    StateNotifierProvider<ItemListNotifier, ItemListState>(
  (ref) => ItemListNotifier(ItemService()),
);

/// --------------------
/// Latest Items Provider (Homepage Preview)
/// --------------------
final latestItemsProvider = FutureProvider<List<Item>>((ref) async {
  final service = ItemService();
  return service.fetchItems(
    0,
    perPage: 5,
    orderBy: "created_at",
    orderDir: "desc",
    forceRefresh: true,
  );
});
