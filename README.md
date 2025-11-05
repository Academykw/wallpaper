# Wallpaper Studio - Flutter App

A beautiful, responsive wallpaper selector app built with Flutter that works seamlessly on mobile and desktop platforms (Windows, macOS, Linux).

## Features

- **Browse Categories**: Explore 6+ curated wallpaper categories (Nature, Abstract, Urban, Space, Minimalist, Animals)
- **Wallpaper Preview**: Full-screen preview with detailed metadata
- **Set as Wallpaper**: One-click wallpaper installation on desktop
- **Favorites System**: Save your favorite wallpapers for quick access
- **Responsive Design**: Optimized layouts for mobile phones and desktop screens
- **Search Functionality**: Find wallpapers by title or tags
- **Settings**: Customize image quality, notifications, and app preferences
- **Cross-Platform Support**: Works on iOS, Android, Windows, macOS, and Linux

## Project Structure

\`\`\`
lib/
├── main.dart                 # App entry point with window configuration
├── theme/
│   └── app_theme.dart       # Theme configuration and colors
├── models/
│   ├── wallpaper_model.dart # Data models for Wallpaper and Category
│   └── wallpaper_data.dart  # Static wallpaper data and categories
├── providers/
│   └── wallpaper_provider.dart # State management using Provider
├── services/
│   └── wallpaper_service.dart # Wallpaper setting service for desktop/mobile
└── screens/
├── home_screen.dart              # Home and category grid
├── browse_screen.dart            # Browse and search wallpapers
├── wallpaper_preview_screen.dart # Full preview and set wallpaper
├── favorites_screen.dart         # Saved wallpapers collection
└── settings_screen.dart          # App settings and preferences

assets/
├── wallpapers/
│   ├── nature/      
│   ├── abstract/    
│   ├── urban/       
│   ├── space/       
│   ├── minimalist/  
│   └── animals/     
\`\`\`

## Setup Instructions

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (included with Flutter)
- Android Studio or Xcode (for mobile development)
- Visual Studio or build tools (for Windows desktop)

### Installation Steps

1. **Clone/Create the Project**
   \`\`\`bash
   flutter create wallpaper_studio
   cd wallpaper_studio
   \`\`\`

2. **Update pubspec.yaml**
   Replace the pubspec.yaml with the provided file that includes dependencies:
    - `provider`: State management
    - `window_manager`: Desktop window configuration
    - `desktop_window`: Desktop window sizing

3. **Add Asset Folder Structure**
   \`\`\`bash
   mkdir -p assets/wallpapers/{nature,abstract,urban,space,minimalist,animals}
   \`\`\`

4. **Add Wallpaper Images**
    - Place 10 images in each category folder with naming: `{category}_{number}.jpg`
    - Example: `assets/wallpapers/nature/nature_1.jpg` through `nature_10.jpg`

5. **Get Dependencies**
   \`\`\`bash
   flutter pub get
   \`\`\`

## Running the App

### Mobile (Android/iOS)
\`\`\`bash
# Run on connected device or emulator
flutter run

# Run for specific platform
flutter run -d android
flutter run -d ios
\`\`\`

### Desktop (Windows/macOS/Linux)
\`\`\`bash
# Enable desktop support (first time only)
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

# Run on desktop
flutter run -d windows
flutter run -d macos
flutter run -d linux
\`\`\`

## Building for Release

### Android
\`\`\`bash
flutter build apk --release
flutter build appbundle --release  # For Google Play
\`\`\`


### Windows
\`\`\`bash
flutter build windows --release
# Output: build\windows\runner\Release\wallpaper_studio.exe
\`\`\`





Edit in `main.dart` if you want to customize window settings.

### Platform-Specific Wallpaper Setting

The `WallpaperService` includes platform channels for setting wallpapers:
- **Windows**: PowerShell or Win32 API (requires implementation)
- **macOS**: AppleScript via osascript (requires implementation)
- **Linux**: gsettings command (requires implementation)

#### Implementation Guide for Wallpaper Setting

## Responsive Design


### Images Not Loading
- Ensure images are in correct asset folders
- Check `pubspec.yaml` has correct asset paths
- Run `flutter pub get` after adding images

### Window Manager Issues on Linux
- Install required libraries: `sudo apt-get install libayatana-appindicator3-dev`

## Future Enhancements

- Local storage persistence for favorites (using Hive or local_storage)
- API integration for downloading wallpapers online
- Actual platform channel implementation for wallpaper setting
- Wallpaper rotation scheduler
- Social sharing capabilities
- Rating and review system

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| provider | ^6.0.0 | State management |
| window_manager | ^0.3.0 | Desktop window control |
| desktop_window | ^0.4.0 | Desktop window sizing |
| intl | ^0.19.0 | Internationalization |

## Performance Tips

- Images are stored locally to avoid network requests
- Provider pattern ensures efficient rebuilds
- Grid items use const constructors where possible
- SingleChildScrollView with shrink wrap for nested scrolling

## Platform Notes

### Windows
- Requires Visual Studio Build Tools or Visual Studio Community
- App can be packaged as MSIX for Windows Store


## License

MIT License - Feel free to use this project for personal or commercial purposes.

## Support

For issues or feature requests, please check:
1. Ensure all dependencies are installed: `flutter pub get`
2. Check Flutter doctor: `flutter doctor -v`
3. Try cleaning and rebuilding: `flutter clean && flutter pub get`

---

**Made with Flutter** | Wallpaper Studio v1.0.0
