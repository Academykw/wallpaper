import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_selector/provider/wallpaper_provider.dart';
import 'package:wallpaper_selector/screen/homescreen.dart';

import 'package:window_manager/window_manager.dart';

import 'apptheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 650),
      minimumSize: Size(400, 200),
      center: true,
      titleBarStyle: TitleBarStyle.normal, // This ensures the title bar is visible
      title: 'Wallpaper Studio',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus(); // Focus the window when it's shown
    });
  }

  runApp(const WallpaperApp());
}

class WallpaperApp extends StatelessWidget {
  const WallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WallpaperProvider()),
      ],
      child: MaterialApp(
        title: 'Wallpaper Studio',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
