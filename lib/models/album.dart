import 'package:equatable/equatable.dart';

class Album extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String? thumbnailUrl;
  final String? url;

  const Album({
    required this.id,
    required this.userId,
    required this.title,
    this.thumbnailUrl,
    this.url,
  });

  factory Album.fromJson(Map<String, dynamic> albumJson, Map<String, dynamic>? photoJson) {
    return Album(
      id: albumJson['id'] as int,
      userId: albumJson['userId'] as int,
      title: albumJson['title'] as String,
      thumbnailUrl: photoJson?['thumbnailUrl'] as String?,
      url: photoJson?['url'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, userId, title, thumbnailUrl, url];
} 