# JSON Conversion Plan - Remaining Pages

## Overview

Complete the migration from Dart hardcoded lists to JSON files for the remaining 5 pages in the Athkarix project.

**Target**: Convert 5 remaining pages from Dart lists to JSON files
**Progress**: 8/13 pages converted (62%)
**Remaining**: 5 pages to convert

---

## Pages To Convert

### 1. Tasbih (Digital Counter)
- **Controller**: `lib/controller/tasbih_controller.dart`
- **Model List**: `lib/core/data/model/model_list/tasbih_list_model.dart`
- **Status**: ❌ Not converted
- **Priority**: Medium

### 2. Salat Ala Rasoul (Prayer upon Prophet)
- **Controller**: `lib/controller/salat_ala_rasoul_controller.dart`
- **Model List**: `lib/core/data/model/model_list/salat_ala_rasoul_list_model.dart`
- **Status**: ❌ Not converted
- **Priority**: High (popular feature)

### 3. Hamd (Praises - Alhamdulillah)
- **Controller**: `lib/controller/hamd_controller.dart`
- **Model List**: `lib/core/data/model/model_list/hamd_list_model.dart`
- **Status**: ❌ Not converted
- **Priority**: High (fundamental prayer)

### 4. Estigfar (Seeking Forgiveness)
- **Controller**: `lib/controller/estigfar_controller.dart`
- **Model List**: `lib/core/data/model/model_list/estigfar_list_model.dart`
- **Status**: ❌ Not converted
- **Priority**: High (fundamental practice)

### 5. Dua Men Sunnah (Duas from Sunnah)
- **Controller**: `lib/controller/duaa_men_sunnah_controller.dart`
- **Model List**: `lib/core/data/model/model_list/dua_men_sunnah_list.dart`
- **Status**: ❌ Not converted
- **Priority**: High (Quranic content)

---

## Conversion Steps

### For Each Page, Follow These Steps:

#### Step 1: Examine Existing Data Structure
```bash
# Read the current Dart list file to understand the structure
cat lib/core/data/model/model_list/[page]_list_model.dart

# Check controller implementation
cat lib/controller/[page]_controller.dart
```

#### Step 2: Create JSON File
```bash
# Create JSON file in assets/json/ directory
touch assets/json/[page].json

# Or in lib/core/data/json/ directory (for consistency)
touch lib/core/data/json/[page].json
```

#### Step 3: Convert Data Format
- Transform hardcoded `List<[Model]>` to JSON array
- Maintain all fields: `id`, `content`, `footer`, `count`, etc.
- Ensure Arabic text is properly encoded (UTF-8)

**Example JSON Structure:**
```json
[
  {
    "id": 1,
    "content": "النص العربي",
    "footer": "الترجمة الإنجليزية",
    "count": 1,
    "description": "وصف إضافي",
    "reference": "المصدر"
  },
  {
    "id": 2,
    "content": "النص العربي",
    "footer": "الترجمة الإنجليزية",
    "count": 3,
    "description": "وصف إضافي",
    "reference": "المصدر"
  }
]
```

#### Step 4: Update Controller
Modify the controller file:
```dart
// Add import
import 'dart:convert';
import 'package:flutter/services.dart';

// Add JSON loading method
Future<void> load[Page]Data() async {
  try {
    final String jsonString = await rootBundle.loadString('assets/json/[page].json');
    final List<dynamic> jsonList = json.decode(jsonString);
    [page]List = jsonList.map((json) => [Model].fromJson(json)).toList();
  } catch (e) {
    print('Error loading [page] data: $e');
  }
}
```

#### Step 5: Update Controller Initialization
In `onInit()` method:
```dart
@override
void onInit() {
  super.onInit();
  load[Page]Data(); // Add this line
}
```

#### Step 6: Add to pubspec.yaml
If JSON file is in `assets/json/`:
```yaml
assets:
  - assets/json/tasbih.json
  - assets/json/salat_ala_rasoul.json
  - assets/json/hamd.json
  - assets/json/estigfar.json
  - assets/json/dua_men_sunnah.json
```

#### Step 7: Test the Implementation
```bash
# Run the app
flutter run

# Test each converted page
# Verify data loads correctly
# Check counters work
# Test navigation
```

#### Step 8: Clean Up (Optional - After Testing)
```bash
# Remove old Dart list file
rm lib/core/data/model/model_list/[page]_list_model.dart

# Remove import from controller
# Remove dependency on model list
```

---

## Detailed Conversion Guide Per Page

### Page 1: Tasbih

**Current Implementation:**
- File: `lib/controller/tasbih_controller.dart`
- Data: `tasbihListModel.dart`
- Counter-based page (digital tasbih)

**Steps:**
1. Read `tasbih_list_model.dart` to extract counter values
2. Create `assets/json/tasbih.json` with counter data
3. Update controller to load from JSON
4. Test counter functionality

**Expected JSON fields:**
- `id`: Unique identifier
- `counter`: Counter value (e.g., 33, 99, 100)
- `text`: Tasbih text
- `description`: Additional context

### Page 2: Salat Ala Rasoul

**Current Implementation:**
- File: `lib/controller/salat_ala_rasoul_controller.dart`
- Data: `salat_ala_rasoul_list_model.dart`

