import 'package:flutter/foundation.dart';
import 'package:wallpaper_selector/model/wallpaper_category.dart';

import '../model/wallpaper_model.dart';

class WallpaperProvider with ChangeNotifier {
  String _selectedCategory = 'all';
  final List<Wallpaper> _favorites = [];
  Wallpaper? _activeWallpaper;

  final List<WallpaperCategory> _categories = [
    const WallpaperCategory(id: 'nature', name: 'Nature', description: 'Mountains, forest and landscapes'),
    const WallpaperCategory(id: 'abstract', name: 'Abstract', description: 'Modern geometric and artistic designs'),
    const WallpaperCategory(id: 'urban', name: 'Urban', description: 'Cities, architecture and street'),
    const WallpaperCategory(id: 'space', name: 'Space', description: 'Cosmos, planets, and galaxies'),
    const WallpaperCategory(id: 'minimalist', name: 'Minimalist', description: 'Clean, simple, and elegant'),
    const WallpaperCategory(id: 'animals', name: 'Animals', description: 'Wildlife and nature photography'),
  ];

  final List<Wallpaper> _wallpapers = [
    // Nature
    Wallpaper(id: '1', title: 'Nature 1', category: 'nature', imagePath: 'assets/wallpaper/Nature/nature_one.jpg', description: 'A beautiful landscape with mountains and flowers.', tags: []),
    Wallpaper(id: '2', title: 'Nature 2', category: 'nature', imagePath: 'assets/wallpaper/Nature/nature_two.jpg', description: 'A serene view of a forest and mountains.', tags: []),
    Wallpaper(id: '3', title: 'Nature 3', category: 'nature', imagePath: 'assets/wallpaper/Nature/nature_three.jpg', description: 'A stunning sunset over a forest road.', tags: []),
    Wallpaper(id: '4', title: 'Nature 4', category: 'nature', imagePath: 'assets/wallpaper/Nature/nature_four.jpg', description: 'A tranquil lake surrounded by mountains.', tags: []),
    Wallpaper(id: '5', title: 'Nature 5', category: 'nature', imagePath: 'assets/wallpaper/Nature/nature_five.jpg', description: 'A starry night sky over a forest.', tags: []),
    Wallpaper(id: '6', title: 'Nature 6', category: 'nature', imagePath: 'assets/wallpaper/Nature/nature_six.jpg', description: 'A rocky coastline with a natural arch.', tags: []),
    Wallpaper(id: '20', title: 'Nature 7', category: 'nature', imagePath: 'assets/wallpaper/Nature/nature_seven.jpg', description: 'A beautiful landscape.', tags: []),
    Wallpaper(id: '21', title: 'Nature 8', category: 'nature', imagePath: 'assets/wallpaper/Nature/nature_eight.jpg', description: 'A beautiful landscape.', tags: []),
    Wallpaper(id: '22', title: 'Nature 9', category: 'nature', imagePath: 'assets/wallpaper/Nature/nature_nine.jpg', description: 'A beautiful landscape.', tags: []),

    // Abstract
    Wallpaper(id: '7', title: 'Abstract 1', category: 'abstract', imagePath: 'assets/wallpaper/Abstract/abstract_one.jpg', description: 'A colorful and vibrant abstract design.', tags: []),
    Wallpaper(id: '8', title: 'Abstract 2', category: 'abstract', imagePath: 'assets/wallpaper/Abstract/abstract_two.jpg', description: 'A mix of swirling colors and shapes.', tags: []),
    Wallpaper(id: '9', title: 'Abstract 3', category: 'abstract', imagePath: 'assets/wallpaper/Abstract/abstract_three.jpg', description: 'A digital artwork with glowing lines.', tags: []),
    Wallpaper(id: '10', title: 'Abstract 4', category: 'abstract', imagePath: 'assets/wallpaper/Abstract/abstract_four.jpg', description: 'A purple and blue wave-like pattern.', tags: []),

    // Urban
    Wallpaper(id: '12', title: 'Urban 1', category: 'urban', imagePath: 'assets/wallpaper/Urban/urban_one.jpg', description: 'A modern cityscape with towering skyscrapers.', tags: []),
    Wallpaper(id: '19', title: 'Urban 2', category: 'urban', imagePath: 'assets/wallpaper/Urban/urban_two.jpg', description: 'City lights illuminating the night sky.', tags: []),
    Wallpaper(id: '23', title: 'Urban 3', category: 'urban', imagePath: 'assets/wallpaper/Urban/urban_three.jpg', description: 'A bustling city street.', tags: []),
    Wallpaper(id: '24', title: 'Urban 4', category: 'urban', imagePath: 'assets/wallpaper/Urban/urban_four.jpg', description: 'Modern architecture.', tags: []),

    // Space
    Wallpaper(id: '13', title: 'Galaxy View', category: 'space', imagePath: 'assets/wallpaper/Space/space_one.jpg', description: 'A stunning view of a distant galaxy.', tags: []),
    Wallpaper(id: '14', title: 'Nebula', category: 'space', imagePath: 'assets/wallpaper/Space/space_two.jpg', description: 'Colorful gases of a nebula.', tags: []),
    Wallpaper(id: '25', title: 'Space 3', category: 'space', imagePath: 'assets/wallpaper/Space/space_three.jpg', description: 'A journey through space.', tags: []),
    Wallpaper(id: '26', title: 'Space 4', category: 'space', imagePath: 'assets/wallpaper/Space/space_four.jpg', description: 'Planets and stars.', tags: []),

    // Minimalist
    Wallpaper(id: '15', title: 'Simple Desk', category: 'minimalist', imagePath: 'assets/wallpaper/Minimalist/minimalist_one.jpg', description: 'A clean and simple desk setup.', tags: []),
    Wallpaper(id: '16', title: 'White Shapes', category: 'minimalist', imagePath: 'assets/wallpaper/Minimalist/minimalist_two.jpg', description: 'Abstract white shapes on a plain background.', tags: []),
    Wallpaper(id: '27', title: 'Minimalist 3', category: 'minimalist', imagePath: 'assets/wallpaper/Minimalist/minimalist_three.jpg', description: 'Simple and clean.', tags: []),
    Wallpaper(id: '28', title: 'Minimalist 4', category: 'minimalist', imagePath: 'assets/wallpaper/Minimalist/minimalist_four.jpg', description: 'Lines and shapes.', tags: []),
    Wallpaper(id: '29', title: 'Minimalist 5', category: 'minimalist', imagePath: 'assets/wallpaper/Minimalist/minimalist_five.jpg', description: 'A touch of minimalism.', tags: []),

    // Animals
    Wallpaper(id: '17', title: 'Fox in Snow', category: 'animals', imagePath: 'assets/wallpaper/Animal/animal_one.jpg', description: 'A red fox sitting in the snow.', tags: []),
    Wallpaper(id: '18', title: 'Lion Portrait', category: 'animals', imagePath: 'assets/wallpaper/Animal/animal_two.jpg', description: 'A majestic portrait of a lion.', tags: []),
    Wallpaper(id: '30', title: 'Animal 3', category: 'animals', imagePath: 'assets/wallpaper/Animal/animal_three.jpg', description: 'A beautiful animal.', tags: []),
    Wallpaper(id: '31', title: 'Animal 4', category: 'animals', imagePath: 'assets/wallpaper/Animal/animal_four.jpg', description: 'A beautiful animal.', tags: []),
    Wallpaper(id: '32', title: 'Animal 5', category: 'animals', imagePath: 'assets/wallpaper/Animal/animal_five.jpg', description: 'A beautiful animal.', tags: []),
  ];

  String get selectedCategory => _selectedCategory;
  List<WallpaperCategory> get categories => _categories;
  List<Wallpaper> get favorites => _favorites;
  Wallpaper? get activeWallpaper => _activeWallpaper;

  List<Wallpaper> getWallpapersByCategory(String categoryId) {
    if (categoryId == 'all') {
      return _wallpapers;
    }
    return _wallpapers.where((w) => w.category.toLowerCase() == categoryId.toLowerCase()).toList();
  }

  void selectCategory(String categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void setActiveWallpaper(Wallpaper wallpaper) {
    _activeWallpaper = wallpaper;
    notifyListeners();
  }

  void toggleFavorite(Wallpaper wallpaper) {
    final index = _favorites.indexWhere((w) => w.id == wallpaper.id);
    if (index != -1) {
      _favorites.removeAt(index);
      wallpaper.isFavorite = false;
    } else {
      _favorites.add(wallpaper);
      wallpaper.isFavorite = true;
    }
    notifyListeners();
  }
}
