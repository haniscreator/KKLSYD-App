import 'package:flutter/material.dart';
import 'package:kklsyd_app/models/album.dart';
import 'package:kklsyd_app/widgets/detail_overview_tab.dart';
import 'package:kklsyd_app/widgets/detail_album_tab_bar.dart';
import 'package:kklsyd_app/widgets/detail_about_ablum_tab.dart';

class AlbumDetailPage extends StatefulWidget {
  final Album album;
  final int initialIndex;
  final String coverImagePath;

  const AlbumDetailPage({
    super.key,
    required this.album,
    required this.initialIndex,
    required this.coverImagePath,
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

    // 🔹 Debug
    print(
      "AlbumDetailPage init: ID=${widget.album.id}, Name=${widget.album.name}, coverImagePath=${widget.coverImagePath}",
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(widget.album.name),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.coverImagePath, // ✅ use same image passed
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 220,
                      errorBuilder: (context, error, stackTrace) {
                        print("Error loading image: $error");
                        return Container(
                          height: 220,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Colors.grey,
                          ),
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
