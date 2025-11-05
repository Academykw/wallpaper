import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/wallpaper_model.dart';
import '../provider/wallpaper_provider.dart';
import '../service/wallpaper_service.dart';

class WallpaperPreviewScreen extends StatelessWidget {
  final Wallpaper wallpaper;

  const WallpaperPreviewScreen({required this.wallpaper, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WallpaperProvider>();
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: isMobile ? null : Theme.of(context).colorScheme.surface,
      appBar: isMobile
          ? AppBar(
              title: const Text('Preview'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: isMobile
          ? _buildMobileLayout(context, provider)
          : _buildDesktopLayout(context, provider),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WallpaperProvider provider) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.black,
            child: Image.asset(wallpaper.imagePath, fit: BoxFit.contain),
          ),
        ),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildDetails(context, provider),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WallpaperProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildPreviewDetails(context),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: _buildPhoneMockup(context, provider.activeWallpaper),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildActionButtons(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewDetails(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preview', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        Text('Name', style: textTheme.bodySmall?.copyWith(color: onSurfaceVariant)),
        Text(wallpaper.title, style: textTheme.titleLarge),
        const SizedBox(height: 24),
        Text('Tags', style: textTheme.bodySmall?.copyWith(color: onSurfaceVariant)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Chip(label: Text(wallpaper.category), backgroundColor: Theme.of(context).colorScheme.secondaryContainer),
            ...wallpaper.tags.map((tag) => Chip(label: Text(tag))).toList(),
          ],
        ),
        const SizedBox(height: 24),
        Text('Description', style: textTheme.bodySmall?.copyWith(color: onSurfaceVariant)),
        const SizedBox(height: 8),
        Text(wallpaper.description, style: textTheme.bodyLarge?.copyWith(color: onSurfaceVariant)),
        const SizedBox(height: 32),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined), tooltip: 'Share'),
            IconButton(onPressed: () {}, icon: const Icon(Icons.file_download_outlined), tooltip: 'Download'),
            IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline), tooltip: 'Details'),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneMockup(BuildContext context, Wallpaper? activeWallpaper) {
    return SizedBox(
      width: 258.04,
      height: 524.99,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey.shade700, width: 8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.asset(
            activeWallpaper?.imagePath ?? wallpaper.imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WallpaperProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () => provider.toggleFavorite(wallpaper),
          icon: Icon(wallpaper.isFavorite ? Icons.favorite : Icons.favorite_border),
          label: const Text('Save to Favorites'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () async {
            final wallpaperService = WallpaperService();
            await wallpaperService.setDesktopWallpaper(wallpaper.imagePath);
            provider.setActiveWallpaper(wallpaper);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Wallpaper set successfully!')),
            );
          },
          child: const Text('Set to Wallpaper'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  // Original details widget for mobile
  Widget _buildDetails(BuildContext context, WallpaperProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          wallpaper.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Chip(label: Text(wallpaper.category)),
            ...wallpaper.tags.map((tag) => Chip(label: Text(tag))).toList(),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(wallpaper.description),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final wallpaperService = WallpaperService();
              await wallpaperService.setDesktopWallpaper(wallpaper.imagePath);
              provider.setActiveWallpaper(wallpaper);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wallpaper set successfully!')),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Set as Wallpaper'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              provider.toggleFavorite(wallpaper);
            },
            icon: Icon(
              wallpaper.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: wallpaper.isFavorite ? Theme.of(context).primaryColor : null,
            ),
            label: Text(
              wallpaper.isFavorite
                  ? 'Remove from Favorites'
                  : 'Save to Favorites',
            ),
          ),
        ),
      ],
    );
  }
}
