/// For Onboarding ///
class OnboardModel {
  String image, title, description;

  OnboardModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardModel> onboarding = [
  OnboardModel(
    image: 'assets/images/splash_bg_3.png',
    title: 'ဗုဒ္ဓံပူဇေမိ',
    description: '',
  ),

  OnboardModel(
    image: 'assets/images/splash_bg_3.png',
    title: 'ဗုဒ္ဓသာသနံ',
    description: '',
  ),
  OnboardModel(
    image: 'assets/images/splash_bg_3.png',
    title: "စိရံတိဌတု",
    description: '',
  ),
];
