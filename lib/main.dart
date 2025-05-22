import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/album_cubit.dart';
import 'router/app_router.dart';
import 'services/album_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blue[700] ?? Colors.blue;
    
    return BlocProvider(
      create: (context) => AlbumCubit(
        albumService: AlbumService(),
      )..fetchAlbums(),
      child: MaterialApp.router(
        title: 'Albums List',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColor,
            primary: primaryColor,
            onPrimary: const Color(0xFFFFFFFF),
          ),
          useMaterial3: true,
          cardTheme: const CardTheme(
            elevation: 2,
            margin: EdgeInsets.zero,
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
