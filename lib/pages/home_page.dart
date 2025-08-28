import 'package:flutter/material.dart';
import 'package:travel_in_chiangmai/widgets/home_location_dropdown.dart';
import 'package:travel_in_chiangmai/widgets/home_popular_place_section.dart';
import 'package:travel_in_chiangmai/widgets/home_recommend_package_section.dart';
import 'package:travel_in_chiangmai/widgets/home_theme_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<HomePopularPlaceSectionState> _popularKey = GlobalKey();
  final GlobalKey<HomeRecommendPackageSectionState> _recommendKey =
      GlobalKey<HomeRecommendPackageSectionState>();

  Future<void> _handleRefresh() async {
    // 🔄 Call refresh functions inside child widgets after the current frame
    await Future.delayed(const Duration(milliseconds: 50));
    await Future.wait([
      _popularKey.currentState?.reloadAlbums() ?? Future.value(),
      _recommendKey.currentState?.reloadItems() ?? Future.value(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: headerParts(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
          children: [
            HomePopularPlaceSection(key: _popularKey),
            const SizedBox(height: 20),
            HomeRecommendPackageSection(key: _recommendKey),
          ],
        ),
      ),
    );
  }

  AppBar headerParts() {
    final theme = Theme.of(context);
    return AppBar(
      elevation: 0,
      backgroundColor:
          theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          //HomeLocationDropdown(),
          HomeThemeIcon(),
        ],
      ),
    );
  }
}
