import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kklsyd_app/pages/home_page.dart';
import 'package:kklsyd_app/pages/onboarding_page.dart';
import 'package:kklsyd_app/providers/theme_providers.dart';
import 'package:kklsyd_app/services/onboarding_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // check onboarding before runApp
  final seenOnboarding = await OnBoardingService.hasSeenOnboarding();

  runApp(ProviderScope(child: MyApp(seenOnboarding: seenOnboarding)));
}

class MyApp extends ConsumerWidget {
  final bool seenOnboarding;

  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: "KyaikkalotSaradaw",
      debugShowCheckedModeBanner: false,
      theme: themeState.themeData,
      home: seenOnboarding ? const HomePage() : const OnBoardingPage(),
    );
  }
}
