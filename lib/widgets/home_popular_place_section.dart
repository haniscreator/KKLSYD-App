import 'package:flutter/material.dart';
import 'package:travel_in_chiangmai/models/album.dart';
import 'package:travel_in_chiangmai/services/album_service.dart';
import 'package:travel_in_chiangmai/widgets/home_popular_place_card.dart';
import 'package:travel_in_chiangmai/const/const.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomePopularPlaceSection extends StatefulWidget {
  const HomePopularPlaceSection({super.key});

  @override
  State<HomePopularPlaceSection> createState() =>
      _HomePopularPlaceSectionState();
}

class _HomePopularPlaceSectionState extends State<HomePopularPlaceSection> {
  final AlbumService _albumService = AlbumService();
  List<Album> _albums = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    try {
      // 1️⃣ Try to get cached albums first (fast load)
      final cachedAlbums = await _albumService.fetchAlbums();
      if (mounted) {
        setState(() {
          _albums = cachedAlbums;
          _isLoading = false;
        });
      }

      // 2️⃣ Refresh in background (force API call)
      final freshAlbums = await _albumService.fetchAlbums(forceRefresh: true);
      if (mounted && freshAlbums.isNotEmpty) {
        setState(() {
          _albums = freshAlbums;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Album များ",
                style: TextStyle(
                  fontSize: sectionTitleFontSize,
                  fontWeight: textFontWeight,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                  fontSize: smallTextFontSize,
                  color: isDark ? Colors.teal[200] : Colors.teal,
                ),
              ),
            ],
          ),
        ),

        // Albums List (Shimmer / Data / Error)
        SizedBox(
          height: 210,
          child: Builder(
            builder: (context) {
              if (_isLoading && _albums.isEmpty) {
                // 🔥 Shimmer Skeleton Loader
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Shimmer(
                        child: Container(
                          width: 320,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (_hasError && _albums.isEmpty) {
                return const Center(child: Text("Error loading albums"));
              } else if (_albums.isEmpty) {
                return const Center(child: Text("No albums found"));
              }

              // ✅ Show albums (cached or fresh)
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _albums.length,
                itemBuilder: (context, index) {
                  final album = _albums[index];
                  return HomePopularPlaceCard(album: album);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
