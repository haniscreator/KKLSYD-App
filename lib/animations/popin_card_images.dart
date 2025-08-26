import 'package:flutter/material.dart';
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

  //static const String storageUrl = "https://www.ads.panacea-soft.com/storage/";

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
        ? Image.network(
            AppConfig.storageUrl + widget.imagePath, // ✅ prepend storage URL
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            },
          )
        : Image.asset(
            widget.imagePath,
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
