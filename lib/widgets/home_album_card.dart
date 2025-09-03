import 'package:flutter/material.dart';
import 'package:kklsyd_app/animations/popin_card_images.dart';
import 'package:kklsyd_app/const/const.dart';
import 'package:kklsyd_app/models/album.dart';
import 'package:kklsyd_app/pages/album_detail_page.dart';

class HomeAlbumCard extends StatelessWidget {
  final Album album;
  final bool useHero;
  final bool fullWidth;

  const HomeAlbumCard({
    super.key,
    required this.album,
    this.useHero = true,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    // 🔑 Give fixed height in vertical list mode
    final double cardHeight = fullWidth ? 230 : 230;
    final double cardWidth = fullWidth ? double.infinity : 320;

    final card = SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Container(
        margin: EdgeInsets.only(left: fullWidth ? 0 : 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand, // ✅ now bounded by SizedBox
            children: [
              // Cover image
              PopInCardImages(
                imagePath: album.coverImage,
                isNetwork: true,
                delay: const Duration(milliseconds: 150),
              ),

              // Overlay
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color.fromARGB(230, 11, 11, 11),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        album.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: commonWhiteColor,
                          fontSize: cardTitleFontSize,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: commonWhiteColor,
                                  size: normalTextFontSize),
                              const SizedBox(width: 4),
                              Text(
                                album.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: commonWhiteColor,
                                  fontSize: normalTextFontSize,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.library_music,
                                  size: 22, color: Colors.white),
                              const SizedBox(width: 5),
                              Text(
                                "${album.itemCount}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: commonWhiteColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final tappable = GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AlbumDetailPage(album: album, initialIndex: 0),
          ),
        );
      },
      child: useHero
          ? Hero(
              tag: 'album_${album.id ?? album.name}_image',
              child: card,
            )
          : card,
    );

    return Semantics(container: true, child: tappable);
  }
}
