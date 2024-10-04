class Experience {
  final int id;
  final String name;
  final String imageUrl;
  final String iconUrl;

  Experience({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.iconUrl,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      iconUrl: json['icon_url'],
    );
  }
}