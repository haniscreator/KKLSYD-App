import 'package:flutter/material.dart';
import 'package:travel_in_chiangmai/models/album.dart'; // ✅ New API model
import 'package:travel_in_chiangmai/widgets/detail_overview_tab.dart';

import 'package:travel_in_chiangmai/widgets/detail_album_tab_bar.dart';
import 'package:travel_in_chiangmai/widgets/detail_about_ablum_tab.dart';
import 'package:travel_in_chiangmai/config.dart';

class AlbumDetailPage extends StatefulWidget {
  final Album album; // ✅ replace PopularPlaces with Album
  final int initialIndex;

  const AlbumDetailPage({
    super.key,
    required this.album,
    required this.initialIndex,
  });

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.appBarTheme.backgroundColor,
            foregroundColor: theme.appBarTheme.iconTheme?.color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
            title: Text(
              widget.album.name, // ✅ album name from API
              style: theme.appBarTheme.titleTextStyle,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  AppConfig.storageUrl + widget.album.coverImage, // ✅ use storageUrl from config
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 220,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 220,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ),

          DetailAlbumTabBar(tabController: _tabController),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
             DetailItemsListTab(albumId: widget.album.id),
             AboutAlbumTab(description: widget.album.description),
          ],
        ),
      ),
    );
  }
}
