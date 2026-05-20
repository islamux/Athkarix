# Search Functionality Documentation

This document explains how the search functionality is implemented in the Athkarix project.

## Overview

The search system allows users to find specific content across all lessons and pages in the application. It features diacritic-insensitive matching, making it easier to search for Arabic text regardless of whether it includes harakat (vowels).

## Core Components

### 1. `DataSearch` (`lib/helpers/search/data_search.dart`)

The main search logic is implemented using Flutter's `SearchDelegate`. This class handles the search UI and result generation.

- **`buildResults`**: Generates and displays a list of search results.
- **`buildSuggestions`**: Provides a placeholder or suggestions as the user types (currently set to a static prompt).
- **`_buildResultsWithPage`**: The engine that iterates through all data lists (`elmListPreNewOrder` through `elmList31NewOrder` and `finalListNewOrder`) to find matches.

### 2. `SearchResult` (`lib/helpers/search/search_result.dart`)

A data class that holds information about a specific match:
- `listName`: The name of the lesson (e.g., "الدرس الأول").
- `pageIndex`: The index of the page within the lesson.
- `matchedText`: The actual content snippet where the match was found.
- `routeName`: The navigation route for the lesson.
- `fieldName`: The specific section where the match was found (Title, Subtitle, Text, Ayah, or Footer).

### 3. Diacritic Removal (`lib/helpers/search/remove_search_diacritics.dart`)

Arabic text often contains diacritics (harakat) that can make searching difficult if the user doesn't type them exactly. The `removeSearchDiacritics` function uses a regular expression to strip these characters, allowing for "fuzzy" matching of core letters.

```dart
String removeSearchDiacritics(String? text) {
  if (text == null) return '';
  return text.replaceAll(RegExp(r'[^\u0621-\u064A\s]'), '');
}
```

## How It Works

### 1. **Content Traversal**: When a search is performed, the system iterates through every page of every lesson.

### 2. **Field Checking**: For each page, it checks all content fields in the order they appear:
- Titles
- Subtitles
- Main Texts
- Quranic Ayahs
- Footers

### 3. **Normalization**: Both the search query and the content being checked are passed through `removeSearchDiacritics`.

### 4. **Matching**: The system checks if the normalized content contains the normalized query.

### 5. **Navigation**: Tapping a result uses `Navigator.pushNamed` with the corresponding `routeName` and passes the `pageIndex` as an argument to jump directly to the relevant page.

**Note**: Search result navigation does NOT automatically scroll to the specific page or field. It only opens the page and passes the page index. The page content (slider) then handles scrolling to the correct position.

## Integration

The search is typically triggered from the `AppBar` of various pages using:

```dart
showSearch(context: context, delegate: DataSearch());
```

## Code Examples

### Registering a New Lesson

To add a new lesson with search capability, add it to the `listConfigs` array in `lib/helpers/search/data_search.dart`:

```dart
import 'package:athkarix/core/data/model/model_list/your_new_lesson_list_model.dart';

// In the listConfigs array within _buildResultsWithPage method:
  ListConfig(
    listName: 'اسم الدرس الجديد',  // Display name
    dataList: yourNewLessonList,          // Import your lesson data list
    routeName: AppRoute.yourLesson,     // Route to the lesson page
  ),
```

### Search Result Display

Search results are displayed using the `SearchResult` widget:

```dart
class CustomSearchResultPage extends StatelessWidget {
  final SearchResult searchResult;

  const CustomSearchResultPage({
    super.key, 
    required this.searchResult,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.black,
          title: const Text(
            'نتائج البحث',
            style: TextStyle(
              color: AppColor.primaryColorGolden,
              backgroundColor: AppColor.primaryColorBlack2,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            searchResult.matchedText!,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
```

### Data Structure for Lessons

Each lesson uses a model list file in `lib/core/data/model/model_list/`. The data structure is:

