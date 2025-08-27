import 'package:flutter/material.dart';
import 'package:travel_in_chiangmai/const/const.dart';
import 'package:travel_in_chiangmai/models/item.dart';
import 'package:travel_in_chiangmai/services/item_service.dart';
import 'package:travel_in_chiangmai/widgets/home_recommend_package_card.dart';

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
    // ✅ Fetch latest items (no album filter => 0 = all albums)
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
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
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
