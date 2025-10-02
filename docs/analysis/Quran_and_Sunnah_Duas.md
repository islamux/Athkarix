# Documentation: Quran & Sunnah Duas

This document describes the modules responsible for displaying supplications (Duas) sourced from the Holy Quran and the Sunnah (prophetic traditions).

## 1. Overview

Both the "Dua from Quran" and "Dua from Sunnah" modules are structured as simple, read-only displays. Unlike the Athkar pages, they do not have a counting mechanism. Users can swipe through the supplications, adjust the font size, and share the content.

The architecture follows the legacy pattern seen in other parts of the app, where data is sourced from hard-coded Dart lists.

## 2. Modules

### A. Duas from Quran

- **Page:** `dua_men_quran.dart`
- **Controller:** `duaa_men_quran_controller.dart`
- **Data Source:** `dua_men_quran_list.dart` (Hard-coded Dart list)

**UI & Interaction:**
- The page `DuaMenQuran` displays a `CustomTextSliderDuaMenQuran` widget, which is a `PageView` that allows users to swipe horizontally through the different supplications.
- The AppBar provides a title, a back button, a share button, and font size controls.
- There is no floating action button or tap-to-count functionality, as these are for reading, not recitation counting.

**Logic:**
- `DuaMenQuranControllerImp` is a lightweight controller.
- It extends `BaseAthkarController` but only utilizes a fraction of its potential functionality.
- The `dataList` is populated from the hard-coded `duaMenQuranList`.
- The `maxPageCounters` is a list filled with `1`s, but it is not actively used since there is no counting mechanism on the page.

### B. Duas from Sunnah

- **Page:** `dua_men_sunnah.dart`
- **Controller:** `duaa_men_sunnah_controller.dart`
- **Data Source:** `dua_men_sunnah_list.dart` (Hard-coded Dart list)

**UI & Interaction:**
- This module is structurally identical to the "Duas from Quran" module.
- It uses a `CustomTextSliderDuaMenSunnah` to display the content in a swipeable `PageView`.

**Logic:**
- `DuaMenSunnahControllerImp` mirrors the Quran Dua controller.
- It sources its data from the `duaMenSunnahList`.
- It does not implement any counting logic.

## 3. Implementation Details

- **Data Source:** Both modules rely on the legacy method of using hard-coded Dart lists (`dua_men_quran_list.dart` and `dua_men_sunnah_list.dart`). This means that to add, remove, or edit a supplication, a developer must directly modify these lists in the source code.

- **Simplified Controller:** The controllers for these pages are very simple. They primarily exist to provide the data list to the UI and to identify the current page's content for the share functionality. The `increamentPageController` method inherited from `BaseAthkarController` is not called from the UI.

```dart
// lib/controller/duaa_men_quran_controller.dart

class DuaMenQuranControllerImp extends BaseAthkarController {
  final PageController pageControllerQuran = PageController();

  @override
  PageController get pageController => pageControllerQuran;

  // Data is sourced from a hard-coded list
  @override
  List<dynamic> get dataList => duaMenQuranList;

  // maxPageCounters is defined but not used for counting
  @override
  List<int> get maxPageCounters => List.filled(duaMenQuranList.length, 1);

  @override
  String get completionMessage => 'أنهيت قراءة أدعية من القراءن !';
}
```

This design is effective for its purpose, which is to present a list of items for reading in a clean, swipeable interface without the complexity of stateful counters.
