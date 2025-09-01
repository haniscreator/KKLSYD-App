import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_in_chiangmai/providers/item_providers.dart';
import 'package:travel_in_chiangmai/widgets/home_album_section.dart';
import 'package:travel_in_chiangmai/widgets/home_latest_item_section.dart';
import 'package:travel_in_chiangmai/providers/album_providers.dart';
import 'package:travel_in_chiangmai/widgets/home_appbar_section.dart'; 

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
      appBar: const HomeAppBarSection(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 16),
          children: const [
            HomeAlbumSection(),
            SizedBox(height: 20),
            HomeLatestItemSection(),
          ],
        ),
      ),
    );
  }
}
