import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_selector/screen/wallpaper_preview.dart';

import '../model/wallpaper_model.dart';
import '../provider/wallpaper_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WallpaperProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favorites;

        if (favorites.isEmpty) {
          return const Center(
            child: Text('You haven\'t added any favorites yet.'),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final wallpaper = favorites[index];
            return WallpaperFavoriteCard(wallpaper: wallpaper);
          },
        );
      },
    );
  }
}

class WallpaperFavoriteCard extends StatelessWidget {
  final Wallpaper wallpaper;

  const WallpaperFavoriteCard({required this.wallpaper, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WallpaperPreviewScreen(wallpaper: wallpaper),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(wallpaper.imagePath, fit: BoxFit.cover),
            _buildCardOverlay(context, wallpaper),
          ],
        ),
      ),
    );
  }

  Widget _buildCardOverlay(BuildContext context, Wallpaper wallpaper) {
    final provider = context.read<WallpaperProvider>();
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () => provider.toggleFavorite(wallpaper),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.favorite,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wallpaper.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(wallpaper.category),
                labelStyle: const TextStyle(fontSize: 12, color: Colors.white),
                backgroundColor: Colors.white.withOpacity(0.2),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
