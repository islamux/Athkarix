# Documentation: State Management & Data

This document provides a high-level overview of the state management architecture and data handling strategies used throughout the Athkarix application.

## 1. State Management: GetX

The project exclusively uses the **GetX** package for state management, dependency injection, and routing. This provides a consistent and lightweight framework for managing the app's state.

### A. Dependency Injection (`binding.dart`)

- **Centralized Bindings:** The `MyBinding` class is responsible for initializing and making all the necessary controllers available to the application as soon as they are needed.
- **`Get.put()`:** It uses `Get.put()` to create and register a singleton instance of each controller. This means that the same instance of a controller (e.g., `FontControllerImp`) can be accessed from any part of the app using `Get.find()`.
- **Lazy Loading:** While `Get.put()` is used here, GetX bindings are inherently lazy-loaded, meaning the controllers are not actually created until they are first accessed by a view.

```dart
// lib/binding.dart
class MyBinding extends Bindings {
  @override
  void dependencies() {
    // All controllers are registered here
    Get.put(FontControllerImp());
    Get.put(EstigfarControllerImp());
    Get.put(TasbihControllerImp());
    // ... and so on for all other controllers
  }
}
```

### B. Reactive UI

- **`GetBuilder`:** The UI widgets are wrapped in `GetBuilder<ControllerType>` to react to state changes. When `update()` is called within a controller, only the `GetBuilder` widgets associated with that controller are rebuilt, leading to efficient UI updates.
- **`.obs` and `Obx`:** For more granular reactivity, some properties (like `isLoading` in `AssmaHussnaControllerImp`) are made observable by appending `.obs`. The UI can then be wrapped in an `Obx` widget to automatically rebuild whenever that specific property changes.

## 2. Controller Architecture: `BaseAthkarController`

To avoid code duplication, a significant portion of the app's logic is centralized in an abstract class: `BaseAthkarController`.

- **Abstract Class:** It defines a contract that all Athkar-related controllers must follow.
- **Abstract Members:** Subclasses are required to provide their own implementation for:
  - `pageController`: The `PageController` for their specific `PageView`.
  - `maxPageCounters`: The list of recitation counts.
  - `dataList`: The list of data models to display.
  - `completionMessage`: The message to show when the user finishes the section.
- **Shared Logic:** It provides concrete implementations for common actions like `goToHome()`, `resetCounter()`, `onPageChanged()`, and the core `increamentPageController()` logic.

This powerful pattern allows each specific controller (e.g., `AthkarSabahControllerImp`) to be very concise, focusing only on loading its unique data while inheriting all the common interaction logic.

```dart
// lib/controller/base_athkar_controller.dart
abstract class BaseAthkarController extends GetxController {
  // Abstract properties to be implemented by subclasses
  PageController get pageController;
  List<int> get maxPageCounters;
  List<dynamic> get dataList;
  String get completionMessage;

  // Common logic shared by all subclasses
  void increamentPageController() {
    // ... core counting and page-turning logic ...
  }
}
```

## 3. Data Handling Strategy

The application uses two primary methods for storing and loading its content:

### A. JSON Files (Modern Approach)

- **Location:** `assets/json/`
- **Examples:** `athkar_sabah.json`, `assma-hussna.json`
- **Structure:** These files contain a JSON array of objects. Each object represents an item (a dhikr or a Name of Allah) and has key-value pairs for its content (`text`, `name`), recitation count (`count`), description, etc.
- **Loading:** Controllers use `rootBundle.loadString()` to read the file as a string, and `json.decode()` to parse it into a `List<dynamic>`.
- **Advantages:** This is the preferred method. It decouples the data from the code, making it easy to update, manage, and even fetch from a remote server in the future without changing the application's source code.

```json
// assets/json/assma-hussna.json
[
  {
    "id": 1,
    "name":"اللَّهُ",
    "text":"..."
  },
  // ...
]
```

### B. Hard-coded Dart Lists (Legacy Approach)

- **Location:** `lib/core/data/model/model_list/`
- **Examples:** `dua_men_quran_list.dart`, `estigfar_list_model.dart`
- **Structure:** These files define a `List` of `AthkarModel` objects directly in the Dart code.
- **Advantages:** Simple for small, static datasets that are unlikely to change.
- **Disadvantages:** Inflexible. Any change to the data requires a developer to edit the source code and release a new version of the app.

This dual approach indicates a project in transition, with newer and more complex features (`AsmaAlHusna`, `AthkarSabah`) using the flexible JSON method, while older or simpler sections still rely on the original hard-coded lists.
