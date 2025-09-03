import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kklsyd_app/providers/item_providers.dart';
import 'package:kklsyd_app/providers/album_providers.dart';
import 'package:kklsyd_app/models/album.dart';

class ItemSearchPage extends ConsumerStatefulWidget {
  const ItemSearchPage({super.key});

  @override
  ConsumerState<ItemSearchPage> createState() => _ItemSearchPageState();
}

class _ItemSearchPageState extends ConsumerState<ItemSearchPage> {
  int? selectedAlbumId;
  String? selectedAlbumName;
  String keyword = "";
  String orderDir = "desc";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itemListProvider);
    final albumsAsync = ref.watch(albumsProvider);

    // Preload current provider values once
    selectedAlbumId ??= state.albumId;
    selectedAlbumName ??= state.albumName;
    if (keyword.isEmpty) keyword = state.searchTerm;
    if (orderDir.isEmpty) orderDir = state.orderDir;

    return Scaffold(
      appBar: AppBar(title: const Text("Search Items")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Album Dropdown from API
            albumsAsync.when(
              data: (albums) {
                final items = <DropdownMenuItem<int>>[
                  const DropdownMenuItem(value: 0, child: Text("All Albums")),
                  ...albums.map(
                    (Album a) => DropdownMenuItem(
                      value: a.id,
                      child: Text(a.name),
                    ),
                  ),
                ];

                // If current selected id isn't in list (edge case), default to 0
                final currentValue = (selectedAlbumId != null &&
                        (selectedAlbumId == 0 ||
                            albums.any((a) => a.id == selectedAlbumId)))
                    ? selectedAlbumId
                    : 0;

                return DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: "Album"),
                  value: currentValue,
                  items: items,
                  onChanged: (val) {
                    setState(() {
                      selectedAlbumId = val ?? 0;
                      if (selectedAlbumId == 0) {
                        selectedAlbumName = null;
                      } else {
                        final found = albums.firstWhere((a) => a.id == selectedAlbumId);
                        selectedAlbumName = found.name;
                      }
                    });
                  },
                );
              },
              loading: () => const Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (err, stack) => Align(
                alignment: Alignment.centerLeft,
                child: Text("Album load error: $err"),
              ),
            ),

            const SizedBox(height: 16),

            // Keyword
            TextFormField(
              initialValue: keyword,
              decoration: const InputDecoration(labelText: "Keyword"),
              onChanged: (val) => keyword = val,
            ),

            const SizedBox(height: 16),

            // Sorting
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Sort By Created At"),
              value: orderDir,
              items: const [
                DropdownMenuItem(value: "desc", child: Text("Descending")),
                DropdownMenuItem(value: "asc", child: Text("Ascending")),
              ],
              onChanged: (val) => setState(() => orderDir = val ?? "desc"),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Reset all filters
                TextButton(
                  onPressed: () {
                    ref.read(itemListProvider.notifier).resetFilters();
                    Navigator.pop(context);
                  },
                  child: const Text("Reset"),
                ),

                // Apply search
                ElevatedButton(
                  onPressed: () {
                    ref.read(itemListProvider.notifier).setFilters(
                          albumId: selectedAlbumId ?? 0,
                          albumName: selectedAlbumId == 0 ? null : selectedAlbumName,
                          searchTerm: keyword,
                          orderDir: orderDir,
                        );
                    Navigator.pop(context);
                  },
                  child: const Text("Search"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
