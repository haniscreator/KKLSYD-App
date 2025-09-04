import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kklsyd_app/const/const.dart';
import 'package:kklsyd_app/pages/item_list_page.dart';
import 'package:kklsyd_app/providers/item_providers.dart';
import 'package:kklsyd_app/services/item_service.dart';
import 'package:kklsyd_app/widgets/home_latest_item_card.dart';

class HomeLatestItemSection extends ConsumerWidget {
  const HomeLatestItemSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(latestItemsProvider);
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
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ItemListPage()),
                  );
                },
                child: Text(
                  "See All",
                  style: TextStyle(
                    fontSize: smallTextFontSize,
                    color: isDark ? Colors.lightBlue[200] : Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Show list first and refresh on top
        asyncItems.when(
          loading:
              () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
          error:
              (error, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Failed to load items: $error",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          data: (items) {
            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text("တရားတော်များ မရှိသေးပါ။"),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                // Force refresh but keep old items visible
                final service = ItemService();
                final freshItems = await service.fetchItems(
                  0,
                  perPage: 5,
                  orderBy: "created_at",
                  orderDir: "desc",
                  forceRefresh: true, // bypass cache
                  cacheTTL: const Duration(minutes: 10),
                );

                // Update provider with fresh items
                ref.invalidate(latestItemsProvider);
              },
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return HomeLatestItemCard(item: items[index]);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