**Steps:**
1. Read `salat_ala_rasoul_list_model.dart` for prayer formats
2. Create JSON file with multiple prayer variations
3. Update controller for JSON loading
4. Test page navigation

**Expected JSON fields:**
- `id`: Unique identifier
- `content`: Arabic prayer text
- `footer`: Transliteration/translation
- `count`: Number of repetitions

### Page 3: Hamd

**Current Implementation:**
- File: `lib/controller/hamd_controller.dart`
- Data: `hamd_list_model.dart`

**Steps:**
1. Read `hamd_list_model.dart`
2. Create JSON with various Hamd formats
3. Update controller
4. Test text display

**Expected JSON fields:**
- `id`: Unique identifier
- `content`: Arabic "Alhamdulillah" variations
- `footer`: English translation
- `count`: Repetition count

### Page 4: Estigfar

**Current Implementation:**
- File: `lib/controller/estigfar_controller.dart`
- Data: `estigfar_list_model.dart`

**Steps:**
1. Read `estigfar_list_model.dart`
2. Create JSON with different Estigfar formats
3. Update controller
4. Test counter and navigation

**Expected JSON fields:**
- `id`: Unique identifier
- `content`: Arabic Istighfar phrases
- `footer`: Translation/meaning
- `count`: Default repetitions (100, 1000, etc.)

### Page 5: Dua Men Sunnah

**Current Implementation:**
- File: `lib/controller/duaa_men_sunnah_controller.dart`
- Data: `dua_men_sunnah_list.dart`

**Steps:**
1. Read `dua_men_sunnah_list.dart`
2. Create JSON with Sunnah duas
3. Update controller
4. Test search functionality (if applicable)

**Expected JSON fields:**
- `id`: Unique identifier
- `content`: Arabic dua text
- `footer`: Translation/benefits
- `count`: Recommended repetitions
- `reference`: Hadith/Quran reference

---

## Testing Checklist

After converting each page, verify:

- [ ] Page loads without errors
- [ ] All data displays correctly (Arabic text, translations)
- [ ] Counter functionality works (if applicable)
- [ ] Navigation between items works
- [ ] Search works (if applicable)
- [ ] Sharing functionality works (if applicable)
- [ ] No hardcoded Dart lists remain in controller
- [ ] Controller properly handles JSON loading errors
- [ ] Data validation passes

---

## Implementation Order

**Recommended Priority Order:**

1. **Estigfar** - High importance, simple structure
2. **Hamd** - Fundamental prayer, simple structure
3. **Salat Ala Rasoul** - Popular feature, moderate complexity
4. **Dua Men Sunnah** - Complex data with references
5. **Tasbih** - Unique counter-based logic, test thoroughly

**Alternative Order (by complexity):**

1. **Hamd** - Simplest structure
2. **Estigfar** - Simple structure
3. **Salat Ala Rasoul** - Moderate complexity
4. **Tasbih** - Unique counter logic
5. **Dua Men Sunnah** - Most complex with references

---

## Files to Modify/Create

### New JSON Files to Create:
```
assets/json/tasbih.json
assets/json/salat_ala_rasoul.json
assets/json/hamd.json
assets/json/estigfar.json
assets/json/dua_men_sunnah.json
```

### Controllers to Modify:
```
lib/controller/tasbih_controller.dart
lib/controller/salat_ala_rasoul_controller.dart
lib/controller/hamd_controller.dart
lib/controller/estigfar_controller.dart
lib/controller/duaa_men_sunnah_controller.dart
```

### Files to Update:
```
pubspec.yaml (add asset entries)
```

### Optional Cleanup (after testing):
```
lib/core/data/model/model_list/tasbih_list_model.dart
lib/core/data/model/model_list/salat_ala_rasoul_list_model.dart
lib/core/data/model/model_list/hamd_list_model.dart
lib/core/data/model/model_list/estigfar_list_model.dart
lib/core/data/model/model_list/dua_men_sunnah_list.dart
```

---

## References

- **Migration Guide**: `docs/guides/GUIDE_CONVERT_TO_JSON.md`
- **Example Conversions**:
  - `lib/controller/athkar_sabah_controller.dart` (fully converted)
  - `lib/controller/assma_hussna_controller.dart` (service-based approach)
- **JSON Service Pattern**: `lib/core/data/service/assma_hussna_service.dart`

---

## Success Criteria

✅ **Completion Requirements:**

1. All 5 pages load data from JSON files
2. All Arabic text displays correctly
3. All functionality (counters, navigation, search) works
4. Controllers handle errors gracefully
5. No hardcoded Dart list imports remain
6. Code follows existing project patterns
7. Tests pass (if applicable)

**Estimated Time:**
- Per page: 2-4 hours (including testing)
- Total: 10-20 hours
- Testing: 2-3 hours per page

---

## Notes

- **Data Integrity**: Ensure all Arabic text is properly encoded in UTF-8
- **Consistency**: Follow the exact JSON structure of converted pages
- **Backward Compatibility**: Keep old files until testing is complete
- **Performance**: JSON loading is async - handle loading states appropriately
- **Error Handling**: Add try-catch blocks for JSON loading failures

---

**Created**: 2025-10-31
**Status**: Planning Phase
**Next Action**: Start with Page 1 (Estigfar or Hamd)
