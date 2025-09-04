import 'dart:math';

Random random = Random();

// Data Preparation Start from Here //
class PopularPlaces {
  final int id, price, review;
  final List<String>? image;
  final String name, description, category, location;
  final double rate;

  PopularPlaces({
    required this.name,
    required this.id,
    required this.category,
    required this.description,
    required this.image,
    required this.rate,
    required this.location,
    required this.price,
    required this.review,
  });
}

List<PopularPlaces> popularPlace = [
  PopularPlaces(
    id: 1,
    name: "၁၀ရက် တရားစခန်း",
    category: 'popular',
    image: [
      'assets/images/thumbnail/album_cover.png',

      'assets/images/doi_suthet/2.jpg',
      'assets/images/doi_suthet/3.jpg',
    ],
    location: "ရန်ကုန်မြို့ မိုးကုတ် အဖွဲ့ချုပ်",
    rate: 4.8,
    review: random.nextInt(300) + 25,
    price: 1000,
    description:
        "Wat Phra That Doi Suthep is a sacred temple perched atop Doi Suthep mountain, offering panoramic views of Chiang Mai and a deep cultural experience.",
  ),
  PopularPlaces(
    id: 2,
    name: "၁၀ရက် တရားစခန်း",
    category: 'popular',
    image: [
      'assets/images/thumbnail/thumbnail.png',
      'assets/images/old_city/1.jpg',
      'assets/images/old_city/2.jpg',
      'assets/images/old_city/3.jpg',
    ],
    location: "ရန်ကုန်မြို့ ဇနိတာရာမကျောင်း",
    rate: 4.7,
    review: random.nextInt(300) + 25,
    price: 1000,
    description:
        "The Old City of Chiang Mai is home to numerous ancient temples like Wat Chedi Luang and Wat Phra Singh, rich in history and architecture.",
  ),
  PopularPlaces(
    id: 3,
    name: "ကျိုက္ကလော့ ၇ ရက် တရားစခန်း",
    category: 'popular',
    image: [
      'assets/images/doi_suthet/test1.png',
      'assets/images/chaloem_park/1.jpg',
      'assets/images/chaloem_park/1.jpg',
      'assets/images/chaloem_park/2.jpg',
      'assets/images/chaloem_park/3.jpg',
    ],
    location: "ရန်ကုန်တိုင်း၊ မင်္ဂလာဒုံ",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 1000,
    description:
        "A peaceful urban park in Chiang Mai known for its scenic lake, walking paths, and relaxing atmosphere—perfect for jogging, picnics, and family outings.",
  ),
  PopularPlaces(
    id: 4,
    name: "Mae Kam Png Village",
    category: 'popular',
    image: [
      'assets/images/mae_kam_pong/1.jpg',
      'assets/images/mae_kam_pong/2.jpg',
      'assets/images/mae_kam_pong/3.jpg',
      'assets/images/mae_kam_pong/4.jpg',
      'assets/images/mae_kam_pong/5.jpg',
    ],
    location: "Mae Kampong Village",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 1000,
    description:
        "Mae Kampong is a serene mountain village nestled in Chiang Mai's Mae On District, renowned for its lush landscapes, traditional wooden homes, and community-driven eco-tourism. Visitors can enjoy homestays, explore the seven-tier Mae Kampong Waterfall, savor locally grown coffee, and experience the tranquil charm of Northern Thai culture.",
  ),
  PopularPlaces(
    id: 5,
    name: "Nimmanhaemin Road",
    category: 'popular',
    image: [
      'assets/images/nimman_road/1.jpg',
      'assets/images/nimman_road/2.jpg',
      'assets/images/nimman_road/3.jpg',
      'assets/images/nimman_road/4.jpg',
    ],
    location: "Nimman",
    rate: 4.5,
    review: random.nextInt(300) + 25,
    price: 1000,
    description:
        "Trendy area known for its cafes, art galleries, boutique shops, and nightlife, perfect for modern lifestyle exploration.",
  ),
  PopularPlaces(
    id: 6,
    name: "Chiang Mai Night Bazaar",
    category: 'popular',
    image: [
      'assets/images/night_market/1.jpg',
      'assets/images/night_market/2.jpg',
      'assets/images/night_market/3.jpg',
      'assets/images/night_market/4.jpg',
    ],
    location: "Chang Klan Road",
    rate: 4.6,
    review: random.nextInt(300) + 25,
    price: 1000,
    description:
        "A vibrant night market offering local food, souvenirs, crafts, and live entertainment, showcasing Chiang Mai’s lively street culture.",
  ),
];

