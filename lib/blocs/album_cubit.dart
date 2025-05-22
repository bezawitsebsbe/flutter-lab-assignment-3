import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/album_service.dart';
import 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  final AlbumService _albumService;

  AlbumCubit({required AlbumService albumService})
      : _albumService = albumService,
        super(const AlbumState());

  Future<void> fetchAlbums() async {
    emit(state.copyWith(status: AlbumStatus.loading));

    try {
      final albums = await _albumService.getAlbums();
      emit(state.copyWith(
        status: AlbumStatus.success,
        albums: albums,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AlbumStatus.failure,
        error: e.toString(),
      ));
    }
  }
} 