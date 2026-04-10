# Search Functionality Documentation

This document explains how the search functionality is implemented in the Salam project.

## Overview

The search system allows users to find specific content across all lessons and pages in the application. It features diacritic-insensitive matching, making it easier to search for Arabic text regardless of whether it includes harakat (vowels).

## Core Components

### 1. `DataSearch` (`lib/helpers/search/data_search.dart`)

The main search logic is implemented using Flutter's `SearchDelegate`. This class handles the search UI and result generation.

- **`buildResults`**: Generates and displays the list of search results.
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

Arabic text often contains diacritics (harakat) that can make searching difficult if the user doesn't type them exactly. The `removeSearchDiacritics` function uses a regular expression to strip these characters, allowing for "fuzzy" matching of the core letters.

```dart
String removeSearchDiacritics(String? text) {
  if (text == null) return '';
  return text.replaceAll(RegExp(r'[^\u0621-\u064A\s]'), '');
}
```

## How it Works

1. **Content Traversal**: When a search is performed, the system iterates through every page of every lesson.
2. **Field Checking**: For each page, it checks all content fields in the order they appear:
   - Titles
   - Subtitles
   - Main Texts
   - Quranic Ayahs
   - Footers
3. **Normalization**: Both the search query and the content being checked are passed through `removeSearchDiacritics`.
4. **Matching**: The system checks if the normalized content contains the normalized query.
5. **Navigation**: Tapping a result uses `Navigator.pushNamed` with the corresponding `routeName` and passes the `pageIndex` as an argument to jump directly to the relevant page.

## Integration

The search is typically triggered from the `AppBar` of various pages using:

```dart
showSearch(context: context, delegate: DataSearch());
```

## Maintenance Notes

- When adding new lessons or data lists, they must be registered in the `listConfigs` array within the `_buildResultsWithPage` method in `lib/helpers/search/data_search.dart`.
- The search currently performs a full scan of all content in memory. While efficient for the current data size, indexing may be required if the content grows significantly.
