import 'wallpaper_model.dart';

class WallpaperData {
  static final List<Category> categories = [
    Category(
      id: 'nature',
      name: 'Nature',
      description: 'Mountains, forests and landscapes',
      coverImagePath: 'assets/wallpaper/Nature/nature_one.jpg',
      wallpaperCount: 9,
    ),
    Category(
      id: 'abstract',
      name: 'Abstract',
      description: 'Modern geometric and artistic designs',
      coverImagePath: 'assets/wallpaper/Abstract/abstract_one.jpg',
      wallpaperCount: 4,
    ),
    Category(
      id: 'urban',
      name: 'Urban',
      description: 'Cities, architecture and street art',
      coverImagePath: 'assets/wallpaper/Urban/urban_one.jpg',
      wallpaperCount: 4,
    ),
    Category(
      id: 'space',
      name: 'Space',
      description: 'Cosmos, planets and galaxies',
      coverImagePath: 'assets/wallpaper/Space/space_one.jpg',
      wallpaperCount: 4,
    ),
    Category(
      id: 'minimalist',
      name: 'Minimalist',
      description: 'Clean, simple and elegant',
      coverImagePath: 'assets/wallpaper/Minimalist/minimalist_one.jpg',
      wallpaperCount: 5,
    ),
    Category(
      id: 'animals',
      name: 'Animals',
      description: 'Wildlife and nature photography',
      coverImagePath: 'assets/wallpaper/Animal/animal_one.jpg',
      wallpaperCount: 5,
    ),
  ];

  static final Map<String, List<String>> _wallpaperFiles = {
    'nature': [
      'nature_one.jpg',
      'nature_two.jpg',
      'nature_three.jpg',
      'nature_four.jpg',
      'nature_five.jpg',
      'nature_six.jpg',
      'nature_seven.jpg',
      'nature_eight.jpg',
      'nature_nine.jpg',
    ],
    'abstract': [
      'abstract_one.jpg',
      'abstract_two.jpg',
      'abstract_three.jpg',
      'abstract_four.jpg',
    ],
    'urban': ['urban_one.jpg', 'urban_two.jpg', 'urban_three.jpg', 'urban_four.jpg'],
    'space': ['space_one.jpg', 'space_two.jpg', 'space_three.jpg', 'space_four.jpg'],
    'minimalist': [
      'minimalist_one.jpg',
      'minimalist_two.jpg',
      'minimalist_three.jpg',
      'minimalist_four.jpg',
      'minimalist_five.jpg',
    ],
    'animals': [
      'animal_one.jpg',
      'animal_two.jpg',
      'animal_three.jpg',
      'animal_four.jpg',
      'animal_five.jpg',
    ],
  };

  static List<Wallpaper> getWallpapersByCategory(String categoryId) {
    final category = categories.firstWhere((cat) => cat.id == categoryId, orElse: () => categories.first);
    final categoryName = category.name;
    final files = _wallpaperFiles[categoryId] ?? [];

    List<Wallpaper> wallpapers = [];
    for (var i = 0; i < files.length; i++) {
      final fileName = files[i];
      final imageNumber = i + 1;
      final imagePath = 'assets/wallpaper/$categoryName/$fileName';

      wallpapers.add(Wallpaper(
        id: '${categoryId}_$imageNumber',
        title: '${categoryName.capitalize()} $imageNumber',
        category: categoryName,
        imagePath: imagePath,
        description: 'Discover the pure beauty of $categoryName - your gateway to authentic and unique visual experiences.',
        tags: [categoryId, 'beautiful', 'hd'],
      ));
    }
    return wallpapers;
  }

  static List<Wallpaper> getAllWallpapers() {
    List<Wallpaper> all = [];
    for (var category in categories) {
      all.addAll(getWallpapersByCategory(category.id));
    }
    return all;
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
