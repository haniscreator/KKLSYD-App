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
  late Future<List<Album>> futureAlbums;

  @override
  void initState() {
    super.initState();
    futureAlbums = _albumService.fetchAlbums();
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

        // Albums List from API
        SizedBox(
          height: 210,
          child: FutureBuilder<List<Album>>(
            future: futureAlbums,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 🔥 Shimmer Skeleton Loader
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 4, // number of shimmer placeholders
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
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No albums found"));
              }

              final albums = snapshot.data!;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];
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
