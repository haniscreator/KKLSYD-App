import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:travel_in_chiangmai/config.dart';

class PopInCardImages extends StatefulWidget {
  final String imagePath;
  final Duration delay;
  final bool isNetwork; // ✅ true for network images

  const PopInCardImages({
    super.key,
    required this.imagePath,
    required this.delay,
    this.isNetwork = false, // default: asset
  });

  @override
  State<PopInCardImages> createState() => _PopInCardImagesState();
}

class _PopInCardImagesState extends State<PopInCardImages>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;
  double _scale = 0.9;

  @override
  void initState() {
    super.initState();
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
    final imageWidget = widget.isNetwork
        ? CachedNetworkImage(
            imageUrl: AppConfig.storageUrl + widget.imagePath,
            fit: BoxFit.cover,
            placeholder: (context, url) => Image.asset(
              "assets/images/default_cover.png",
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/default_cover.png",
              fit: BoxFit.cover,
            ),
          )
        : Image.asset(
            widget.imagePath.isNotEmpty
                ? widget.imagePath
                : "assets/images/default_cover.png", // ✅ fallback for asset
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