////  //// ///  ///
/// For Package ///
////  //// ///  ///

List<String> categories = ['Popular', 'Budget', 'Luxury', 'Recommend'];

class AllPackages {
  final int id, price, review;
  final List<String>? image;
  final String name, description, category, location;
  final double rate;

  AllPackages({
    required this.name,
    required this.id,
    required this.category,
    required this.description,
    required this.image,
    required this.rate,
    required this.location,
    required this.price,
    required this.review,
  });
}

List<AllPackages> allPackage = [
  AllPackages(
    id: 1,
    name: "၂၀-၃-၂၀၀၂ နံနက် ပဋိစ္စသမုပ္ပါဒ် သင်တန်းတရား",
    category: 'Recommend',
    image: [
      'assets/images/thumbnail/thumbnail4.png',
      'assets/images/packages/22.jpg',
      'assets/images/packages/2.jpg',
      'assets/images/packages/3.jpg',
    ],
    location: "မိုးကုတ် အဖွဲ့ချုပ်",
    rate: 4.8,
    review: random.nextInt(300) + 25,
    price: 650,
    description:
        "Explore historic temples, local markets, and the charming streets of Chiang Mai’s Old City on this guided tour.",
  ),
  AllPackages(
    id: 2,
    name: "၂၀-၅-၂၀၀၂ ညနေ ခန္ဓာဉာဏ်ရောက် သစ္စာပေါက်တရား",
    category: 'Recommend',
    image: [
      'assets/images/thumbnail/thumbnail4.png',
      'assets/images/packages/20.jpg',
      'assets/images/packages/5.jpg',
      'assets/images/packages/6.jpg',
    ],
    location: "ဇနိတာရာမကျောင်း",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 750,
    description:
        "Hike up Doi Suthep in the early morning and witness the stunning sunrise over Chiang Mai from the sacred temple viewpoint.",
  ),
  AllPackages(
    id: 3,
    name: "ဝိပဿနာ အလုပ်ပေးတရားတော်",
    category: 'Recommend',
    image: [
      'assets/images/thumbnail/thumbnail.png',
      'assets/images/packages/24.jpg',
      'assets/images/packages/8.jpg',
      'assets/images/packages/9.jpg',
    ],
    location: "မိုးကုတ် အဖွဲ့ချုပ်",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 1200,
    description:
        "Spend a day at an ethical elephant sanctuary learning about and interacting with these gentle giants in their natural habitat.",
  ),
  AllPackages(
    id: 4,
    name: "၅-၅-၂၀၀၃ ညနေ ခန္ဓာဉာဏ်ရောက် သစ္စာပေါက်တရား",
    category: 'Recommend',
    image: [
      'assets/images/thumbnail/thumbnail.png',
      'assets/images/packages/10.jpg',
      'assets/images/packages/11.jpg',
      'assets/images/packages/12.jpg',
    ],
    location: "မိုးကုတ် အဖွဲ့ချုပ်",
    rate: 4.7,
    review: random.nextInt(300) + 25,
    price: 950,
    description:
        "Visit Thailand’s highest peak, beautiful waterfalls, and twin royal pagodas in Doi Inthanon National Park.",
  ),
  AllPackages(
    id: 5,
    name: " ၆-၂-၂၀၀၆ နံနက် ပဋိစ္စသမုပ္ပါဒ် သင်တန်းတရား",
    category: 'Recommend',
    image: [
      'assets/images/thumbnail/thumbnail.png',
      'assets/images/packages/25.jpg',
      'assets/images/packages/14.jpg',
      'assets/images/packages/15.jpg',
    ],
    location: "ကျိုက္ကလော့",
    rate: 4.8,
    review: random.nextInt(300) + 25,
    price: 850,
    description:
        "Experience a peaceful day in Mae Kampong village with traditional Thai culture, local food, and scenic views.",
  ),
  AllPackages(
    id: 6,
    name: "Chiang Rai White Temple & Blue Temple Day Trip",
    category: 'Popular',
    image: [
      'assets/images/packages/26.jpg',
      'assets/images/packages/17.jpg',
      'assets/images/packages/18.jpg',
    ],
    location: "Chiang Rai",
    rate: 4.6,
    review: random.nextInt(300) + 25,
    price: 700,
    description:
        "Join an exciting tram ride through the Chiang Mai Night Safari and observe nocturnal animals in a natural environment.",
  ),
  AllPackages(
    id: 7,
    name: "Pai Canyon Sunset & Hot Springs Escape",
    category: 'Popular',
    image: [
      'assets/images/packages/21.jpg',
      'assets/images/packages/20.jpg',
      'assets/images/packages/19.jpg',
    ],
    location: "Pai",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 950,
    description:
        "Experience the beauty, culture, and nature of Northern Thailand with guided tours through iconic destinations like Chiang Mai, Pai, and Chiang Rai.",
  ),
  AllPackages(
    id: 8,
    name: "Chiang Dao Cave & Jungle Trek",
    category: 'Popular',
    image: [
      'assets/images/packages/19.jpg',
      'assets/images/packages/23.jpg',
      'assets/images/packages/24.jpg',
    ],
    location: "Chiang Dao",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 950,
    description:
        "Experience the beauty, culture, and nature of Northern Thailand with guided tours through iconic destinations like Chiang Mai, Pai, and Chiang Rai.",
  ),
  AllPackages(
    id: 9,
    name: "Doi Pui Hmong Village Cultural Experience",
    category: 'Budget',
    image: [
      'assets/images/packages/19.jpg',
      'assets/images/packages/20.jpg',
      'assets/images/packages/21.jpg',
    ],
    location: "Doi Pui",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 950,
    description:
        "Experience the beauty, culture, and nature of Northern Thailand with guided tours through iconic destinations like Chiang Mai, Pai, and Chiang Rai.",
  ),
  AllPackages(
    id: 10,
    name: "Golden Triangle & Mekong River Cruise",
    category: 'Budget',
    image: [
      'assets/images/packages/19.jpg',
      'assets/images/packages/20.jpg',
      'assets/images/packages/21.jpg',
    ],
    location: "Pai",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 950,
    description:
        "Experience the beauty, culture, and nature of Northern Thailand with guided tours through iconic destinations like Chiang Mai, Pai, and Chiang Rai.",
  ),
  AllPackages(
    id: 11,
    name: "Pai Countryside by Scooter Tour",
    category: 'Luxury',
    image: [
      'assets/images/packages/5.jpg',
      'assets/images/packages/20.jpg',
      'assets/images/packages/21.jpg',
    ],
    location: "Pai",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 950,
    description:
        "Experience the beauty, culture, and nature of Northern Thailand with guided tours through iconic destinations like Chiang Mai, Pai, and Chiang Rai.",
  ),
  AllPackages(
    id: 12,
    name: "Ride to Pai",
    category: 'Luxury',
    image: [
      'assets/images/packages/8.jpg',
      'assets/images/packages/20.jpg',
      'assets/images/packages/21.jpg',
    ],
    location: "Chiang Mai",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 950,
    description:
        "Experience the beauty, culture, and nature of Northern Thailand with guided tours through iconic destinations like Chiang Mai, Pai, and Chiang Rai.",
  ),
  AllPackages(
    id: 13,
    name: "Chiang Mai Elephant Sanctuary Visit",
    category: 'Budget',
    image: [
      'assets/images/packages/11.jpg',
      'assets/images/packages/20.jpg',
      'assets/images/packages/21.jpg',
    ],
    location: "Chiang Mai",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 950,
    description:
        "Experience the beauty, culture, and nature of Northern Thailand with guided tours through iconic destinations like Chiang Mai, Pai, and Chiang Rai.",
  ),
  AllPackages(
    id: 14,
    name: "Tea Plantation Hike in Chiang Rai Hills",
    category: 'Luxury',
    image: [
      'assets/images/packages/12.jpg',
      'assets/images/packages/20.jpg',
      'assets/images/packages/21.jpg',
    ],
    location: "Chiang Rai",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 950,
    description:
        "Experience the beauty, culture, and nature of Northern Thailand with guided tours through iconic destinations like Chiang Mai, Pai, and Chiang Rai.",
  ),
  AllPackages(
    id: 15,
    name: "Hill Tribe Trek & Homestay in Chiang Dao",
    category: 'Budget',
    image: [
      'assets/images/packages/13.jpg',
      'assets/images/packages/20.jpg',
      'assets/images/packages/21.jpg',
    ],
    location: "Chiang Dao",
    rate: 4.9,
    review: random.nextInt(300) + 25,
    price: 950,
    description:
        "Experience the beauty, culture, and nature of Northern Thailand with guided tours through iconic destinations like Chiang Mai, Pai, and Chiang Rai.",
  ),
];

