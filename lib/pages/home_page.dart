import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:kklsyd_app/const/const.dart';
import 'package:kklsyd_app/providers/album_providers.dart';
import 'package:kklsyd_app/providers/item_providers.dart';
import 'package:kklsyd_app/widgets/home_album_section.dart';
import 'package:kklsyd_app/widgets/home_latest_item_section.dart';
import 'package:kklsyd_app/widgets/home_appbar_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ConnectivityResult? _connectivityResult;
  bool _checkingConnectivity = true;

  bool _isClearingCache = false; // state for showing Lottie animation

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    setState(() {
      _checkingConnectivity = true;
    });

    try {
      final results = await Connectivity().checkConnectivity();
      final result =
          (results.isNotEmpty) ? results.first : ConnectivityResult.none;

      setState(() {
        _connectivityResult = result;
        _checkingConnectivity = false;
      });
      debugPrint('Connectivity result: $result');
    } catch (e) {
      debugPrint('Connectivity check failed: $e');
      setState(() {
        _connectivityResult = ConnectivityResult.none;
        _checkingConnectivity = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    ref.refresh(albumsProvider);
    ref.refresh(latestItemsProvider);
  }

  Future<void> _clearCacheAndReload() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Clear Cache"),
            content: const Text("Are you sure you want to clear cache data?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Yes"),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() => _isClearingCache = true);

      // Clear cache logic here (Hive/SharedPrefs/db)
      await Future.delayed(const Duration(seconds: 1));

      // Force reload providers
      ref.invalidate(albumsProvider);
      ref.invalidate(latestItemsProvider);

      // Wait for reload (simulate API fetching)
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isClearingCache = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isClearingCache) {
      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.7),
        body: Center(
          child: Lottie.asset(
            "assets/lotties/loading.json",
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    if (_checkingConnectivity || _connectivityResult == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_connectivityResult == ConnectivityResult.none) {
      return Scaffold(
        appBar: HomeAppBarSection(onClearCache: _clearCacheAndReload),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                txtGeneralNoInternet_MM,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkConnectivity,
                child: const Text(txtTryAgain_MM),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: HomeAppBarSection(onClearCache: _clearCacheAndReload),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            top: 20,
            left: 0,
            right: 0,
            bottom: 16,
          ),
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
