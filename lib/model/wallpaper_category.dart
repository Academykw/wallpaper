import 'package:flutter/foundation.dart';

@immutable
class WallpaperCategory {
  final String id;
  final String name;
  final String description;

  const WallpaperCategory({
    required this.id,
    required this.name,
    required this.description,
  });
}
