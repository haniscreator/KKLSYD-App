import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_in_chiangmai/models/item.dart';
import 'package:travel_in_chiangmai/widgets/home_latest_item_card.dart';
import 'package:travel_in_chiangmai/providers/item_providers.dart';

class ItemListPage extends ConsumerStatefulWidget {
  const ItemListPage({super.key});

  @override
  ConsumerState<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends ConsumerState<ItemListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(itemListProvider.notifier).fetchItems(refresh: true));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final state = ref.read(itemListProvider);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !state.isLoading &&
        state.hasMore) {
      ref.read(itemListProvider.notifier).fetchItems();
    }
  }

  void _startSearch() {
    setState(() => _isSearching = true);
  }

  void _stopSearch() {
    setState(() => _isSearching = false);
    _searchController.clear();
    ref.read(itemListProvider.notifier).setSearchTerm("");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itemListProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search items...",
                  border: InputBorder.none,
                ),
                onChanged: (value) =>
                    ref.read(itemListProvider.notifier).setSearchTerm(value),
                onSubmitted: (value) =>
                    ref.read(itemListProvider.notifier).setSearchTerm(value),
              )
            : const Text("Items"),
        actions: [
          _isSearching
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _stopSearch,
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _startSearch,
                ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(itemListProvider.notifier).fetchItems(refresh: true),
        child: ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.items.length + (state.hasMore || state.isLoading ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index < state.items.length) {
              final Item item = state.items[index];
              return Padding(
                key: ValueKey('item_row_${item.id ?? index}'),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: HomeLatestItemCard(item: item),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
