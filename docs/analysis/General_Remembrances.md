# Documentation: General Remembrances

This document covers the set of general-purpose remembrance modules: Tasbih (Praising Allah), Hamd (Gratitude to Allah), Istigfar (Seeking Forgiveness), and Salat ala Rasoul (Sending Blessings upon the Prophet).

These modules share a common goal: to provide a simple and focused interface for repeated recitations, functioning like a digital prayer bead (Misbaha).

## 1. Architectural Pattern

All four modules (`Tasbih`, `Hamd`, `Estigfar`, `SalatAlaRasoul`) are built using an identical architecture that differs from the Athkar pages.

- **Content Controller:** Each page has a lightweight GetX controller (e.g., `TasbihControllerImp`) that extends `BaseAthkarController`. Its primary role is to provide the list of phrases to the UI for display and sharing. Data is sourced from hard-coded Dart lists (e.g., `tasbih_list_model.dart`).

- **Counter Controller:** The counting logic is **delegated** to a separate, shared controller: `FloatingButtonControllerImp`. This is a key difference from the Athkar pages, where each controller managed its own counting state.

- **UI Page:** The UI consists of a swipeable `PageView` to select a phrase and a prominent counter.

## 2. Core Functionality

### A. Content Display
- Each module's page (e.g., `Tasbih.dart`) uses a custom slider widget (e.g., `CustomTextSliderTasbih`) to display different phrases for recitation (e.g., "سبحان الله", "الحمدلله").
- Users can swipe left and right to choose a phrase.

### B. Counter Logic (`FloatingButtonControllerImp`)
- **Shared State:** A single instance of `FloatingButtonControllerImp` is used across these pages to manage the counter state. This means the count is persistent when switching between Tasbih, Hamd, etc., within the same session.
- **Incrementing:** Tapping anywhere on the main content area (`GestureDetector`) or on the counter button itself calls `floatingController.increamentCouter()`.
- **Resetting:** A dedicated "تصفير" (Reset) button calls `floatingController.reset()` to set the counter back to zero.
- **Display:** The UI is wrapped in a `GetBuilder<FloatingButtonControllerImp>` to ensure the counter text updates whenever the state changes in the controller.

```dart
// Example from Tasbih.dart

// The shared controller for counting
FloatingButtonControllerImp floatingController =
        Get.put(FloatingButtonControllerImp());

// Tap the screen to count
body: SafeArea(
  child: GestureDetector(
    onTap: () {
      Feedback.forTap(context);
      floatingController.increamentCouter();
    },
    child: const CustomTextSliderTasbih(),
  ),
),

// Floating action buttons for counting and resetting
floatingActionButton: Row(
  children: [
    GetBuilder<FloatingButtonControllerImp>(builder: (context) {
      return CustomFloatingButton(
        onPressed: () => floatingController.increamentCouter(),
        text: Text('${floatingController.counter}'),
      );
    }),
    GetBuilder<FloatingButtonControllerImp>(builder: (context) {
      return CustomFloatingButton(
        onPressed: () => floatingController.reset(),
        text: Text('تصفير'),
      );
    })
  ],
),
```

## 3. Summary of Modules

| Module | Page | Content Controller | Data Source (Dart List) | Counter Logic | Notes |
|:---|:---|:---|:---|:---|:---|
| **Tasbih** | `tasbih.dart` | `TasbihControllerImp` | `tasbih_list_model.dart` | `FloatingButtonControllerImp` | General praise/glorification. |
| **Hamd** | `hamd.dart` | `HamdControllerImp` | `hamd_list_model.dart` | `FloatingButtonControllerImp` | Expressing gratitude. |
| **Istigfar** | `estigfar.dart` | `EstigfarControllerImp` | `estigfar_list_model.dart` | `FloatingButtonControllerImp` | Seeking forgiveness. |
| **Salat ala Rasoul** | `salat_ala_rasoul.dart` | `SalatAlaRasoulAllahControllerImp` | `salat_ala_rasoul_list_model.dart` | `FloatingButtonControllerImp` | Sending blessings on the Prophet. |

This decoupled design, where content is managed separately from the counter, allows for a consistent user experience across all general remembrance features. The use of a shared counter controller provides a seamless digital Misbaha experience.
