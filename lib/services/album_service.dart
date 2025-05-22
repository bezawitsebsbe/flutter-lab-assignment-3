import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album.dart';

class AlbumService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client _client;

  AlbumService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Album>> getAlbums() async {
    try {
      final albumsResponse = await _client.get(Uri.parse('$_baseUrl/albums'));
      final photosResponse = await _client.get(Uri.parse('$_baseUrl/photos'));

      if (albumsResponse.statusCode == 200 && photosResponse.statusCode == 200) {
        final List<dynamic> albumsJson = json.decode(albumsResponse.body);
        final List<dynamic> photosJson = json.decode(photosResponse.body);

        return albumsJson.map((albumJson) {
          final photo = photosJson.firstWhere(
            (photo) => photo['albumId'] == albumJson['id'],
            orElse: () => null,
          );
          return Album.fromJson(albumJson, photo);
        }).toList();
      } else {
        throw Exception('Failed to load albums');
      }
    } catch (e) {
      throw Exception('Failed to load albums: $e');
    }
  }
} 