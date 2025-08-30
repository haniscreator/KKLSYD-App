import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/album.dart';
import '../services/album_service.dart';

/// Service provider
final albumServiceProvider = Provider<AlbumService>((ref) {
  return AlbumService();
});

/// FutureProvider for fetching albums
final albumsProvider = FutureProvider.autoDispose<List<Album>>((ref) async {
  final service = ref.read(albumServiceProvider);
  return service.fetchAlbums();
});
