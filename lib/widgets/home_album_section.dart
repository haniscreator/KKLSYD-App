import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kklsyd_app/pages/album_list_page.dart';
import 'package:kklsyd_app/providers/album_providers.dart';
import 'package:kklsyd_app/services/album_service.dart';
import 'package:kklsyd_app/widgets/home_album_card.dart';
import 'package:kklsyd_app/const/const.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeAlbumSection extends ConsumerWidget {
  const HomeAlbumSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAlbums = ref.watch(albumsProvider);
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
                txtLatestAlbumHome_MM,
                style: TextStyle(
                  fontSize: sectionTitleFontSize,
                  fontWeight: textFontWeight,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AlbumListPage()),
                  );
                },
                child: Icon(
                  Icons
                      .arrow_forward_ios, // 👈 you can change this to any Material icon
                  size:
                      smallTextFontSize + 2, // keep proportions similar to text
                  color:
                      isDark
                          ? commonActionTextColorDark
                          : commonActionTextColor,
                ),
              ),
            ],
          ),
        ),

        // Albums List
        SizedBox(
          height: 210,
          child: asyncAlbums.when(
            data: (albums) {
              if (albums.isEmpty) {
                return const Center(child: Text("No albums found"));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  final service = AlbumService();
                  await service.fetchAlbums(
                    page: 1,
                    perPage: 10,
                    forceRefresh: true,
                    cacheTTL: const Duration(minutes: 10),
                  );
                  ref.invalidate(
                    albumsProvider,
                  ); // reload provider with fresh data
                },
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    return HomeAlbumCard(
                      album: albums[index],
                      fullWidth: false,
                      verticalMode: false,
                      index: index,
                    );
                  },
                ),
              );
            },
            loading:
                () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 4,
                  itemBuilder:
                      (context, index) => Padding(
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
                      ),
                ),
            error: (_, __) => const Center(child: Text("Error loading albums")),
          ),
        ),
      ],
    );
  }
}