////  //// /// ///
/// For Review ///
////  //// /// ///

class Review {
  final String name;
  final String comment;
  final String photo;

  Review({required this.name, required this.comment, required this.photo});
}

List<Review> userReviews = [
  Review(
    name: "၂၀-၃-၂၀၀၂ နံနက် ပဋိစ္စသမုပ္ပါဒ် သင်တန်းတရား",
    comment: "- မိုးကုတ် အဖွဲ့ချုပ်",
    photo: 'assets/images/thumbnail/thumbnail3.png',
  ),
  Review(
    name: "၂၀-၃-၂၀၀၂ နံနက် ပဋိစ္စသမုပ္ပါဒ် သင်တန်းတရား",
    comment: "- မိုးကုတ် အဖွဲ့ချုပ်",
    photo: 'assets/images/thumbnail/thumbnail4.png',
  ),
  Review(
    name: "၂၁-၃-၂၀၀၂ နံနက် ပဋိစ္စသမုပ္ပါဒ် သင်တန်းတရား",
    comment: "- မိုးကုတ် အဖွဲ့ချုပ်",
    photo: 'assets/images/thumbnail/thumbnail2.png',
  ),
  Review(
    name: "၂၁-၃-၂၀၀၂ နံနက် ပဋိစ္စသမုပ္ပါဒ် သင်တန်းတရား",
    comment: "- မိုးကုတ် အဖွဲ့ချုပ်",
    photo: 'assets/images/thumbnail/thumbnail5.png',
  ),
  Review(
    name: "၂၁-၃-၂၀၀၂ နံနက် ပဋိစ္စသမုပ္ပါဒ် သင်တန်းတရား",
    comment: "- မိုးကုတ် အဖွဲ့ချုပ်",
    photo: 'assets/images/thumbnail/thumbnail2.png',
  ),
];

////  //// /// /// ///
/// For Onboarding ///
////  //// /// /// ///

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
    image: 'assets/images/splash_bg.png',
    title: 'ဗုဒ္ဓံပူဇေမိ',
    description: 'Take only memories, leave only footprints behind.',
  ),

  OnboardModel(
    image: 'assets/images/splash_bg.png',
    title: 'ဗုဒ္ဓသာသနံ',
    description: 'Travel is the only thing you buy that makes you richer. ',
  ),
  OnboardModel(
    image: 'assets/images/splash_bg.png',
    title: "စိရံတိဌတု",
    description: 'Life begins at the end of your comfort zone.',
  ),
];

////  //// /// ///
/// City List  ///
////  //// /// ///

const List<String> cityList = [
  'Chiang Mai',
  'Bangkok',
  'Phuket',
  'Pai',
  'Chiang Rai',
];

String defaultCity = cityList[0];
