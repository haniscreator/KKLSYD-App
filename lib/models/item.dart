class Item {
  final int id;
  final String album;
  final String name;
  final String description;
  final String keyword;
  final String mediaUrl;
  final String status;
  final String createdBy;

  Item({
    required this.id,
    required this.album,
    required this.name,
    required this.description,
    required this.keyword,
    required this.mediaUrl,
    required this.status,
    required this.createdBy,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      album: json['album'],
      name: json['name'],
      description: json['description'] ?? '',
      keyword: json['keyword'] ?? '',
      mediaUrl: json['media_url'],
      status: json['status'].toString(),
      createdBy: json['created_by'].toString(),
    );
  }
}
