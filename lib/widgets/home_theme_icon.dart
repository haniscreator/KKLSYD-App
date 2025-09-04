import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kklsyd_app/providers/theme_providers.dart';

class HomeThemeIcon extends ConsumerWidget {
  const HomeThemeIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final isDarkMode = themeState.appTheme == AppTheme.dark;

    return GestureDetector(
      onTap: () {
        ref.read(themeProvider.notifier).toggleTheme(); // 👈 Riverpod toggle
      },
      child: Icon(
        isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
