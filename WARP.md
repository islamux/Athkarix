# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Common Development Commands

### Build and Run
```bash
# Install dependencies
flutter pub get

# Run on connected device/emulator (Android/iOS)
flutter run

# Run with specific build mode
flutter run --debug
flutter run --release

# Run on specific device (use flutter devices to list)
flutter run -d <device-id>
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/assma_hussna_test.dart
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format code consistently
flutter format .
flutter format lib/

# Get outdated dependencies
flutter pub outdated

# Upgrade dependencies
flutter pub upgrade
```

### Build for Production
```bash
# Build APK for Android
flutter build apk --release

# Build app bundle for Play Store
flutter build appbundle --release

# Build iOS app (requires Xcode and macOS)
flutter build ios --release

# Generate launcher icons (configured in pubspec.yaml)
flutter pub run flutter_launcher_icons:main
```

### Development Environment Setup
```bash
# Source local Gradle setup (if needed)
source ./use_local_gradle.sh

# Check Flutter environment
flutter doctor
flutter doctor -v
```

## Architecture Overview

This is a **Flutter Islamic Athkar (Remembrance) App** called "Athkarix" using the **GetX pattern** for state management and navigation.

### Key Architectural Patterns

- **GetX State Management**: Used throughout for reactive programming, dependency injection, and navigation
- **Page-Controller Pattern**: Each page has a dedicated controller extending `GetxController` or `BaseAthkarController`
- **Service Layer**: JSON data loading and business logic separation
- **Static Data Management**: Theme constants, color schemes, and route definitions
- **Reactive UI**: Uses `GetBuilder`, `Obx` for automatic UI updates

### Directory Structure

```
lib/
├── main.dart              # App entry point with GetMaterialApp
├── binding.dart           # Global dependency injection setup
├── route.dart            # App route definitions using GetX routing
├── controller/           # GetX controllers for each feature
│   ├── base_athkar_controller.dart  # Base class for common athkar functionality
│   ├── home_controller.dart
│   ├── athkar_*_controller.dart     # Feature-specific controllers
│   ├── font_controller.dart         # Global font size/family management
│   └── floating_action_button_controller.dart
├── view/
│   ├── pages/            # UI pages/screens
│   └── widget/           # Reusable custom widgets
├── core/
│   ├── data/
│   │   ├── json/         # Static Islamic content data
│   │   ├── model/        # Data models (AthkarModel, AssmaHussnaModel)
│   │   ├── service/      # Data loading services
│   │   └── static/       # App constants (theme, colors, routes)
│   └── function/         # Utility functions
└── function/             # App-wide utility functions
```

### Key Design Patterns

1. **Base Controller Pattern**: `BaseAthkarController` provides common functionality for counter management, page navigation, sharing, and completion handling

2. **GetX Dependency Injection**: All controllers are initialized in `binding.dart` and accessed via `Get.find<ControllerType>()`

3. **Reactive Font System**: `FontControllerImp` manages app-wide font size and family changes dynamically

4. **JSON Data Architecture**: Islamic content stored as structured JSON with `content`, `footer`, and reference fields

5. **Theme Management**: Centralized color scheme and typography in `core/data/static/theme/`

## Development Guidelines

### Working with Controllers

- **Extend `BaseAthkarController`** for new athkar-related features to inherit common functionality (counters, page navigation, sharing)
- **Use `Get.find<ControllerType>()`** instead of `Get.put()` when controller is already initialized in binding
- **Call `resetCounter()`** before navigating away from athkar pages to reset state
- **Update UI** with `update()` method after state changes, or use reactive variables with `Obx`

### Adding New Athkar Categories

1. Create JSON data file in `lib/core/data/json/` or `assets/json/`
2. Create model class extending base athkar model structure
3. Create controller extending `BaseAthkarController`
4. Add controller to `binding.dart` dependency injection
5. Create page widget following existing pattern
6. Create custom text slider widget for content display
7. Add route constant in `routes_constant.dart`
8. Register route in `route.dart`

### Working with Themes and Colors

- **Golden Theme**: App uses a golden color scheme defined in `AppColor` class
- **Dynamic Font System**: Font size/family changes affect entire app through reactive theme
- **Arabic Typography**: Uses Amiri and Cairo fonts optimized for Arabic text
- **Responsive Design**: UI adapts to different screen sizes and orientations

### JSON Data Structure

Islamic content follows this structure:
```json
{
  "id": "unique_identifier",
  "content": "Arabic text content",
  "footer": "Source/explanation text with formatting"
}
```

### Custom Widget Patterns

- **Custom Text Sliders**: Each athkar category has dedicated slider widget for content display
- **Custom Floating Button**: Reusable floating action button with counter display
- **Custom Button**: Consistent button styling throughout app
- **GetView Pattern**: Use `GetView<ControllerType>` for widgets that only need controller access without full state management

### Font and Localization

- **Arabic-First Design**: App primarily displays Arabic Islamic content
- **Font Scaling**: Users can adjust font size dynamically via + / - buttons in app bars
- **Font Families**: Amiri (traditional) and Cairo (modern) fonts available
- **RTL Support**: Right-to-left text alignment for Arabic content

### State Management Best Practices

- **Reactive Variables**: Use `.obs` for data that changes frequently and needs UI updates
- **GetBuilder**: Use for specific widget rebuilds when reactive variables aren't needed
- **Controller Lifecycle**: Controllers persist through navigation unless explicitly disposed
- **Memory Management**: Controllers automatically cleaned up by GetX when no longer needed

### Testing Approach

- Test files in `test/` directory
- Current tests focus on specific features like `assma_hussna_test.dart`
- Widget testing setup available in `widget_test.dart`
- Run `flutter test` for automated testing

### Platform-Specific Notes

- **Android**: Uses Gradle build system, local setup script available (`use_local_gradle.sh`)
- **iOS**: Requires Xcode for building and running
- **Launcher Icons**: Configured via `flutter_launcher_icons` package with Islamic-themed icon
- **Native Splash**: Configuration available in `flutter_native_splash.yaml`

## Project Context

**Athkarix** is an Islamic app for daily remembrance (Athkar) and prayers (Duas), featuring:
- Morning/Evening remembrance collections
- Quranic supplications
- 99 Beautiful Names of Allah (Asma ul Husna)
- Prayer beads counter (Tasbih)
- Sharing functionality for Islamic content
- Dark/Light theme support
- Multi-font Arabic text rendering
