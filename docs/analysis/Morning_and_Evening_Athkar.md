# Documentation: Morning & Evening Athkar

This document details the functionality of the Morning Athkar (`Athkar al-Sabah`) and Evening Athkar (`Athkar al-Masa`) modules. Both modules share a nearly identical structure and logic, inheriting from a base controller.

## 1. UI Components (`athkar_sabah_page.dart` & `athkar_massa_page.dart`)

The UI for both pages is designed for focus and ease of use.

### Key UI Elements:
- **AppBar:**
  - **Title:** Clearly labels the section (e.g., "أذكار الصباح").
  - **Back Button:** Navigates back to the Home screen and resets the counter for the current page.
  - **Share Button:** Opens the native share dialog to share the current dhikr text.
  - **Font Controls:** Includes `+` and `-` buttons to increase or decrease the text size for readability, managed by `FontControllerImp`.
- **Body:**
  - The main content area is a `GestureDetector` that wraps a custom widget (`CustomTextSliderAthkarSabah` or `CustomTextSliderAthkarMassa`).
  - **Tapping the screen** anywhere increments the counter for the current dhikr.
- **Floating Action Button (`CustomFloatingButton`):**
  - Displays the current repetition count for the dhikr on screen.
  - Tapping this button also increments the counter.

```dart
// Example from athkar_sabah_page.dart
body: SafeArea(
  child: GestureDetector(
      onTap: () {
        // Tapping the screen increments the counter
        Feedback.forTap(context);
        controllerS.increamentPageController();
      },
      child: const CustomTextSliderAthkarSabah()),
),
```

## 2. State Management & Logic

The logic for both modules is handled by their respective GetX controllers, `AthkarSabahControllerImp` and `AthkarMassaControllerImp`. Both controllers extend a `BaseAthkarController`, which centralizes common functionality.

### `BaseAthkarController` (Implicit)
This base class likely provides the core properties and methods used by all Athkar pages, such as:
- `currentPageIndex`: Tracks the current dhikr being displayed.
- `currentPageCounter`: Tracks the repetitions for the current dhikr.
- `fontSize`: Manages the text size.
- `resetCounter()`: Resets the counters when leaving the page.

### `AthkarSabahControllerImp` & `AthkarMassaControllerImp`

These controllers override and implement the specifics for their respective modules.

#### Key Responsibilities:
- **Data Loading:**
  - In the `onInit()` method, each controller calls `loadAdhkarData()`.
  - This function reads the relevant JSON file (`adhkar_sabah.json` or `adhkar_massa.json`) from the assets.
  - It decodes the JSON string into a `List<dynamic>` (e.g., `adhkarSabahList`).
- **Counter Logic:**
  - The `maxPageCounters` getter dynamically creates a list of required repetition counts from the loaded JSON data.
  - The `increamentPageController()` method contains the core logic:
    1. It increments `currentPageCounter`.
    2. It checks if the counter has reached the required count for the current dhikr (`maxPageCounters[currentPageIndex]`).
    3. If the count is met, it increments `currentPageIndex` to move to the next dhikr, resets the `currentPageCounter` to 0, and animates the `PageView` to the next page.
    4. It provides haptic feedback (`HapticFeedback.vibrate()`) on page transition.
    5. When all Athkar are completed, it shows a `Get.snackbar` with a completion message (e.g., "أنهيت أذكار الصباح !").
- **Data Accessors:**
  - Helper methods like `getAthkarText(index)`, `getAthkarDescription(index)`, and `getAthkarCount(index)` provide easy access to the properties of each dhikr object within the loaded JSON list.

```dart
// Example from AthkarSabahControllerImp
Future<void> loadAdhkarData() async {
  try {
    final String jsonString = await rootBundle.loadString('lib/core/data/json/adhkar_sabah.json');
    adhkarSabahList = json.decode(jsonString);
    update(); // Notifies GetX to update the UI
  } catch (e) {
    print('Error loading adhkar data: $e');
  }
}

void increamentPageController() {
  currentPageCounter++;
  if (currentPageCounter >= maxPageCounters[currentPageIndex]) {
    currentPageIndex++;
    if (currentPageIndex < maxPageCounters.length) {
      currentPageCounter = 0;
      HapticFeedback.vibrate();
      pageController.nextPage(...);
    } else {
      Get.snackbar('الحمدلله', completionMessage);
    }
  }
  update();
}
```

## 3. Data Source (`adhkar_sabah.json` & `adhkar_massa.json`)

The content for both modules is stored in local JSON files. Each file contains a list of objects, where each object represents a single dhikr.

### JSON Object Structure:
```json
[
  {
    "text": "...",        // The Arabic text of the dhikr
    "count": 1,           // The number of times it should be recited
    "description": "...", // A description or virtue of the dhikr
    "reference": "..."    // The source or reference for the dhikr
  }
]
```
