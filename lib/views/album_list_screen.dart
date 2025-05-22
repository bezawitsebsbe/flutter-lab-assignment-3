import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/album_cubit.dart';
import '../blocs/album_state.dart';
import '../models/album.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums List'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocBuilder<AlbumCubit, AlbumState>(
        builder: (context, state) {
          switch (state.status) {
            case AlbumStatus.initial:
              return const SizedBox.shrink();
            case AlbumStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case AlbumStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.error ?? 'Something went wrong'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AlbumCubit>().fetchAlbums();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            case AlbumStatus.success:
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<AlbumCubit>().fetchAlbums();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: state.albums.length,
                  itemBuilder: (context, index) {
                    final album = state.albums[index];
                    return _AlbumListTile(album: album);
                  },
                ),
              );
          }
        },
      ),
    );
  }
}

class _AlbumListTile extends StatelessWidget {
  final Album album;

  const _AlbumListTile({required this.album});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      color: theme.colorScheme.primary,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 120,
        child: InkWell(
          onTap: () {
            context.go('/album/${album.id}', extra: album);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (album.thumbnailUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: album.thumbnailUrl!,
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, size: 40),
                    ),
                  )
                else
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo, size: 40),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    album.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 