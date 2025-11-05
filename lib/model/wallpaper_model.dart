import 'package:flutter/foundation.dart';

@immutable
class Wallpaper {
  final String id;
  final String title;
  final String category;
  final String imagePath;
  final String description;
  final List<String> tags;
  bool isFavorite;
  final DateTime createdAt;

  Wallpaper({
    required this.id,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.tags,
    this.isFavorite = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Wallpaper copyWith({bool? isFavorite}) {
    return Wallpaper(
      id: id,
      title: title,
      category: category,
      imagePath: imagePath,
      description: description,
      tags: tags,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Wallpaper && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class Category {
  final String id;
  final String name;
  final String description;
  final String coverImagePath;
  final int wallpaperCount;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImagePath,
    required this.wallpaperCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
