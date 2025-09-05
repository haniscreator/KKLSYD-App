import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
      // ⚠️ If results is a list, take the first item (or default to none)
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

  @override
  Widget build(BuildContext context) {
    if (_checkingConnectivity || _connectivityResult == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_connectivityResult == ConnectivityResult.none) {
      return Scaffold(
        appBar: const HomeAppBarSection(),
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
      appBar: const HomeAppBarSection(),
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
