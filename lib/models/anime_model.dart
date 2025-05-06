class Anime {
  final int id;
  final String name;
  final String imageUrl;
  final String familyCreator;

  Anime(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.familyCreator});

  factory Anime.fromJson(Map<String, dynamic> json) {
    final images = json['images'];
    final String imageUrl = (images != null &&
            images.isNotEmpty &&
            Uri.tryParse(images[0])?.isAbsolute == true)
        ? images[0]
        : '';

    return Anime(
      id: json['id'] ?? 0,
      name: json['name'] ?? "notName",
      imageUrl: imageUrl,
      familyCreator: (json['family'] != null)
          ? (json['family']['creator'] ?? "family is null")
          : "Gaada Keluarga",
    );
  }
}
