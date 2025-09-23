import 'package:flutter/foundation.dart';
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

    // Check connectivity first
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

    // Debug info to help track why the UI shows empty-state
    debugPrint(
      'ItemListPage build: items=${state.items.length}, isLoading=${state.isLoading}, hasConnection=${state.hasConnection}, search="${state.searchTerm}", hasActiveFilters=$hasActiveFilters',
    );

    Widget body;

    // 1) No connection & nothing loaded yet
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
    }
    // 2) Initial loading (spinner) while nothing exists yet
    else if (state.isLoading && state.items.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    }
    // 3) Normal flow (either we have items, or items empty but not loading => show empty UI)
    else {
      // If items are empty and not loading -> show "Result Not Found"
      if (state.items.isEmpty && !state.isLoading) {
        debugPrint(
          'Showing empty-result UI (items=0, search="${state.searchTerm}")',
        );

        final String emptyMessage =
            state.searchTerm.isNotEmpty
                ? '$txtNoResult1_MM "${state.searchTerm}".\n$txtNoResult2_MM'
                : txtNoResult_MM;

        body = RefreshIndicator(
          onRefresh: () => notifier.fetchItems(refresh: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              // show filter header so user can clear filters even when empty
              if (hasActiveFilters)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: _FilterChipsHeader(
                    albumName: state.albumName,
                    searchTerm: state.searchTerm,
                    orderDir: state.orderDir,
                    onClearAlbum:
                        () => notifier.setFilters(albumId: 0, albumName: null),
                    onClearKeyword: () => notifier.setFilters(searchTerm: ""),
                    onClearOrder: () => notifier.setFilters(orderDir: "desc"),
                    onResetAll: notifier.resetFilters,
                  ),
                ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.16),
              Center(
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/lotties/no_data.json', // provide your empty animation asset
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      emptyMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => notifier.fetchItems(refresh: true),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      // 4) We have items — show the list (same as before)
      else {
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

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AudioPlayerPage(
                                audioUrl: fullAudioUrl,
                                title: item.name,
                                image: 'assets/icons/app_icon.png',
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
