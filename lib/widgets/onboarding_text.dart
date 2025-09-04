import 'package:flutter/material.dart';
import 'package:kklsyd_app/const/const.dart';
import 'package:kklsyd_app/models/data_model.dart';

class OnboardingText extends StatelessWidget {
  final int currentIndex;
  const OnboardingText({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 🔹 centers vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // 🔹 centers horizontally
          children: [
            // Title with outline effect
            Stack(
              children: [
                Text(
                  onboarding[currentIndex].title,
                  style: const TextStyle(fontSize: 48),
                ),
                Text(
                  onboarding[currentIndex].title,
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white, // main text
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description with outline effect
            if (isShowDescOnboarding)
              Stack(
                children: [
                  Text(
                    onboarding[currentIndex].description,
                    style: TextStyle(
                      fontSize: 17,
                      foreground:
                          Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1
                            ..color = Colors.black,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    onboarding[currentIndex].description,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
