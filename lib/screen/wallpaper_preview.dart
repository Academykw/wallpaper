import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/wallpaper_model.dart';
import '../provider/wallpaper_provider.dart';
import '../service/wallpaper_service.dart';

class WallpaperPreviewScreen extends StatelessWidget {
  final Wallpaper wallpaper;
  final bool isEmbedded;

  const WallpaperPreviewScreen({
    required this.wallpaper,
    this.isEmbedded = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WallpaperProvider>();
    final isMobile = MediaQuery.of(context).size.width < 800;

    final body = isMobile && !isEmbedded
        ? _buildMobileLayout(context, provider)
        : _buildDesktopLayout(context, provider);

    if (isEmbedded) {
      return body;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Preview', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: body,
    );
  }

  Widget _buildMobileLayout(BuildContext context, WallpaperProvider provider) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              Container(
                color: Colors.white, // Changed from black to white
                child: Center(
                  child: Image.asset(wallpaper.imagePath, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  onPressed: () {
                    provider.toggleFavorite(wallpaper);
                  },
                  icon: Icon(
                    wallpaper.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: wallpaper.isFavorite
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                  ),
                ),
              ),
            ],
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildPreviewDetails(context),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 2,
                    child: _buildPhoneMockup(
                        context, provider.activeWallpaper, provider),
                  ),
                ],
              ),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Preview',
              style: textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 32),
          Text('Name',
              style: textTheme.bodySmall?.copyWith(color: Colors.black54)),
          Text(wallpaper.title,
              style: textTheme.titleLarge?.copyWith(color: Colors.black)),
          const SizedBox(height: 24),
          Text('Tags',
              style: textTheme.bodySmall?.copyWith(color: Colors.black54)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                  label: Text(wallpaper.category),
                  backgroundColor: Colors.grey[200]),
              ...wallpaper.tags
                  .map((tag) =>
                      Chip(label: Text(tag), backgroundColor: Colors.grey[200]))
                  .toList(),
            ],
          ),
          const SizedBox(height: 24),
          Text('Description',
              style: textTheme.bodySmall?.copyWith(color: Colors.black54)),
          const SizedBox(height: 8),
          Text(wallpaper.description,
              style: textTheme.bodyLarge?.copyWith(color: Colors.black87)),
          const SizedBox(height: 32),
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined, color: Colors.black),
                  tooltip: 'Share'),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined,
                      color: Colors.black),
                  tooltip: 'Download'),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outline, color: Colors.black),
                  tooltip: 'Details'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneMockup(BuildContext context, Wallpaper? activeWallpaper,
      WallpaperProvider provider) {
    return SizedBox(
      width: 258.04,
      height: 524.99,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
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
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 25,
            child: IconButton(
              icon: Icon(
                wallpaper.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: wallpaper.isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: () {
                provider.toggleFavorite(wallpaper);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, WallpaperProvider provider) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        OutlinedButton.icon(
          onPressed: () => provider.toggleFavorite(wallpaper),
          icon: Icon(
              wallpaper.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.black),
          label: const Text('Save to Favorites'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
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
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.black),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Chip(
                label: Text(wallpaper.category),
                backgroundColor: Colors.grey[200]),
            ...wallpaper.tags
                .map((tag) =>
                    Chip(label: Text(tag), backgroundColor: Colors.grey[200]))
                .toList(),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Description',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(wallpaper.description,
            style: const TextStyle(color: Colors.black54)),
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
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
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
              color: wallpaper.isFavorite
                  ? Theme.of(context).primaryColor
                  : Colors.black,
            ),
            label: Text(
                wallpaper.isFavorite
                    ? 'Remove from Favorites'
                    : 'Save to Favorites',
                style: const TextStyle(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
