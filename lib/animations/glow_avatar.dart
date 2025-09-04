import 'package:flutter/material.dart';

class GlowAvatar extends StatefulWidget {
  final double radius;
  final String imagePath;

  const GlowAvatar({
    super.key,
    this.radius = 20, // default smaller for AppBar
    this.imagePath = 'assets/images/avatar.jpg',
  });

  @override
  State<GlowAvatar> createState() => _GlowAvatarState();
}

class _GlowAvatarState extends State<GlowAvatar>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(252, 232, 161, 1).withOpacity(0.6),
              blurRadius: 12,
              spreadRadius: 3,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: widget.radius,
          backgroundImage: AssetImage(widget.imagePath),
        ),
      ),
    );
  }
}
