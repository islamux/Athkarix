# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Athkarix is a Flutter application for Islamic Athkar (remembrances) and Duas. It's a bilingual (Arabic/English) Islamic prayer app with multiple categories of dhikr, a tasbih counter, and beautiful UI themes.

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart (SDK >=2.18.2, <3.0.0)
- **State Management**: GetX (routing, state management, dependency injection)
- **Data Storage**: JSON files (modern) + Dart lists (legacy)
- **Fonts**: Amiri, Cairo (Arabic fonts)
- **Key Dependencies**: share_plus, intl, shared_preferences, url_launcher, flutter_native_splash

## Common Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on specific device
flutter run -d <device-id>

# Hot reload (during development)
# Press 'r' in the terminal

# Hot restart
# Press 'R' in the terminal

# Analyze code for errors
flutter analyze

# Run tests
flutter test

# Run specific test file
flutter test test/assma_hussna_test.dart

# Clean build cache
flutter clean && flutter pub get

# Build APK (Android)
flutter build apk

# Build App Bundle (Android - preferred for Play Store)
flutter build appbundle

# Build iOS (requires Xcode)
flutter build ios

# Format code
dart format .

# Generate launcher icons
flutter pub run flutter_launcher_icons:main

# Generate splash screen
flutter pub run flutter_native_splash:create
```

### Gradle Setup (Linux)

If using local Gradle setup:
```bash
source use_local_gradle.sh
```

## Code Architecture

### Directory Structure

```
lib/
├── binding.dart                  # GetX dependency injection bindings
├── main.dart                     # App entry point
├── route.dart                    # Route definitions
├── controller/                   # Business logic (18 controllers)
├── core/
│   ├── data/
│   │   ├── json/                # JSON data files (modern approach)
│   │   ├── model/               # Data models
│   │   ├── service/             # Data services
│   │   └── static/              # Constants & legacy data
│   └── data/static/
│       ├── theme/               # App themes
│       ├── text/                # Legacy text data
│       └── routes_constant.dart # Route names
├── function/                    # Utility functions
├── view/
│   ├── pages/                   # UI screens (15 pages)
│   └── widget/                  # Reusable UI components
assets/
├── json/                        # JSON data files
├── fonts/                       # Arabic fonts (Amiri, Cairo)
└── images/                      # App images
test/                            # Unit & widget tests
docs/                            # Comprehensive project documentation
```

### Architecture Pattern

**GetX + MVC Pattern:**
- **Controllers**: Handle business logic, state management (GetX controllers)
- **Views**: UI components (Flutter widgets)
- **Models**: Data structures

### State Management

All controllers use **GetX** for:
- Reactive state management (`.obs` + `Obx`)
- Dependency injection via `Get.put()` in `binding.dart:21-44`
- Named routing via `GetMaterialApp`

### Base Controller Pattern

`BaseAthkarController` (`lib/controller/base_athkar_controller.dart`) provides shared logic for all Athkar controllers:
- Counter management (`increamentPageController()`)
- Page navigation (`onPageChanged()`)
- Navigation to home (`goToHome()`)
- Counter reset (`resetCounter()`)

Subclasses only define:
- `pageController`
- `maxPageCounters`
- `dataList`
- `completionMessage`

### Data Management

**Two approaches并存:**

1. **JSON Files (Modern - Preferred)**
   - Location: `assets/json/`, `lib/core/data/json/`
   - Examples: `athkar_sabah.json`, `assma-hussna.json`
   - Loaded via `rootBundle.loadString()` + `json.decode()`
   - More flexible, easier to update

2. **Hard-coded Dart Lists (Legacy)**
   - Location: `lib/core/data/model/model_list/`
   - Examples: `dua_men_quran_list.dart`, `estigfar_list_model.dart`
   - Defined as static `List<AthkarModel>`
   - Being migrated to JSON (see docs/guides/GUIDE_CONVERT_TO_JSON.md)

### Routing

Routes defined in `lib/route.dart:21-47` using GetX `GetPage` objects. Route names stored in `lib/core/data/static/routes_constant.dart`.

Navigate with: `Get.toNamed(AppRoute.athkarSabah)`

### Dependency Injection

All controllers registered in `lib/binding.dart` using `Get.put()`:
- Lazy loading (created on first use)
- Singleton pattern (same instance throughout app)
- 18 controllers registered including:
  - `FontControllerImp` (theme/font management)
  - `HomeControllerImp` (main navigation)
  - Feature controllers (`AthkarSabahControllerImp`, `AssmaHussnaControllerImp`, etc.)

## Key Files

- **Entry Point**: `lib/main.dart:8-40` - Initializes GetMaterialApp
- **Bindings**: `lib/binding.dart:21-44` - Controller registration
- **Routes**: `lib/route.dart:21-47` - Named route definitions
- **Route Constants**: `lib/core/data/static/routes_constant.dart` - Route name strings
- **Theme**: `lib/core/data/static/theme/app_them.dart` - App themes (golden, dark, light)
- **Home**: `lib/view/pages/home.dart` - Main navigation screen

## Data Models

Common model: `AthkarModel` (`lib/core/data/model/athkar_model.dart`)
- Fields: `id`, `content`, `footer`, `count`, etc.
- Each feature may have specialized models (e.g., `AssmaHussnaModel`)

## Testing

**Test Location**: `test/` directory
- **Widget Tests**: `test/widget_test.dart`
- **Unit Tests**: `test/assma_hussna_test.dart` (comprehensive service/model tests)

Run tests with:
```bash
flutter test
```

## Key Features

- **Multi-category Athkar**: Morning (Sabah), Evening (Massa), After Prayer, Sleep (Nawm), etc.
- **99 Names of Allah** (Asma' al-Husna)
- **Tasbih Counter**: Digital counter with haptic feedback
- **Dua Collections**: From Quran and Sunnah
- **Search**: Custom search with diacritics removal (`lib/function/remove_search_diacritics.dart`)
- **Sharing**: Share content via `share_plus` (`lib/function/custom_share_content.dart`)
- **Dark/Light Theme**: Switchable via `FontControllerImp`

## Important Notes

1. **Migration in Progress**: Project transitioning from Dart lists to JSON data sources
   - See `docs/guides/GUIDE_CONVERT_TO_JSON.md` for conversion process
   - Recent commits: "Migrate remaining Dart lists to JSON data sources"

2. **GetX-centric**: All navigation, state, and DI through GetX
   - No Provider, Riverpod, or BLoC
   - Potential future migration documented in `docs/guides/MIGRATION_GETX_TO_BLOC.md`

3. **Arabic Font Support**: Uses Amiri and Cairo fonts for proper Arabic rendering
   - Defined in `pubspec.yaml:51-61`

4. **Localized Assets**: JSON files contain Arabic text with Unicode encoding

## Resources

- **Full Documentation**: `docs/README.md` - Comprehensive project documentation
- **Architecture Analysis**: `docs/analysis/Core_Structure_and_Navigation.md`
- **State Management**: `docs/analysis/State_Management_and_Data.md`
- **Feature Guides**: `docs/analysis/*.md` - Module-by-module breakdown
