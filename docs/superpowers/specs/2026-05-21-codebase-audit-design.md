# Full Codebase Audit — Findings & Design

**Date:** 2026-05-21
**Milestone:** `codebase_analysis`
**Status:** Complete (100%)

## Summary

Audited the entire Athkarix Flutter codebase across 7 categories: Controllers & State, Views & Pages, Widgets, Data Layer, Theming & Responsiveness, Routing & Bindings, and Performance & Memory.

**Total issues found: 18** (2 critical, 4 high, 5 medium, 7 low)

---

## 1. Controllers & State

### Issues
- **PageController leak** (13/15 controllers): Only `AssmaHussnaControllerImp` disposes its PageController in `onClose()`. All others leak.
- **Typo**: `increamentCouter` in `floating_action_button_controller.dart:16`
- **Type safety**: `BaseAthkarController.dataList` is `List<dynamic>`, `getShareText()` accesses `.duaText` without null/type check
- **Inconsistency**: `AthkarSabahControllerImp` uses hardcoded 24-item `maxPageCounters`; all others use `List.filled(dataList.length, 1)`
- **Dead code**: `HomeControllerImp.myAthkarList` (RxList) and `pages` (210 strings) unused

## 2. Views & Pages

### Issues
- **Duplicate imports** in 5+ files (`estigfar.dart`, `dua_men_sunnah.dart`, `dua_men_quran.dart`, `assma_hussna_page.dart`, `hamd.dart`, `salat_ala_rasoul.dart`)
- **Missing GestureDetector** on body in 4 pages: `athkar_before_go_to_bed`, `dua_men_quran`, `dua_men_sunnah`, `assma_hussna_page`
- **Redundant font guard**: UI checks `fontSize > 15.0` but controller's min is `21.0`
- **GetBuilder wraps entire FAB** instead of just Text (per AGENTS.md convention)

## 3. Widgets

### Issues
- **Massive duplication**: 11 `CustomTextSlider*` files with ~100 lines each of near-identical Stack → PageView → Obx → Slider code
- **Missing Slider**: `CustomTextSliderAthkarSabah` lacks the Positioned Slider/page indicator all others have
- **Inconsistent page display**: `assma_hussna` uses `currentPageCounter + 1` instead of `currentPageIndex`
- **Force unwrap**: `custom_search_result.dart:30` — `athkar.duaText!` could crash
- **Typo**: filename `custom_botton.dart` (missing 't')

## 4. Data Layer

### Issues
- **Orphaned JSON**: `lib/core/data/json/adkar.json` (264KB) — zero Dart references
- **Orphaned asset**: `assets/json/athkar_sabah.json` — registered in pubspec, never loaded
- **Dead code**: `assma_hussna_dynamic_list_model.dart` — zero imports from other files
- **Mostly dead code**: `assma_hussna_list_model.dart` (504 lines) — only used as JSON-loading fallback
- **Unused dependency**: `shared_preferences` in pubspec but no implementation

## 5. Theming & Responsiveness

### Issues
- **No dark theme**: Only `goldenTheme`; `main.dart` doesn't set `darkTheme:`
- **Premature controller**: `AppTheme` calls `Get.put(FontControllerImp())` at class level before `MyBinding`
- **Wasteful getter**: `goldenTheme` creates new `ThemeData` on every access
- **Basic responsiveness**: `ResponsiveHelper` only 1.5x multiplier; no `LayoutBuilder`, no adaptive widgets

## 6. Routing & Bindings

### Issues
- **Duplicate route**: `AppRoute.hamd` registered twice at `route.dart:26` and `:28`
- **3 missing routes**: `salatDuha`, `catalogue`, `aboutUs` — defined in constants but no `GetPage`; navigation crashes at runtime

## 7. Performance & Memory

### Issues
- **PageController leak** (see #1)
- **Full FAB rebuild** on every tap
- **Eager controller init**: all 14 controllers at app start
- **Unused state**: `myAthkarList` + 210-string `pages` list in HomeController
- **Theme getter**: creates new `TextStyle` objects per access

---

## Recommendations

### Immediate Fixes (Critical/High)
1. Remove duplicate `/hamd` route
2. Add missing routes (`salatDuha`, `catalogue`, `aboutUs`) or remove their navigation methods
3. Add `onClose()` with `pageController.dispose()` to all controllers
4. Add basic `darkTheme` to `GetMaterialApp`

### Short-term (Medium)
1. Refactor 11 text sliders into 1 parameterized widget
2. Move `GetBuilder` down to wrap only Text in FAB
3. Fix missing GestureDetector on 4 pages
4. Remove orphaned JSON files

### Cleanup (Low)
1. Remove dead code (`assma_hussna_dynamic_list_model.dart`, unused text lists)
2. Fix typos (`Couter` → `Counter`, `botton` → `button`)
3. Remove duplicate imports
4. Remove unused `shared_preferences` dependency
