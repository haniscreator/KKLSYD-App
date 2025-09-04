import 'package:flutter/material.dart';
import 'package:kklsyd_app/widgets/onboarding_image.dart';
import 'package:kklsyd_app/widgets/onboarding_text.dart';
import 'package:kklsyd_app/widgets/onboarding_bottom_panel.dart';
import 'package:kklsyd_app/models/data_model.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentIndex = 0;
  //late TapGestureRecognizer _loginTapRecognizer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //_loginTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: onboarding.length,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingImage(index: index);
            },
          ),
          OnboardingText(currentIndex: currentIndex),
          Align(
            alignment: Alignment.bottomCenter,
            child: OnboardingBottomPanel(currentIndex: currentIndex),
          ),
        ],
      ),
    );
  }
}
