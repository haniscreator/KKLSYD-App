import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_in_chiangmai/pages/splashscreen_page.dart';
import 'package:travel_in_chiangmai/providers/theme_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: "KKLSYD",
      debugShowCheckedModeBanner: false,
      theme: themeState.themeData,
      home: const SplashScreenPage(),
    );
  }
}
