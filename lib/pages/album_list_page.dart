import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_in_chiangmai/models/album.dart';
import 'package:travel_in_chiangmai/services/album_service.dart';
import 'package:travel_in_chiangmai/widgets/home_album_card.dart';

/// STATE MODEL
class AlbumListState {
  final List<Album> albums;
  final bool isLoading;
  final bool hasMore;
  final int page;
  final String searchTerm;

  const AlbumListState({
    this.albums = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.searchTerm = '',
  });

  AlbumListState copyWith({
    List<Album>? albums,
    bool? isLoading,
    bool? hasMore,
    int? page,
    String? searchTerm,
  }) {
    return AlbumListState(
      albums: albums ?? this.albums,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}

/// NOTIFIER
class AlbumListNotifier extends StateNotifier<AlbumListState> {
  AlbumListNotifier() : super(const AlbumListState());

  final AlbumService _albumService = AlbumService();
  final int _perPage = 10;

  Future<void> fetchAlbums({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      int page = refresh ? 1 : state.page;

      final newAlbums = await _albumService.fetchAlbums(
        page: page,
        perPage: _perPage,
        searchTerm: state.searchTerm,
        forceRefresh: refresh || page == 1,
      );

      state = state.copyWith(
        albums: refresh ? newAlbums : [...state.albums, ...newAlbums],
        hasMore: newAlbums.length == _perPage,
        page: (newAlbums.length == _perPage) ? page + 1 : page,
      );
    } catch (e) {
      debugPrint('Failed to load albums: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateSearchTerm(String searchTerm) {
    state = state.copyWith(searchTerm: searchTerm);
    fetchAlbums(refresh: true);
  }

  void reset() {
    state = const AlbumListState();
    fetchAlbums(refresh: true);
  }
}

/// PROVIDER
final albumListProvider =
    StateNotifierProvider<AlbumListNotifier, AlbumListState>((ref) {
  return AlbumListNotifier();
});

/// UI
class AlbumListPage extends ConsumerStatefulWidget {
  const AlbumListPage({super.key});

  @override
  ConsumerState<AlbumListPage> createState() => _AlbumListPageState();
}

class _AlbumListPageState extends ConsumerState<AlbumListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(albumListProvider.notifier).fetchAlbums(refresh: true));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final state = ref.read(albumListProvider);
    if (!_scrollController.hasClients || state.isLoading || !state.hasMore) {
      return;
    }

    const threshold = 200.0;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - threshold) {
      ref.read(albumListProvider.notifier).fetchAlbums();
    }
  }

  void _startSearch() {
    setState(() => _isSearching = true);
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    ref.read(albumListProvider.notifier).updateSearchTerm('');
  }

  void _onSearchChanged(String value) {
    ref.read(albumListProvider.notifier).updateSearchTerm(value);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(albumListProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search albums...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  debugPrint("onChanged fired: $value");
                  _onSearchChanged(value);
                },
                onSubmitted: (value) {
                  debugPrint("onSubmitted fired: $value");
                  _onSearchChanged(value);
                },
              )
            : const Text('Albums'),
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
            ref.read(albumListProvider.notifier).fetchAlbums(refresh: true),
        child: ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.albums.length + (state.hasMore || state.isLoading ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index < state.albums.length) {
              final album = state.albums[index];
              return Padding(
                key: ValueKey('album_row_${album.id ?? index}'),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: HomeAlbumCard(
                  album: album,
                  useHero: false,
                  fullWidth: true,
                ),
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
