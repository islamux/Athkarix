# Documentation: Prayer & Sleep Athkar

This document covers the various modules related to remembrances for prayers and sleep. These include Athkar after Salah (prayer), before sleep, and upon waking up.

## 1. Overview

All these modules follow the same architectural pattern established by the Morning and Evening Athkar pages:

- **UI Page:** A dedicated widget for the UI (e.g., `AthkarAfterSalat`).
- **GetX Controller:** A controller to manage state and logic (e.g., `AthkarAfterSalatControllerImp`).
- **Data Source:** Content is loaded from either a local JSON file or a hard-coded Dart list.
- **Base Controller:** Logic is centralized by extending `BaseAthkarController`.

The primary user interaction is tapping the screen or a floating action button to count recitations and advance through a `PageView` of remembrances.

## 2. Modules

### A. Athkar After Salat (Prayer)

- **Page:** `athkar_after_salat_page.dart`
- **Controller:** `athkar_after_salat_controller.dart`
- **Data Source:** `athkar_after_salat_list.dart` (Hard-coded Dart list)

**Logic:**
- The controller `AthkarAfterSalatControllerImp` extends `BaseAthkarController`.
- It gets its data directly from `athkarAfterSalatList`, a pre-defined list of `Athkar` model objects.
- The `maxPageCounters` is a simple list filled with `1`s, as most remembrances in this section are recited once. The logic for multi-count items (like saying "Subhan'Allah" 33 times) is likely handled within a single page/item in the list rather than by advancing the page view 33 times.

### B. Athkar Before Sleep & Upon Waking

This functionality is split across a few files, suggesting some evolution in the codebase.

**1. Athkar Before Go To Bed (Legacy)**
- **Page:** `athkar_before_.go_to_bed.dart`
- **Controller:** `athkar_before_go_to_bed_controller.dart`
- **Data Source:** `athkar_before_go_to_bed_list.dart` (Hard-coded Dart list)
- **Note:** This appears to be an older implementation using hard-coded Dart lists, similar to the "After Salat" module.

**2. Athkar Nawm (Sleep - Current)**
- **Page:** `athkar_nawm_page.dart`
- **Controller:** `athkar_nawm_controller.dart`
- **Data Source:** `adhkar_nawm.json` (Local JSON file)
- **Logic:** The `AthkarNawmControllerImp` loads its data from a JSON file, which is the more modern and flexible approach used in the app. It dynamically builds its `maxPageCounters` from the `count` property in the JSON data.

**3. Athkar Istiqadh (Waking Up)**
- **Page:** `athkar_istiqadh_page.dart`
- **Controller:** `athkar_istiqadh_controller.dart`
- **Data Source:** `adhkar_istiqadh.json` (Local JSON file)
- **Logic:** The `AthkarIstiqadhControllerImp` follows the modern pattern of loading its content and recitation counts from a dedicated JSON file.

## 3. Data Source Transition

The presence of two different data loading strategies is notable:

- **Legacy (Hard-coded Dart List):** Used in `AthkarAfterSalat` and the older `AthkarBeforeGoToBed`. This method is less flexible. Changes to the Athkar require modifying the code and recompiling the app.
  ```dart
  // Example from athkar_after_salat_controller.dart
  @override
  List get dataList => athkarAfterSalatList;
  ```

- **Modern (JSON Asset):** Used in `AthkarNawm` and `AthkarIstiqadh`, as well as the Morning/Evening modules. This is a better practice, as the content can be updated by simply changing the JSON file without touching the Dart code.
  ```dart
  // Example from athkar_nawm_controller.dart
  Future<void> loadAdhkarData() async {
    final String jsonString = await rootBundle.loadString('lib/core/data/json/adhkar_nawm.json');
    adhkarNawmList = json.decode(jsonString);
    update();
  }
  ```

This indicates a refactoring effort within the project to move from hard-coded data to a more maintainable JSON-based system.
