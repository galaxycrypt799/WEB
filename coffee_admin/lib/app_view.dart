import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/blocs/authentication_bloc/authentication_bloc.dart';
import 'src/routes/routes.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7B4B34),
      brightness: Brightness.light,
      primary: const Color(0xFF7B4B34),
      secondary: const Color(0xFFD8A66A),
      surface: const Color(0xFFF6F0E9),
    );

    return MaterialApp.router(
      title: 'DrinkHub Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'DMSans',
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF3ECE5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
      routerConfig: router(context.read<AuthenticationBloc>()),
    );
  }
}
