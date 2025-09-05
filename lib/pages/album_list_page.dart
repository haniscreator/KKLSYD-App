import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kklsyd_app/const/const.dart';
import 'package:kklsyd_app/models/album.dart';
import 'package:kklsyd_app/services/album_service.dart';
import 'package:kklsyd_app/widgets/home_album_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';

/// STATE MODEL
class AlbumListState {
  final List<Album> albums;
  final bool isLoading;
  final bool hasMore;
  final int page;
  final String searchTerm;
  final bool hasConnection;

  const AlbumListState({
    this.albums = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.searchTerm = '',
    this.hasConnection = true,
  });

  AlbumListState copyWith({
    List<Album>? albums,
    bool? isLoading,
    bool? hasMore,
    int? page,
    String? searchTerm,
    bool? hasConnection,
  }) {
    return AlbumListState(
      albums: albums ?? this.albums,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchTerm: searchTerm ?? this.searchTerm,
      hasConnection: hasConnection ?? this.hasConnection,
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

    // ✅ Check connectivity first
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      state = state.copyWith(hasConnection: false, isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, hasConnection: true);

    try {
      int page = refresh ? 1 : state.page;

      final newAlbums = await _albumService.fetchAlbums(
        page: page,
        perPage: _perPage,
        searchTerm: state.searchTerm,
        forceRefresh: true,
      );

      state = state.copyWith(
        albums: refresh ? newAlbums : [...state.albums, ...newAlbums],
        hasMore: newAlbums.length == _perPage,
        page: (newAlbums.length == _perPage) ? page + 1 : page,
      );
    } catch (e) {
      debugPrint('Failed to load albums: $e');

      // ✅ If error is a SocketException, mark as no connection
      if (e.toString().contains("SocketException")) {
        state = state.copyWith(hasConnection: false);
      }
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

    // ✅ Immediately check internet when entering
    Connectivity().checkConnectivity().then((result) {
      if (result == ConnectivityResult.none) {
        ref.read(albumListProvider.notifier).state = ref
            .read(albumListProvider.notifier)
            .state
            .copyWith(hasConnection: false);
      } else {
        ref.read(albumListProvider.notifier).fetchAlbums(refresh: true);
      }
    });

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
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: txtSearchHint_MM,
                    border: InputBorder.none,
                  ),
                  onChanged: _onSearchChanged,
                  onSubmitted: _onSearchChanged,
                )
                : const Text(txtLatestAlbumHome_MM),
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
      body:
          state.hasConnection
              ? RefreshIndicator(
                onRefresh:
                    () => ref
                        .read(albumListProvider.notifier)
                        .fetchAlbums(refresh: true),
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount:
                      state.albums.length +
                      (state.hasMore || state.isLoading ? 1 : 0),
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
                          verticalMode: true,
                          index: index,
                        ),
                      );
                    }

                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lotties/no_connection.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      txtGeneralNoInternet_MM,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(albumListProvider.notifier)
                            .fetchAlbums(refresh: true);
                      },
                      child: const Text(txtTryAgain_MM),
                    ),
                  ],
                ),
              ),
    );
  }
}
