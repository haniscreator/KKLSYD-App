import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:kklsyd_app/const/const.dart';
import 'package:kklsyd_app/pages/audioplayer_page.dart';
import 'package:kklsyd_app/Config/config.dart';
import 'package:kklsyd_app/providers/album_itemslist_providers.dart';

class DetailItemsListTab extends ConsumerWidget {
  final int albumId;

  const DetailItemsListTab({super.key, required this.albumId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Always fetch from API (no cache)
    final asyncItems = ref.watch(detailItemsListProvider(albumId));

    return SafeArea(
      top: false,
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () async {
          // Force refresh API call
          ref.refresh(detailItemsListProvider(albumId));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              asyncItems.when(
                loading:
                    () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                error: (err, _) {
                  if (err.toString().contains("NO_CONNECTION")) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ✅ Lottie animation
                          SizedBox(
                            height: 180,
                            child: Lottie.asset(
                              'assets/lotties/no_connection.json',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            txtGeneralNoInternetPullDown_MM,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return Text("Error: $err");
                },
                data: (items) {
                  if (items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text(txtNoData_MM)),
                    );
                  }
                  return Column(
                    children: List.generate(items.length, (index) {
                      final item = items[index];
                      return AlbumPlayListTile(
                        name: item.name,
                        description: item.description,
                        photo: "assets/images/thumbnail/thumbnail5.png",
                        mediaUrl: AppConfig.storageUrl + item.mediaUrl,
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlbumPlayListTile extends StatelessWidget {
  final String name;
  final String description;
  final String photo;
  final String mediaUrl;

  const AlbumPlayListTile({
    super.key,
    required this.name,
    required this.description,
    required this.photo,
    required this.mediaUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AudioPlayerPage(
                    audioUrl: mediaUrl,
                    title: name,
                    image: 'assets/images/thumbnail/thumbnail5.png',
                    description: description,
                  ),
            ),
          );
        },
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(photo, width: 50, height: 50, fit: BoxFit.cover),
        ),
        title: Text(name),
        subtitle: Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: commonAmberColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 25),
        ),
      ),
    );
  }
}
