import 'package:flutter/material.dart';
import 'package:travel_in_chiangmai/const/const.dart';
import 'package:travel_in_chiangmai/models/item.dart';
import 'package:travel_in_chiangmai/services/item_service.dart';
import 'package:travel_in_chiangmai/pages/audioplayer_page.dart';
import 'package:travel_in_chiangmai/config.dart';

class DetailItemsListTab extends StatefulWidget {
  final int albumId; // ✅ only need albumId now

  const DetailItemsListTab({
    super.key,
    required this.albumId,
  });

  @override
  State<DetailItemsListTab> createState() => _DetailItemsListTabState();
}

class _DetailItemsListTabState extends State<DetailItemsListTab> {
  late Future<List<Item>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = ItemService().fetchItems(widget.albumId); // ✅ use albumId
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Item>>(
              future: futureItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No items found");
                } else {
                  final items = snapshot.data!;
                  return Column(
                    children: List.generate(items.length, (index) {
                      final item = items[index];
                      return ReviewTile(
                        name: item.name,
                        comment: item.description,
                        photo: "assets/images/thumbnail/thumbnail4.png",
                        mediaUrl: AppConfig.storageUrl + item.mediaUrl,
                      );
                    }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


class ReviewTile extends StatelessWidget {
  final String name;
  final String comment;
  final String photo;
  final String mediaUrl;

  const ReviewTile({
    super.key,
    required this.name,
    required this.comment,
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
              builder: (context) => AudioPlayerPage(
                audioUrl: mediaUrl,
                title: name,
                image: 'assets/images/thumbnail/thumbnail4.png',
              ),
            ),
          );
        },
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            photo,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(name),
        subtitle: Text(comment, maxLines: 2, overflow: TextOverflow.ellipsis),
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

