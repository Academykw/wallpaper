import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_selector/model/wallpaper_category.dart';
import 'package:wallpaper_selector/provider/wallpaper_provider.dart';
import 'package:wallpaper_selector/screen/wallpaper_preview.dart';

import '../model/wallpaper_model.dart';

class BrowseScreen extends StatefulWidget {
  final VoidCallback onBack;

  const BrowseScreen({Key? key, required this.onBack}) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String? _selectedCategoryId;
  bool _isCategoryGridView = true;
  bool _isWallpaperGridView = true;
  Wallpaper? _selectedWallpaper;
  Wallpaper? _hoveredWallpaper;

  @override
  Widget build(BuildContext context) {
    if (_selectedCategoryId == null) {
      return _buildCategoryBrowser(context);
    } else {
      return _buildWallpaperBrowser(context, _selectedCategoryId!);
    }
  }

  Widget _buildCategoryBrowser(BuildContext context) {
    final provider = context.watch<WallpaperProvider>();
    final categories = provider.categories;
    final isDesktop = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browse Categories',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore our curated collections of stunning wallpapers',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (isDesktop)
              Align(
                alignment: Alignment.centerRight,
                child: ToggleButtons(
                  isSelected: [_isCategoryGridView, !_isCategoryGridView],
                  onPressed: (index) {
                    setState(() {
                      _isCategoryGridView = index == 0;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  children: const [Icon(Icons.grid_view), Icon(Icons.list)],
                ),
              ),
            const SizedBox(height: 16),
            if (!isDesktop || _isCategoryGridView)
              _buildCategoryGrid(context, categories)
            else
              _buildCategoryList(context, categories),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(
      BuildContext context, List<WallpaperCategory> categories) {
    final isDesktop = MediaQuery.of(context).size.width >= 1000;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 3 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isDesktop ? 1.5 : 2.5,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(context, category);
      },
    );
  }

  Widget _buildCategoryList(
      BuildContext context, List<WallpaperCategory> categories) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryListItem(context, category);
      },
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, WallpaperCategory category) {
    final provider = context.read<WallpaperProvider>();
    final wallpapers = provider.getWallpapersByCategory(category.id);
    final wallpaperCount = wallpapers.length;
    final previewImage =
        wallpapers.isNotEmpty ? wallpapers.first.imagePath : '';

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = category.id;
        });
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (previewImage.isNotEmpty)
              Image.asset(previewImage, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  stops: const [0.4, 1.0],
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
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text('$wallpaperCount wallpapers'),
                    labelStyle:
                        const TextStyle(fontSize: 10, color: Colors.white),
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryListItem(
      BuildContext context, WallpaperCategory category) {
    final provider = context.read<WallpaperProvider>();
    final wallpapers = provider.getWallpapersByCategory(category.id);
    final wallpaperCount = wallpapers.length;
    final previewImage =
        wallpapers.isNotEmpty ? wallpapers.first.imagePath : '';

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = category.id;
        });
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            if (previewImage.isNotEmpty)
              SizedBox(
                width: 120,
                height: 100,
                child: Image.asset(previewImage, fit: BoxFit.cover),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text('$wallpaperCount wallpapers'),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWallpaperBrowser(BuildContext context, String categoryId) {
    final provider = context.watch<WallpaperProvider>();
    final wallpapers = provider.getWallpapersByCategory(categoryId);
    final category =
        provider.categories.firstWhere((cat) => cat.id == categoryId);
    final isDesktop = MediaQuery.of(context).size.width >= 1000;
     if (wallpapers.isNotEmpty &&
            (_selectedWallpaper == null || !wallpapers.contains(_selectedWallpaper))) {
          // Safely update state after build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedWallpaper = wallpapers.first;
              });
            }
          });
        }

    if (isDesktop) {
      return Row(
        children: [
          Flexible(
            flex: 2,
            child: _buildWallpaperList(context, wallpapers, category.name),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Flexible(
            flex: 3,
            child: _selectedWallpaper != null
                ? WallpaperPreviewScreen(wallpaper: _selectedWallpaper!)
                : const Center(
                    child: Text('Select a wallpaper to see a preview.')),
          ),
        ],
      );
    } else {
      return _buildWallpaperList(context, wallpapers, category.name);
    }
  }

  Widget _buildWallpaperList(
      BuildContext context, List<Wallpaper> wallpapers, String categoryName) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            setState(() {
              _selectedCategoryId = null;
            });
          },
        ),
        title: Text(categoryName),
        actions: [
          IconButton(
            icon: Icon(_isWallpaperGridView ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                _isWallpaperGridView = !_isWallpaperGridView;
              });
            },
            tooltip:
                _isWallpaperGridView ? 'Show as list' : 'Show as grid',
          ),
        ],
      ),
      body: wallpapers.isEmpty
          ? const Center(child: Text('No wallpapers in this category yet.'))
          : _isWallpaperGridView
              ? GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: wallpapers.length,
                  itemBuilder: (context, index) {
                    final wallpaper = wallpapers[index];
                    return _buildWallpaperCard(wallpaper);
                  },
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: wallpapers.length,
                  itemBuilder: (context, index) {
                    final wallpaper = wallpapers[index];
                    return _buildWallpaperListItem(wallpaper);
                  },
                ),
    );
  }

  Widget _buildWallpaperCard(Wallpaper wallpaper) {
    final isSelected = _selectedWallpaper == wallpaper;
     final isHovered = _hoveredWallpaper == wallpaper;

    return MouseRegion(
       cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredWallpaper = wallpaper),
      onExit: (_) => setState(() => _hoveredWallpaper = null),
      child: GestureDetector(
        onTap: () {
           if (mounted) {
            setState(() {
              _selectedWallpaper = wallpaper;
            });
          }
          if (MediaQuery.of(context).size.width < 1000) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WallpaperPreviewScreen(wallpaper: wallpaper),
              ),
            );
          }
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
             side: isSelected
                ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                : BorderSide.none,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(wallpaper.imagePath, fit: BoxFit.cover),
              _buildCardOverlay(wallpaper),
               if (isHovered)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWallpaperListItem(Wallpaper wallpaper) {
    final isSelected = _selectedWallpaper == wallpaper;
     final isHovered = _hoveredWallpaper == wallpaper;

    return MouseRegion(
       cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredWallpaper = wallpaper),
      onExit: (_) => setState(() => _hoveredWallpaper = null),
      child: GestureDetector(
        onTap: () {
           if (mounted) {
            setState(() {
              _selectedWallpaper = wallpaper;
            });
          }
          if (MediaQuery.of(context).size.width < 1000) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WallpaperPreviewScreen(wallpaper: wallpaper),
              ),
            );
          }
        },
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
             side: isSelected
                ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                : BorderSide.none,
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 100,
                    child: Image.asset(wallpaper.imagePath, fit: BoxFit.cover),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wallpaper.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Chip(label: Text(wallpaper.category)),
                        ],
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              if (isHovered)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardOverlay(Wallpaper wallpaper) {
    final provider = context.watch<WallpaperProvider>();
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
                wallpaper.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: wallpaper.isFavorite
                    ? Theme.of(context).primaryColor
                    : Colors.black,
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
