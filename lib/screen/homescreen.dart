import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_selector/screen/settings_screen.dart';


import '../apptheme.dart';
import '../provider/wallpaper_provider.dart';
import 'browse_screen.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeContent(onCategorySelected: () => _onItemTapped(1)),
      BrowseScreen(onBack: () => _onItemTapped(0)), // Pass the callback here
      const FavoritesScreen(),
      const SettingsScreen(),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      final isDesktop = screenWidth >= 800;

      if (isDesktop) {
        final showTextInNav = screenWidth >= 950;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Wallpaper Studio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              _buildDesktopNavButton(0, 'Home', Icons.home_outlined, showTextInNav),
              _buildDesktopNavButton(1, 'Browse', Icons.grid_view_outlined, showTextInNav),
              _buildDesktopNavButton(2, 'Favorites', Icons.favorite_border, showTextInNav),
              _buildDesktopNavButton(3, 'Settings', Icons.settings_outlined, showTextInNav),
              const SizedBox(width: 16),
            ],
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: screens,
          ), // Use IndexedStack to preserve state
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Wallpaper Studio'),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: AppTheme.primaryColor),
                  child: Text(
                    'Wallpaper Studio',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                for (var i = 0; i < screens.length; i++)
                  ListTile(
                    leading: _getIconForScreen(i, i == _selectedIndex),
                    title: Text(_getTitleForScreen(i)),
                    selected: _selectedIndex == i,
                    onTap: () {
                      _onItemTapped(i);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: screens,
          ), // Use IndexedStack to preserve state
        );
      }
    });
  }

  Widget _buildDesktopNavButton(int index, String title, IconData icon, bool showText) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface;

    if (showText) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextButton.icon(
          onPressed: () => _onItemTapped(index),
          style: TextButton.styleFrom(
            backgroundColor: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          icon: Icon(icon, color: color, size: 20),
          label: Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    } else {
      return IconButton(
        onPressed: () => _onItemTapped(index),
        icon: Icon(icon, color: color, size: 20),
        tooltip: title,
        splashRadius: 20,
        style: IconButton.styleFrom(
          backgroundColor: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Icon _getIconForScreen(int index, bool isSelected) {
    switch (index) {
      case 0:
        return Icon(isSelected ? Icons.home : Icons.home_outlined);
      case 1:
        return Icon(isSelected ? Icons.grid_view : Icons.grid_view_outlined);
      case 2:
        return Icon(isSelected ? Icons.favorite : Icons.favorite_border);
      case 3:
        return Icon(isSelected ? Icons.settings : Icons.settings_outlined);
      default:
        return const Icon(Icons.error);
    }
  }

  String _getTitleForScreen(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Browse';
      case 2:
        return 'Favorites';
      case 3:
        return 'Settings';
      default:
        return '';
    }
  }
}

class HomeContent extends StatelessWidget {
  final VoidCallback onCategorySelected;

  const HomeContent({Key? key, required this.onCategorySelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WallpaperProvider>();

    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth >= 800;
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.accentColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: Text(
                  'Discover Beautiful Wallpapers',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // The color must be white for the shader to work correctly
                      ),
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Text(
                  'Discover curated collections of stunning wallpapers. Browse by category, preview in full-screen, and set your favorites.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  TextButton(
                    onPressed: onCategorySelected,
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 3 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isDesktop ? 1.5 : 1.2,
                ),
                itemCount: provider.categories.length,
                itemBuilder: (context, index) {
                  final category = provider.categories[index];
                  final wallpapers = provider.getWallpapersByCategory(category.id);
                  final wallpaperCount = wallpapers.length;
                  final coverImagePath = wallpapers.isNotEmpty ? wallpapers.first.imagePath : null;

                  return GestureDetector(
                    onTap: () {
                      provider.selectCategory(category.id);
                      onCategorySelected();
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      clipBehavior: Clip.antiAlias,
                      elevation: 2,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (coverImagePath != null)
                            Image.asset(
                              coverImagePath,
                              fit: BoxFit.cover,
                            )
                          else
                            Container(
                              color: Colors.grey[200],
                              child: const Center(child: Icon(Icons.image_not_supported)),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                                stops: const [0.5, 1.0],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$wallpaperCount wallpapers',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
