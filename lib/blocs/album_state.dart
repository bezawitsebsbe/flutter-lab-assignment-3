import 'package:equatable/equatable.dart';
import '../models/album.dart';

enum AlbumStatus { initial, loading, success, failure }

class AlbumState extends Equatable {
  final List<Album> albums;
  final AlbumStatus status;
  final String? error;

  const AlbumState({
    this.albums = const [],
    this.status = AlbumStatus.initial,
    this.error,
  });

  AlbumState copyWith({
    List<Album>? albums,
    AlbumStatus? status,
    String? error,
  }) {
    return AlbumState(
      albums: albums ?? this.albums,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [albums, status, error];
} 