```dart
class LessonNameModel {
  final String duaText;
  final String? footer;
  final String? ayah;
}

List<LessonNameModel> lessonList = [
  LessonNameModel(duaText: "Title text", footer: "Footer text"),
  LessonNameModel(duaText: "Another text", ayah: "Ayah text"),
];
```

## Performance Considerations

### Current Approach

The search implementation uses a **full in-memory scan** approach:
- All lesson data is loaded into memory arrays
- Search iterates through every field of every item
- Results are collected and displayed

**Pros:**
- Fast for current dataset size
- No network calls required
- Immediate results

**Cons:**
- Memory usage scales linearly with data size
- May become slow if content grows significantly (1000+ items)
- No indexing or search optimization

### When Indexing Is Needed

Consider implementing a database or full-text search solution when:
- Total content exceeds 50,000 characters
- Search results take > 500ms to appear
- Memory usage becomes problematic
- Frequent searches are expected

### Optimizations for Large Datasets

1. **Debounce Search Input**: Add a delay between keystrokes to reduce search operations:

```dart
// In DataSearch class
Timer? _debounce;
Duration _debounceDuration = const Duration(milliseconds: 300);

void onQueryChanged(String query) {
  _debounce?.cancel();
  _debounce = Timer(_debounceDuration, () {
    query = query;
    // Trigger search
  });
}
```

2. **Lazy Loading**: Only load data when search is triggered:

```dart
// Instead of loading all data at startup
// Load individual lesson data on-demand when needed
Future<List<LessonNameModel>> loadLessonData(String lessonName) async {
  return _loadDataForLesson(lessonName);
}
```

3. **Limit Results**: Show only top 50-100 matches initially, with "Load More" button:

```dart
@override
Widget buildSuggestions(BuildContext context) {
  if (results.length > 100) {
    return ListTile(
      title: Text('Load more results...'),
      onTap: () {
        // Load and show all results
      },
    );
  }
  return null; // Or show limited results
}
```

## Best Practices

### Naming Conventions

- **Lesson Files**: Use descriptive names like `athkar_sabah_list.dart`, `dua_men_quran_list.dart`
- **Helper Files**: Group related helpers in `lib/helpers/` directory
- **Model Files**: Keep models in `lib/core/data/model/` and `model_list/` directories

### Testing Recommendations

1. **Test Diacritic Removal**:
   - Search for "السلام" should find "السلام", "سلام" (with/without alif), "السالم"
   - Verify all match correctly

2. **Test Navigation**:
   - Search for a word in Title → Tap result → Verify it opens correct page and section

3. **Test Empty Search**:
   - Enter empty query → Should show all lessons or no results
   - Clear search → Should show all lessons

4. **Test Special Characters**:
   - Search for common Arabic words with and without harakat
   - Test with numbers and symbols

## Troubleshooting

### Search Results Not Appearing

**Problem**: Search completes but no results shown.

**Possible Causes**:
1. Data list not registered in `listConfigs`
2. Route name is incorrect or doesn't exist
3. Data structure doesn't match expected format
4. Diacritic removal is stripping too many characters

**Solution**: 
- Verify the data list is properly imported
- Check console logs for errors
- Test with exact strings from the data

### Navigation to Wrong Page

**Problem**: Tapping result opens wrong page or doesn't scroll to correct section.

**Possible Causes**:
1. `pageIndex` argument doesn't match page numbering (0-indexed vs 1-indexed)
2. Route name points to wrong page
3. Page doesn't handle the `pageIndex` argument

**Solution**:
- Verify page numbering in your data (starts from 0 or 1)
- Check route name in both search config and routes_constant.dart
- Add debug print to verify `pageIndex` value being passed

### Diacritic Matching Issues

**Problem**: Search doesn't find words with harakat.

**Possible Causes**:
1. The regular expression in `removeSearchDiacritics` is too aggressive
2. Text encoding issues in data files
3. Harakat are not being removed from content before matching

**Solution**:
- Test the regex pattern: `r'[^\u0621-\u064A\s]'` - should match common harakat only
- Add debug logs to show before/after diacritic removal
- Use `runes` property for safer character iteration

