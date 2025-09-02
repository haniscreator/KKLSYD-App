import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/album.dart';
import '../services/album_service.dart';

final albumServiceProvider = Provider<AlbumService>((ref) => AlbumService());

final albumsProvider = FutureProvider.autoDispose<List<Album>>((ref) async {
  final service = ref.read(albumServiceProvider);
  return service.fetchAlbums(
    page: 1,
    perPage: 10,
    forceRefresh: false, // use cache by default
    cacheTTL: const Duration(minutes: 10), // 10 min cache
  );
});
