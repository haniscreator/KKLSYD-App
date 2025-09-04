// lib/models/album.dart
class Album {
  final int id;
  final String name;
  final String description;
  final String keyword;
  final String location;
  final String status; // now string ("active", "inactive", etc.)
  final String createdDate;
  final String createdBy; // now string ("Admin")
  final int itemCount;
  final String coverImage; // new field

  Album({
    required this.id,
    required this.name,
    required this.description,
    required this.keyword,
    required this.location,
    required this.status,
    required this.createdDate,
    required this.createdBy,
    required this.itemCount,
    required this.coverImage,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      keyword: json['keyword'] as String,
      location: json['location'] as String,
      status: json['status'].toString(), // ✅ cast to String
      createdDate: json['created_date'].toString(),
      createdBy: json['created_by'].toString(), // ✅ cast to String
      itemCount: json['item_count'] as int,
      coverImage: json['cover_image'].toString(), // ✅ cast to String
    );
  }
}
