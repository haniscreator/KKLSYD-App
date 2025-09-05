import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kklsyd_app/providers/item_providers.dart';
import 'package:kklsyd_app/providers/album_providers.dart';
import 'package:kklsyd_app/models/album.dart';
import 'package:kklsyd_app/const/const.dart'; // assuming colors are here

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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actionTextColor =
        isDark ? commonActionTextColorDark : commonActionTextColor;

    // Preload current provider values once
    selectedAlbumId ??= state.albumId;
    selectedAlbumName ??= state.albumName;
    if (keyword.isEmpty) keyword = state.searchTerm;
    if (orderDir.isEmpty) orderDir = state.orderDir;

    return Scaffold(
      appBar: AppBar(title: const Text(txtTitleSearch_MM)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Album Dropdown from API
                    albumsAsync.when(
                      data: (albums) {
                        final items = <DropdownMenuItem<int>>[
                          const DropdownMenuItem(
                            value: 0,
                            child: Text("All Albums"),
                          ),
                          ...albums.map(
                            (Album a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(a.name),
                            ),
                          ),
                        ];

                        final currentValue =
                            (selectedAlbumId != null &&
                                    (selectedAlbumId == 0 ||
                                        albums.any(
                                          (a) => a.id == selectedAlbumId,
                                        )))
                                ? selectedAlbumId
                                : 0;

                        return DropdownButtonFormField<int>(
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: "Album"),
                          value: currentValue,
                          items: items,
                          onChanged: (val) {
                            setState(() {
                              selectedAlbumId = val ?? 0;
                              if (selectedAlbumId == 0) {
                                selectedAlbumName = null;
                              } else {
                                final found = albums.firstWhere(
                                  (a) => a.id == selectedAlbumId,
                                );
                                selectedAlbumName = found.name;
                              }
                            });
                          },
                        );
                      },
                      loading:
                          () => const Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                      error:
                          (err, stack) => Align(
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
                      decoration: const InputDecoration(
                        labelText: "Sort By Created At",
                      ),
                      value: orderDir,
                      items: const [
                        DropdownMenuItem(
                          value: "desc",
                          child: Text("Descending"),
                        ),
                        DropdownMenuItem(
                          value: "asc",
                          child: Text("Ascending"),
                        ),
                      ],
                      onChanged:
                          (val) => setState(() => orderDir = val ?? "desc"),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: actionTextColor,
                            ),
                            onPressed: () {
                              ref
                                  .read(itemListProvider.notifier)
                                  .resetFilters();
                              Navigator.pop(context);
                            },
                            child: const Text(txtReset_MM),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: actionTextColor,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              ref
                                  .read(itemListProvider.notifier)
                                  .setFilters(
                                    albumId: selectedAlbumId ?? 0,
                                    albumName:
                                        selectedAlbumId == 0
                                            ? null
                                            : selectedAlbumName,
                                    searchTerm: keyword,
                                    orderDir: orderDir,
                                  );
                              Navigator.pop(context);
                            },
                            child: const Text(txtSearch_MM),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
