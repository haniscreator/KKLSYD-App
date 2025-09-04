import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kklsyd_app/Config/config.dart';
import 'package:kklsyd_app/const/const.dart';
import 'package:kklsyd_app/pages/item_list_page.dart';
import 'package:kklsyd_app/providers/item_providers.dart';
import 'package:kklsyd_app/services/item_service.dart';
import 'package:kklsyd_app/widgets/home_latest_item_card.dart';
import 'package:kklsyd_app/pages/audioplayer_page.dart';

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
                final service = ItemService();
                await service.fetchItems(
                  0,
                  perPage: 5,
                  orderBy: "created_at",
                  orderDir: "desc",
                  forceRefresh: true,
                  cacheTTL: const Duration(minutes: 10),
                );

                ref.invalidate(latestItemsProvider);
              },
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: _TapScaleWrapper(
                      onTap: () {
                        final fullAudioUrl =
                            AppConfig.storageUrl + item.mediaUrl;

                        print(
                          "Tapped item: ID=${item.id}, name=${item.name}, url=$fullAudioUrl",
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AudioPlayerPage(
                                  audioUrl: fullAudioUrl, // ✅ full URL
                                  title: item.name,
                                  image:
                                      'assets/images/thumbnail/thumbnail5.png',
                                ),
                          ),
                        );
                      },

                      child: HomeLatestItemCard(item: item),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

/// --------------------
/// Tap Scale Wrapper
/// --------------------
class _TapScaleWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _TapScaleWrapper({required this.child, required this.onTap});

  @override
  State<_TapScaleWrapper> createState() => _TapScaleWrapperState();
}

class _TapScaleWrapperState extends State<_TapScaleWrapper> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) {
    setState(() => _scale = 0.97);
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.translucent,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
