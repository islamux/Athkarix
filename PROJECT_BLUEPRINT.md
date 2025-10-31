# Athkarix - Project Blueprint

## Overview

A Flutter application for Islamic Athkar (remembrances) and Duas. Features:
- **Multi-language**: Arabic & English support
- **Multiple Categories**: Morning, Evening, After Prayer, Sleep, and more
- **99 Names of Allah**: Complete Asma' al-Husna with translations
- **Digital Tasbih**: Counter with haptic feedback
- **JSON Data**: Easy content management
- **Material Design**: Beautiful, responsive UI

---

## Prerequisites

- **Flutter SDK**: 3.35.1+ (stable channel)
- **Dart SDK**: 3.9.0+
- **Android Studio** / **VS Code** with Flutter extensions
- **Git**: Latest version

---

## Quick Start

### 1. Install Flutter

```bash
# Check installation
flutter doctor

# If not installed, download from:
# https://docs.flutter.dev/get-started/install
```

### 2. Clone & Setup

```bash
git clone <repository-url>
cd Athkarix

flutter pub get
```

### 3. Run App

```bash
# Android
flutter run

# iOS (requires Xcode)
flutter run -d ios

# Web
flutter run -d chrome

# Specific device
flutter run -d <device-id>
```

---

## Architecture

### Tech Stack

- **Framework**: Flutter 3.35.1
- **Language**: Dart 3.9.0
- **State Management**: GetX (^4.6.5)
- **Data Storage**: JSON files + SharedPreferences
- **Routing**: GetX Named Routes
- **Internationalization**: Flutter built-in

### Directory Structure

```
lib/
├── main.dart                 # App entry point
├── binding.dart              # GetX dependency injection
├── route.dart                # Route definitions
├── controller/               # Business logic (GetX controllers)
│   ├── home_controller.dart
│   ├── athkar_sabah_controller.dart
│   ├── font_controller.dart  # Theme/font management
│   └── ...
├── core/
│   ├── data/
│   │   ├── json/            # JSON data files
│   │   │   ├── athkar_sabah.json
│   │   │   ├── assma-hussna.json
│   │   │   └── ...
│   │   ├── model/           # Data models
│   │   ├── service/         # Data services
│   │   └── static/
│   │       ├── theme/       # App themes
│   │       ├── text/        # Static text (legacy)
│   │       └── routes_constant.dart
│   └── function/            # Utility functions
├── view/
│   ├── pages/               # UI screens
│   │   ├── home.dart
│   │   ├── athkar_sabah_page.dart
│   │   └── ...
│   └── widget/              # Reusable components
assets/
├── json/                    # JSON files (legacy)
├── fonts/                   # Arabic fonts (Amiri, Cairo)
└── images/                  # App assets
test/                        # Unit & widget tests
```

### Architecture Pattern

**GetX + MVC**

- **Controller**: Business logic, state management
- **View**: UI widgets, Flutter components
- **Model**: Data structures

**State Management Flow:**

1. Controllers extend `GetXController` or `GetController`
2. Views use `GetBuilder<Controller>` for reactive updates
3. Dependency injection via `binding.dart`
4. Navigation with `Get.toNamed()`

---

## Development Workflow

### Hot Reload

During development, use hot reload for fast iteration:
```bash
# Press 'r' in terminal - Hot reload
# Press 'R' in terminal - Hot restart
```

### Code Analysis

```bash
# Check for errors
flutter analyze

# Format code
dart format .

# Run tests
flutter test

# Test coverage
flutter test --coverage
```

### Debugging

```bash
# Debug mode (with debug banner)
flutter run --debug

# Profile mode (performance profiling)
flutter run --profile

# Release mode (production)
flutter run --release
```

---

## Core Features

### 1. Theme System

Theme managed by `FontControllerImp` (`lib/controller/font_controller.dart`):
- Light/Dark mode toggle
- Dynamic font sizing
- Custom colors (Golden theme defined in `lib/core/data/static/theme/app_them.dart`)

```dart
// Switch theme
Get.find<FontControllerImp>().toggleTheme();

// Change font size
Get.find<FontControllerImp>().increaseFontSize();
```

### 2. Data Management

**Modern Approach (JSON)** - Preferred:
```dart
// Load from JSON
final String response = await rootBundle.loadString('assets/json/athkar_sabah.json');
final List<dynamic> data = json.decode(response);
```

**Legacy Approach (Dart Lists)**:
```dart
// Static list (being migrated to JSON)
final List<AthkarModel> data = AthkarModelList.duaMenQuran;
```

