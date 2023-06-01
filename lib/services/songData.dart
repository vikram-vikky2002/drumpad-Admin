// ignore_for_file: file_names

class SongsData {
  final bool isValid;
  final String id;
  final String title;
  final String subtitle;
  final String imgUrl;
  final String songUrl;

  SongsData({
    this.isValid = true,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imgUrl,
    required this.songUrl,
  });

  factory SongsData.fromJson(Map<String, dynamic> json, String id) {
    return SongsData(
      id: id,
      title: json['title'] ?? "...",
      subtitle: json['subtitle'] ?? "...",
      imgUrl: json['image'] ?? '...',
      songUrl: json['song'] ?? '...',
    );
  }

  static SongsData invalid(String id) {
    return SongsData(
      isValid: false,
      id: id,
      title: 'ERROR',
      subtitle: 'ERROR',
      imgUrl: 'ERROR',
      songUrl: 'ERROR',
    );
  }
}
