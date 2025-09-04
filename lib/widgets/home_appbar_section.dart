import 'package:flutter/material.dart';
import 'package:kklsyd_app/animations/glow_avatar.dart';
import 'package:kklsyd_app/widgets/home_theme_icon.dart';

class HomeAppBarSection extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarSection({super.key});

  void _openProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8, // default height (90% of screen)
          minChildSize: 0.2, // minimum height
          maxChildSize: 0.8, // maximum height when expanded
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: const [
                    // Profile avatar centered
                    SizedBox(height: 8),
                    GlowAvatar(radius: 30),
                    SizedBox(height: 16),

                    // Sample paragraph
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      "Vivamus at elit nec nulla efficitur facilisis. "
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      "Vivamus at elit nec nulla efficitur facilisis.\n "
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      "Vivamus at elit nec nulla efficitur facilisis. "
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      "Vivamus at elit nec nulla efficitur facilisis.\n\n "
                      "Contact Us : "
                      "09-879999090 \n\n"
                      "Address : No.1, Yangon Myanmar "
                      "Curabitur a neque eu neque facilisis luctus.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      backgroundColor:
          theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Glow avatar with ripple + tap
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _openProfileBottomSheet(context),
              child: const GlowAvatar(radius: 18),
            ),
          ),
          const SizedBox(width: 12),

          // Two-line text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Welcome back,",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  "Makenna Donin", // later replace with dynamic data
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Right side icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.flash_on, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 12),
              const HomeThemeIcon(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
