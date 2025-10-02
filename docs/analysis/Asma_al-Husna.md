# Documentation: Asma' al-Husna (The 99 Names of Allah)

This document details the module responsible for displaying the 99 Beautiful Names of Allah.

## 1. Overview

The Asma' al-Husna module is a read-only, swipeable gallery of the 99 Names. It follows the modern architectural pattern seen in the app, loading its data from a local JSON file. It is designed for contemplation and reading, so it does not include a counting mechanism.

## 2. UI (`assma_hussna_page.dart`)

- **Page:** `AssmaHussna`
- **Display:** The core of the UI is the `CustomTextSliderAssmaHussna` widget, which is a `PageView`. Each page in the slider displays one of the 99 Names along with its meaning or description.
- **AppBar:** The app bar is consistent with other pages, providing:
  - A title: "الأسماء الحسنى".
  - A back button to return to the home screen.
  - A share button to share the currently displayed Name and its text.
  - Font size adjustment controls (`+` and `-`).

## 3. State Management & Logic (`assma_hussna_controller.dart`)

The `AssmaHussnaControllerImp` is one of the more advanced controllers in the application, incorporating asynchronous data loading, error handling, and a fallback mechanism.

### Key Responsibilities:

- **Data Loading (`loadAssmaHussnaData`):
  1.  Sets a loading state (`isLoading.value = true`).
  2.  Calls a dedicated service, `AssmaHussnaService.getAllAssmaHussna()`, to fetch and parse data from the `assma-hussna.json` file.
  3.  **Data Transformation:** It maps the loaded `List<AssmaHussnaModel>` to a `List<AthkarModel>`. This is a crucial step for compatibility, as it allows the generic `CustomTextSliderAssmaHussna` widget (which likely expects an `AthkarModel`) to be used without modification. The `name` and `text` from the `AssmaHussnaModel` are combined into the `duaText` of the `AthkarModel`.
  4.  **Error Handling:** A `try...catch` block handles potential errors during file loading or parsing. If an error occurs, it sets an error state (`hasError.value = true`) and, importantly, falls back to a hard-coded static list (`assmaHussnaList`) to ensure the app remains functional.
  5.  Sets the loading state to false upon completion or error.

- **Data Model:** It uses a specific `AssmaHussnaModel` which contains `id`, `name`, and `text` fields, providing more structure than the generic `AthkarModel`.

- **Compatibility:** By extending `BaseAthkarController` and providing the transformed data via the `dataList` getter, it seamlessly integrates with the existing UI and sharing infrastructure.

```dart
// lib/controller/assma_hussna_controller.dart

// ...
Future<void> loadAssmaHussnaData() async {
  try {
    isLoading.value = true;
    // 1. Load from service which reads JSON
    assmaHussnaData = await AssmaHussnaService.getAllAssmaHussna();
    
    // 2. Convert to a compatible model for the UI
    _athkarModelList = assmaHussnaData.map((item) => AthkarModel(
      duaText: '[${item.name}]\n\n${item.text}',
    )).toList();
    
    isLoading.value = false;
  } catch (e) {
    hasError.value = true;
    errorMessage.value = e.toString();
    isLoading.value = false;
    
    // 3. Fallback to a static list on error
    print('Falling back to static data...');
    _athkarModelList = assmaHussnaList;
  }
}

// 4. Provide the transformed list to the UI
@override
List<dynamic> get dataList => _athkarModelList;
// ...
```

This robust implementation demonstrates a mature development approach, ensuring a smooth user experience even if the primary data source fails, and adapting a specific data model to a generic UI component for code reuse.
