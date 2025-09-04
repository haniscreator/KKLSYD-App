import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kklsyd_app/Config/config.dart';

class PopInCardImages extends StatefulWidget {
  final String imagePath;
  final Duration delay;
  final bool isNetwork; // ✅ true = API, false = local random

  const PopInCardImages({
    super.key,
    required this.imagePath,
    required this.delay,
    this.isNetwork = false,
  });

  @override
  State<PopInCardImages> createState() => _PopInCardImagesState();
}

class _PopInCardImagesState extends State<PopInCardImages>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;
  double _scale = 0.9;
  late String _randomImage;

  @override
  void initState() {
    super.initState();

    // 🎲 Pick a random image for local assets (1.png - 5.png)
    final random = Random();
    int randomIndex = random.nextInt(5) + 1; // 1 → 5
    _randomImage = "assets/images/album_cover/$randomIndex.png";

    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _opacity = 1;
          _scale = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget =
        widget.isNetwork
            ? CachedNetworkImage(
              imageUrl: AppConfig.storageUrl + widget.imagePath,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Image.asset(
                    "assets/images/default_cover.png",
                    fit: BoxFit.cover,
                  ),
              errorWidget:
                  (context, url, error) => Image.asset(
                    "assets/images/default_cover.png",
                    fit: BoxFit.cover,
                  ),
            )
            : Image.asset(
              _randomImage, // ✅ random local image
              fit: BoxFit.cover,
            );

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 500),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageWidget,
        ),
      ),
    );
  }
}
