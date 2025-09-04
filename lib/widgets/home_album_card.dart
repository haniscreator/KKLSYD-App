import 'package:flutter/material.dart';
import 'package:kklsyd_app/animations/popin_card_images.dart';
import 'package:kklsyd_app/const/const.dart';
import 'package:kklsyd_app/models/album.dart';
import 'package:kklsyd_app/pages/album_detail_page.dart';

class HomeAlbumCard extends StatelessWidget {
  final Album album;
  final bool useHero;
  final bool fullWidth;
  final bool verticalMode;
  final int index;

  const HomeAlbumCard({
    super.key,
    required this.album,
    this.useHero = true,
    this.fullWidth = false,
    this.verticalMode = false,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final double cardHeight = 250;
    final double cardWidth = fullWidth ? double.infinity : 320;

    // ✅ Even/Odd logic for image
    /*
    final String finalImagePath =
        (index % 2 == 0)
            ? "assets/images/album_cover/2.png"
            : "assets/images/album_cover/1.png"; */

    final String finalImagePath = "assets/images/album_cover/1.png";

    final card = SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Container(
        margin: EdgeInsets.only(
          left: fullWidth ? 0 : 12,
          top: verticalMode ? 12 : 0,
          bottom: verticalMode ? 12 : 0,
        ),
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
            fit: StackFit.expand,
            children: [
              PopInCardImages(
                imagePath: finalImagePath,
                isNetwork: false,
                delay: const Duration(milliseconds: 150),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  // decoration: BoxDecoration(
                  //   color: Colors.white.withOpacity(0.7),
                  //   borderRadius: BorderRadius.circular(8),
                  // ),
                  child: Text(
                    album.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: cardTitleFontSize,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: commonWhiteColor,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              album.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: commonWhiteColor,
                                fontSize: normalTextFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.library_music,
                            size: 20,
                            color: Colors.white,
                          ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final tappable = GestureDetector(
      onTap: () {
        // 🔹 Debug
        print(
          "Tapped AlbumCard: ID=${album.id}, Name=${album.name}, Image=$finalImagePath",
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => AlbumDetailPage(
                  album: album,
                  initialIndex: 0,
                  coverImagePath: finalImagePath,
                ),
          ),
        );
      },
      child:
          useHero
              ? Hero(tag: 'album_${album.id}_${album.name}_image', child: card)
              : card,
    );

    return Semantics(container: true, child: tappable);
  }
}
