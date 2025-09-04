import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/item.dart';
import '../services/item_service.dart';

/// --------------------
/// ItemList State
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
  final bool hasConnection;

  const ItemListState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.searchTerm = "",
    this.albumId = 0,
    this.albumName,
    this.orderDir = "desc",
    this.hasConnection = true,
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
    bool? hasConnection,
  }) {
    return ItemListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchTerm: searchTerm ?? this.searchTerm,
      albumId: albumId ?? this.albumId,
      albumName: albumName ?? (albumId == 0 ? null : this.albumName),
      orderDir: orderDir ?? this.orderDir,
      hasConnection: hasConnection ?? this.hasConnection,
    );
  }
}

/// --------------------
/// ItemList Notifier
/// --------------------
class ItemListNotifier extends StateNotifier<ItemListState> {
  final ItemService _itemService;

  ItemListNotifier(this._itemService) : super(const ItemListState());

  Future<void> fetchItems({bool refresh = false}) async {
    try {
      // ✅ Check connectivity first
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        state = state.copyWith(
          isLoading: false,
          hasConnection: false,
          items: [], // clear items when offline
        );
        return;
      }

      if (state.isLoading) return;

      state = state.copyWith(isLoading: true, hasConnection: true);

      final nextPage = refresh ? 1 : state.page;

      final newItems = await _itemService.fetchItems(
        state.albumId,
        perPage: 10,
        orderBy: "created_at",
        orderDir: state.orderDir,
        searchTerm: state.searchTerm,
        forceRefresh: true, // ✅ Always fresh, ignore cache
      );

      state = state.copyWith(
        items: refresh ? newItems : [...state.items, ...newItems],
        hasMore: newItems.length == 10,
        page: refresh ? 2 : nextPage + 1,
        isLoading: false,
        hasConnection: true,
      );
    } catch (e) {
      // ✅ Catch NO_CONNECTION and other exceptions
      if (e.toString().contains("NO_CONNECTION") ||
          e.toString().contains("SocketException")) {
        state = state.copyWith(
          isLoading: false,
          hasConnection: false,
          items: [], // clear cached items
        );
      } else {
        debugPrint('Failed to load albums: $e');
        state = state.copyWith(isLoading: false, items: []);
      }
    }
  }

  void setFilters({
    int? albumId,
    String? albumName,
    String? searchTerm,
    String? orderDir,
  }) {
    final resolvedAlbumName =
        (albumId != null && albumId == 0)
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
      hasConnection: true,
    );

    fetchItems(refresh: true);
  }

  void resetFilters() {
    state = const ItemListState();
    fetchItems(refresh: true);
  }

  void setNoConnection() {
    state = state.copyWith(hasConnection: false, isLoading: false, items: []);
  }
}

/// --------------------
/// Provider
/// --------------------
final itemListProvider = StateNotifierProvider<ItemListNotifier, ItemListState>(
  (ref) => ItemListNotifier(ItemService()),
);

/// Latest Items (Homepage Preview with cache)
final latestItemsProvider = FutureProvider<List<Item>>((ref) async {
  final service = ItemService();
  final items = await service.fetchItems(
    0,
    perPage: 5,
    orderBy: "created_at",
    orderDir: "desc",
    forceRefresh: false,
    useCache: true, // ✅ allow cache
    cacheTTL: const Duration(minutes: 10),
  );
  return items;
});
