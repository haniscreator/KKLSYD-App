import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_in_chiangmai/providers/item_providers.dart';
import 'package:travel_in_chiangmai/widgets/home_album_section.dart';
import 'package:travel_in_chiangmai/widgets/home_latest_item_section.dart';
import 'package:travel_in_chiangmai/widgets/home_theme_icon.dart';
import 'package:travel_in_chiangmai/providers/album_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Future<void> _handleRefresh() async {
      // refresh all async providers
      ref.refresh(albumsProvider);
      ref.refresh(latestItemsProvider);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: headerParts(context),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
          children: const [
            HomeAlbumSection(),
            SizedBox(height: 20),
            HomeLatestItemSection(), // we’ll migrate this later
          ],
        ),
      ),
    );
  }

  AppBar headerParts(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      elevation: 0,
      backgroundColor:
          theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          HomeThemeIcon(),
        ],
      ),
    );
  }
}
