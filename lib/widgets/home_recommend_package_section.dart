import 'package:flutter/material.dart';
import 'package:travel_in_chiangmai/const/const.dart';
import 'package:travel_in_chiangmai/models/item.dart';
import 'package:travel_in_chiangmai/services/item_service.dart';
import 'package:travel_in_chiangmai/widgets/home_recommend_package_card.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeRecommendPackageSection extends StatefulWidget {
  const HomeRecommendPackageSection({super.key});

  @override
  State<HomeRecommendPackageSection> createState() =>
      _HomeRecommendPackageSectionState();
}

class _HomeRecommendPackageSectionState
    extends State<HomeRecommendPackageSection> {
  final ItemService _itemService = ItemService();
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = _itemService.fetchItems(
      0,
      perPage: 5,
      orderBy: "created_at",
      orderDir: "desc",
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "နောက်ဆုံးထွက် Items များ",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: sectionTitleFontSize,
                  fontWeight: textFontWeight,
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                  fontSize: smallTextFontSize,
                  color: isDark ? Colors.lightBlue[200] : Colors.blue,
                ),
              ),
            ],
          ),
        ),
        FutureBuilder<List<Item>>(
          future: _futureItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 🔥 Shimmer Loading Placeholder
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: 3, // number of shimmer cards
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Shimmer(
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Thumbnail shimmer
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            // Text shimmer
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 15,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      color: Colors.grey[400],
                                    ),
                                    Container(
                                      height: 15,
                                      width: 150,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Failed to load items: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text("No items available."),
              );
            }

            final items = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return HomeRecommendPackageCard(item: items[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
