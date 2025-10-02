# Guide: Converting Dart Lists to JSON

Hello! This is a step-by-step guide to help you finish refactoring the app's data sources. We will move all the hard-coded Dart lists into their own `.json` files. This is a best practice that will make the app much easier to update in the future.

### The Goal

Our goal is to replace every file in `lib/core/data/model/model_list/` with a corresponding file in `assets/json/` and update the controllers to read from them.

### The Pattern to Follow

Your project already has a perfect example of how this is done: **Athkar Al-Sabah**. Let's look at its structure.

- **The Data (`assets/json/athkar_sabah.json`):** It's a simple JSON array where each object has keys like `"text"`, `"count"`, etc.
- **The Controller (`lib/controller/athkar_sabah_controller.dart`):** It uses a `loadAdhkarData()` function to read the JSON file from the assets and decode it into a list.

We will replicate this pattern for all remaining modules.

---

## Step-by-Step: Migrating "Athkar After Salat"

Let's walk through converting the "Athkar After Salat" feature together. You can then repeat these exact steps for all the other modules.

### Step 1: Create the JSON File

First, take the data from the old Dart file and create a new JSON file.

1.  Look at the old file: `lib/core/data/model/model_list/athkar_after_salat_list.dart`. You will see a list of `AthkarModel` objects.
2.  Create a new file: `assets/json/athkar_after_salat.json`.
3.  Convert the Dart objects into JSON objects. The `duaText` property in Dart will become the `"text"` key in JSON. Add a `"count"` key for the number of repetitions.

**Example:**

If the Dart code is:
```dart
// athkar_after_salat_list.dart
List<AthkarModel> athkarAfterSalatList = [
  AthkarModel(duaText: "أَسْـتَغْفِرُ الله (ثَلاثاً)"),
  AthkarModel(duaText: "اللّهُـمَّ أَنْـتَ السَّلامُ..."),
];
```

The new JSON file should look like this:
```json
// assets/json/athkar_after_salat.json
[
  {
    "text": "أَسْـتَغْفِرُ الله",
    "count": 3,
    "description": "",
    "reference": ""
  },
  {
    "text": "اللّهُـمَّ أَنْـتَ السَّلامُ...",
    "count": 1,
    "description": "",
    "reference": ""
  }
]
```

### Step 2: Register the Asset

Now, you must tell the app about your new file.

1.  Open `pubspec.yaml`.
2.  Find the `assets:` section.
3.  Add your new file to the list.

```yaml
flutter:
  assets:
    - assets/images/91k.jpg
    - assets/images/athkari5.jpg
    - assets/json/ # This line already includes all json files!
```

*Good news! Your `pubspec.yaml` is already configured to include any file inside `assets/json/`, so you don't need to change anything here. Just make sure your new file is in the correct directory.*

### Step 3: Update the Controller

This is the most important part. We need to tell the controller to read from our new JSON file instead of the old Dart list.

1.  Open `lib/controller/athkar_after_salat_controller.dart`.
2.  Modify it to look like the `AthkarSabahControllerImp`.

**Before:**
```dart
// lib/controller/athkar_after_salat_controller.dart
import 'package:athkarix/core/data/model/model_list/athkar_after_salat_list.dart';

class AthkarAfterSalatControllerImp extends BaseAthkarController {
  // ...
  @override
  List get dataList => athkarAfterSalatList; // Using the hard-coded list

  @override
  List<int> get maxPageCounters => List.filled(athkarAfterSalatList.length, 1);
  // ...
}
```

**After:**
```dart
// lib/controller/athkar_after_salat_controller.dart
import 'dart:convert'; // Import dart:convert
import 'package:flutter/services.dart'; // Import flutter services
import 'package:get/get.dart'; // Make sure Get is imported

class AthkarAfterSalatControllerImp extends BaseAthkarController {
  // 1. Add a variable to hold the loaded data
  List<dynamic>? adhkarAfterSalatList;

  // ... (pageController remains the same)

  // 2. Add onInit to load the data when the controller starts
  @override
  void onInit() {
    super.onInit();
    loadAdhkarData();
  }

  // 3. Create the data loading function
  Future<void> loadAdhkarData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/json/athkar_after_salat.json');
      adhkarAfterSalatList = json.decode(jsonString);
      update(); // Tell the UI to rebuild with the new data
    } catch (e) {
      print('Error loading adhkar data: $e');
    }
  }

  // 4. Update the dataList getter
  @override
  List<dynamic> get dataList => adhkarAfterSalatList ?? []; // Return the loaded list

  // 5. Update maxPageCounters to be dynamic
  @override
  List<int> get maxPageCounters {
    if (adhkarAfterSalatList != null && adhkarAfterSalatList!.isNotEmpty) {
      return adhkarAfterSalatList!.map((item) => item['count'] as int? ?? 1).toList();
    }
    return [];
  }

  // ... (completionMessage remains the same)
}
```

> **Note:** You will also need to update any UI widgets that use this data. For example, the `CustomTextSliderAthkarAfterSalat` will now get its text from `controller.adhkarAfterSalatList![index]['text']` instead of `controller.dataList[index].duaText`.

---

## Step 4: Repeat for Other Modules

Your task is now to repeat the three steps above for the following modules:

-   `DuaMenQuran`
-   `DuaMenSunnah`
-   `Estigfar`
-   `Hamd`
-   `Tasbih`
-   `SalatAlaRasoul`
-   `AthkarBeforeGoToBed` (the legacy one)

For each one: **Create JSON -> Update Controller**.

---

## Step 5: Cleanup

Once you have successfully migrated a module and tested that it works correctly, you can safely delete the old Dart list file.

For example, after converting `AthkarAfterSalat`, you can delete:
`lib/core/data/model/model_list/athkar_after_salat_list.dart`.

Do this for all the migrated modules to keep the project clean.

That's it! By following these steps, you will successfully modernize the project's data handling strategy. Good luck!
