import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kklsyd_app/Config/config.dart';
import 'package:kklsyd_app/const/const.dart';
import 'package:lottie/lottie.dart';
import '../models/item.dart';
import '../providers/item_providers.dart';
import '../widgets/home_latest_item_card.dart';
import 'item_search_page.dart';
import 'audioplayer_page.dart';

class ItemListPage extends ConsumerStatefulWidget {
  const ItemListPage({super.key});

  @override
  ConsumerState<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends ConsumerState<ItemListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // ✅ Check connectivity first
    Connectivity().checkConnectivity().then((result) {
      if (result == ConnectivityResult.none) {
        ref.read(itemListProvider.notifier).setNoConnection();
      } else {
        ref.read(itemListProvider.notifier).fetchItems(refresh: true);
      }
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final state = ref.read(itemListProvider);
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !state.isLoading &&
        state.hasMore) {
      ref.read(itemListProvider.notifier).fetchItems();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itemListProvider);
    final notifier = ref.read(itemListProvider.notifier);

    final bool hasActiveFilters =
        state.albumId != 0 ||
        state.searchTerm.isNotEmpty ||
        state.orderDir != "desc";

    Widget body;

    if (!state.hasConnection && state.items.isEmpty) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lotties/no_connection.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            const Text(
              txtGeneralNoInternet_MM,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.fetchItems(refresh: true),
              child: const Text(txtTryAgain_MM),
            ),
          ],
        ),
      );
    } else if (state.isLoading && state.items.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = RefreshIndicator(
        onRefresh: () => notifier.fetchItems(refresh: true),
        child: ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount:
              (hasActiveFilters ? 1 : 0) +
              state.items.length +
              (state.hasMore || state.isLoading ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (hasActiveFilters && index == 0) {
              return _FilterChipsHeader(
                albumName: state.albumName,
                searchTerm: state.searchTerm,
                orderDir: state.orderDir,
                onClearAlbum:
                    () => notifier.setFilters(albumId: 0, albumName: null),
                onClearKeyword: () => notifier.setFilters(searchTerm: ""),
                onClearOrder: () => notifier.setFilters(orderDir: "desc"),
                onResetAll: notifier.resetFilters,
              );
            }

            final offset = hasActiveFilters ? 1 : 0;
            final dataIndex = index - offset;

            if (dataIndex < state.items.length) {
              final Item item = state.items[dataIndex];
              return Padding(
                key: ValueKey('item_row_${item.id ?? dataIndex}'),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () {
                    final fullAudioUrl = AppConfig.storageUrl + item.mediaUrl;

                    print(
                      "Tapped item: ID=${item.id}, name=${item.name}, url=$fullAudioUrl",
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AudioPlayerPage(
                              audioUrl: fullAudioUrl, // ✅ full URL
                              title: item.name,
                              image: 'assets/images/thumbnail/thumbnail5.png',
                              description: item.description,
                            ),
                      ),
                    );
                  },

                  child: HomeLatestItemCard(item: item),
                ),
              );
            }

            if (state.isLoading && dataIndex >= state.items.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(txtItemTabTitleAlbum_MM),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ItemSearchPage()),
                  );
                },
              ),
              if (hasActiveFilters)
                Positioned(
                  right: 10,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: body,
    );
  }
}

/// --------------------
/// Filter Chips Header
/// --------------------
class _FilterChipsHeader extends StatelessWidget {
  const _FilterChipsHeader({
    required this.albumName,
    required this.searchTerm,
    required this.orderDir,
    required this.onClearAlbum,
    required this.onClearKeyword,
    required this.onClearOrder,
    required this.onResetAll,
  });

  final String? albumName;
  final String searchTerm;
  final String orderDir;
  final VoidCallback onClearAlbum;
  final VoidCallback onClearKeyword;
  final VoidCallback onClearOrder;
  final VoidCallback onResetAll;

  @override
  Widget build(BuildContext context) {
    final showAlbum = albumName != null && albumName!.isNotEmpty;
    final showKeyword = searchTerm.isNotEmpty;
    final showOrder = orderDir != "desc";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAlbum)
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(label: Text("Album: $albumName"), onDeleted: onClearAlbum),
              ],
            ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (showKeyword)
                Chip(
                  label: Text('Keyword: "$searchTerm"'),
                  onDeleted: onClearKeyword,
                ),
              if (showOrder)
                Chip(
                  label: Text('Order: ${orderDir.toUpperCase()}'),
                  onDeleted: onClearOrder,
                ),
              ActionChip(
                avatar: const Icon(Icons.refresh, size: 18),
                label: const Text("Reset All"),
                onPressed: onResetAll,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