## Future Enhancements

### 1. Categorized Search

Allow users to filter search by content type:
- Search by: Athkar only
- Search by: Duas only
- Search by: Tasbih only
- Search by: Quran only

Implementation:

```dart
enum SearchCategory {
  all,
  athkar,
  dua,
  tasbih,
  quran,
}

// Add to DataSearch
SearchCategory? selectedCategory;

List<AthkarModel> getFilteredData() {
  switch (selectedCategory) {
    case SearchCategory.all:
      return allData;
    case SearchCategory.athkar:
      return athkarLists;
    case SearchCategory.dua:
      return duaLists;
    // ... other cases
  }
}
```

### 2. Full-Text Search with Highlighting

Implement full-text search across all content with result highlighting:

```dart
List<SearchMatch> fullTextSearch(String query) {
  final results = <SearchMatch>[];
  
  for (final lesson in allLessons) {
    for (final field in lesson.getAllFields()) {
      final matches = _findMatches(query, field.value);
      if (matches.isNotEmpty) {
        results.add(SearchMatch(
          lesson: lesson.name,
          field: field.name,
          matches: matches,
        ));
      }
    }
  }
  
  return results;
}

String _findMatches(String query, String text) {
  final indices = query.allMatches(text);
  return indices.map((index) {
    return TextSpan(
      text: text.substring(index.start, index.end),
      style: TextStyle(backgroundColor: Colors.yellow[300]),
    );
  }).toList();
}
```

### 3. Search History

Save recent searches and provide quick access:

```dart
class SearchHistoryManager {
  static const int _maxHistory = 10;
  static final List<String> _history = [];
  
  static void addToHistory(String query) {
    if (query.isNotEmpty && !_history.contains(query)) {
      _history.insert(0, query);
      if (_history.length > _maxHistory) {
        _history.removeLast();
      }
    }
  }
  
  static List<String> getRecentSearches() {
    return _history;
  }
}
```

### 4. Advanced Filters

Add filters to help users narrow results:
- Filter by recency (today, this week, this month)
- Filter by favorites (starred items)
- Filter by difficulty level (if applicable)

## Architecture Notes

### Data Flow

```
User Input (Search Query)
    ↓
removeSearchDiacritics (Normalize)
    ↓
Query Search Delegate (Match against all data)
    ↓
Display Results (SearchResult widgets)
    ↓
User Taps Result
    ↓
Navigator.pushNamed (Open page with pageIndex)
    ↓
Page Loads Data (Slider shows correct section)
```

### Key Dependencies

- `lib/helpers/search/data_search.dart` - Main search logic
- `lib/helpers/search/search_result.dart` - Result display widget
- `lib/helpers/search/remove_search_diacritics.dart` - Diacritic removal
- `lib/core/data/model/model_list/*` - Lesson data models
- `lib/core/data/static/routes_constant.dart` - Route definitions
- Package: `flutter/material.dart` - UI components
- Package: `get/get.dart` - Navigation

## Maintenance

### Adding New Content

When adding new Athkar, Duas, or other content to the app:

1. Create or update the appropriate model list file in `lib/core/data/model/model_list/`
2. Import the new list in `lib/helpers/search/data_search.dart`
3. Add the list configuration in the `listConfigs` array with:
   - `listName`: The display name for the lesson
   - `dataList`: The actual list of lesson items
   - `routeName`: The route to navigate to when results are tapped
4. Test search functionality with the new content

### Common Patterns

All lesson data lists follow this structure:

```dart
// In lib/core/data/model/model_list/your_lesson_list.dart
import 'package:athkarix/core/data/model/your_lesson_model.dart';

final List<LessonNameModel> yourLessonList = [
  LessonNameModel(duaText: "First content"),
  LessonNameModel(duaText: "Second content", footer: "Optional footer"),
  LessonNameModel(duaText: "Third", ayah: "Optional ayah"),
  // ... more items
];
```

Each item in the list becomes a searchable entity in the system.
