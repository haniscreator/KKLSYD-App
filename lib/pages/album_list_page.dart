import 'package:flutter/material.dart';
import 'package:travel_in_chiangmai/models/album.dart';
import 'package:travel_in_chiangmai/services/album_service.dart';
import 'package:travel_in_chiangmai/widgets/home_album_card.dart';

class AlbumListPage extends StatefulWidget {
  const AlbumListPage({super.key});

  @override
  State<AlbumListPage> createState() => _AlbumListPageState();
}

class _AlbumListPageState extends State<AlbumListPage> {
  final AlbumService _albumService = AlbumService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final List<Album> _albums = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _perPage = 10;

  bool _isSearching = false;
  String _searchTerm = "";

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    const threshold = 200.0;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - threshold && !_isLoading && _hasMore) {
      _fetchAlbums();
    }
  }

  Future<void> _fetchAlbums({bool refresh = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      if (refresh) {
        _page = 1;
        _hasMore = true;
      }

      final newAlbums = await _albumService.fetchAlbums(
        page: _page,
        perPage: _perPage,
        searchTerm: _searchTerm,
        forceRefresh: refresh || _page == 1,
      );

      if (!mounted) return;

      setState(() {
        if (refresh) _albums.clear();
        _albums.addAll(newAlbums);
        _hasMore = newAlbums.length == _perPage;
        if (_hasMore) _page += 1;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load albums: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startSearch() {
    setState(() => _isSearching = true);
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchTerm = "";
    });
    _fetchAlbums(refresh: true);
  }

  void _onSearchChanged(String value) {
    
    setState(() => _searchTerm = value);
    _fetchAlbums(refresh: true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                print("onChanged fired: $value"); // <- trace live typing
                _onSearchChanged(value);
              },
              onSubmitted: (value) {
                print("onSubmitted fired: $value"); // <- trace Enter key
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
        onRefresh: () => _fetchAlbums(refresh: true),
        child: ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _albums.length + (_hasMore || _isLoading ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index < _albums.length) {
              final album = _albums[index];
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