### 3. Navigation

**Named Routes**:
```dart
// Navigate to page
Get.toNamed(AppRoute.athkarSabah);

// Navigate with arguments
Get.toNamed(AppRoute.assmaHussna, arguments: {'id': 1});

// Back navigation
Get.back();
```

**Route Constants** (`lib/core/data/static/routes_constant.dart`):
```dart
static const String athkarSabah = "/athkar-sabah";
static const String home = "/home";
```

### 4. Counter System

Extends `BaseAthkarController` (`lib/controller/base_athkar_controller.dart`):
```dart
abstract class BaseAthkarController extends GetxController {
  // Shared logic:
  // - Counter increment
  // - Page navigation
  // - Reset functionality
}
```

### 5. Search Feature

Custom search with diacritics removal (`lib/function/remove_search_diacritics.dart`):
```dart
String normalizedText = removeSearchDiacritics(arabicText);
```

---

## Building for Production

### Android

```bash
# APK (recommended for testing)
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle --release

# Split APKs (smaller downloads)
flutter build apk --split-per-abi
```

### iOS

```bash
# Build for iOS (requires Xcode on macOS)
flutter build ios --release
```

### Web

```bash
# Build for web
flutter build web --release

# Output in build/web/
```

---

## Testing

### Run Tests

```bash
# All tests
flutter test

# Specific file
flutter test test/assma_hussna_test.dart

# With coverage
flutter test --coverage
```

### Test Structure

- **Widget Tests**: UI component testing
- **Unit Tests**: Business logic testing
- **Integration Tests**: End-to-end testing

Example test (`test/assma_hussna_test.dart`):
```dart
test('should load AssmaHussna data from JSON', () async {
  final data = await AssmaHussnaService.loadAssmaHussnaData();
  expect(data, isNotEmpty);
  expect(data.length, greaterThanOrEqualTo(99));
});
```

---

## Common Tasks

### Adding New Athkar Category

1. Create JSON file in `assets/json/`
2. Add model in `lib/core/data/model/`
3. Create controller in `lib/controller/`
4. Add page in `lib/view/pages/`
5. Register route in `lib/route.dart`
6. Register controller in `lib/binding.dart`

### Adding New Athkar Item

1. Edit JSON file in `assets/json/` or `lib/core/data/json/`
2. Follow existing structure:
```json
{
  "id": "unique_id",
  "content": "Arabic text here",
  "footer": "Source reference"
}
```

### Modifying Theme

Edit `lib/core/data/static/theme/app_them.dart`:
```dart
static ThemeData get goldenTheme {
  return ThemeData(
    // Define theme properties
  );
}
```

### Debugging Issues

```bash
# Clear build cache
flutter clean && flutter pub get

# Verbose output
flutter run -v

# Check dependencies
flutter pub deps
```

---

## Dependencies

### Production Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| get | ^4.6.5 | State management, routing |
| share_plus | ^11.1.0 | Share content |
| intl | ^0.20.1 | Internationalization |
| shared_preferences | ^2.5.0 | Local storage |
| url_launcher | ^6.2.5 | Open URLs |
| flutter_native_splash | ^2.3.0 | Splash screen |

### Development Dependencies

| Package | Purpose |
|---------|---------|
| flutter_test | Testing framework |
| flutter_lints | Code analysis |

---

## Configuration Files

### pubspec.yaml

- Defines dependencies and assets
- Includes Arabic fonts (Amiri, Cairo)
- App version and metadata

### analysis_options.yaml

- Linting rules
- Enforces Flutter best practices

---

## Best Practices

1. **State Management**: Use GetX for reactive updates
2. **Data**: Prefer JSON over hardcoded lists
3. **Routing**: Use named routes consistently
4. **Testing**: Write tests for all controllers
5. **Performance**: Use `const` constructors, optimize rebuilds
6. **Code Style**: Follow `flutter_lints` rules
7. **Assets**: Optimize images, use appropriate formats

---

## Troubleshooting

### Build Errors

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Dependency Issues

```bash
# Upgrade dependencies
flutter pub upgrade

# Get outdated packages
flutter pub outdated
```

### Hot Reload Not Working

```bash
# Full restart
flutter restart
```

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [GetX Documentation](https://pub.dev/packages/get)
- [JSON Assets Guide](https://docs.flutter.dev/development/ui/assets-and-images)
- [Testing Flutter Apps](https://docs.flutter.dev/testing)
