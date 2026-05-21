# Codebase Audit Fixes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix critical/high-severity bugs found in codebase audit

**Architecture:** Targeted fixes across controllers, routes, and cleanup of dead code. No architecture changes.

**Tech Stack:** Flutter, GetX

---

### Task 1: Fix duplicate `/hamd` route

**Files:**
- Modify: `lib/route.dart:26-28`

- [ ] **Step 1: Remove duplicate route entry**

```dart
  // Before (lines 26-28):
  GetPage(name: AppRoute.hamd, page: (() => const Hamd())),
  GetPage(name: AppRoute.estigfar, page: (() => const Estigfar())),
  GetPage(name: AppRoute.hamd, page: (() => const Hamd())),  // DUPLICATE

  // After:
  GetPage(name: AppRoute.hamd, page: (() => const Hamd())),
  GetPage(name: AppRoute.estigfar, page: (() => const Estigfar())),
```

- [ ] **Step 2: Commit**

```bash
git add lib/route.dart
git commit -m "fix: remove duplicate /hamd route"
```

### Task 2: Fix missing routes — remove dead navigation methods

**Files:**
- Modify: `lib/controller/home_controller.dart:12,23,53-55,87-91`
- Modify: `lib/route.dart`

- [ ] **Step 1: Remove `goToSalatDuha` and `goToCatalogue` from `HomeController` abstract class**

```dart
abstract class HomeController extends GetxController {
  goToAthkarSabah();
  goToAthkarMassa();
  goToTasbih();
  goToEstigfar();
  goToHamd();
  goToSalatAlaRasoulAllah();
  // REMOVE: goToSalatDuha();
  goToDuaMenSunnah();
  goToDuaMenQuran();
  goToAthkarAfterSalat();
  goToAssmaHussna();
  goToAthkarBeforeGoToBed();
  // REMOVE: goToCatalogue();
}
```

- [ ] **Step 2: Remove implementations in `HomeControllerImp`**

Remove:
```dart
  @override
  goToSalatDuha() {
    Get.toNamed(AppRoute.salatDuha);
  }
```

Remove:
```dart
  @override
  goToCatalogue() {
    Get.toNamed(AppRoute.catalogue);
  }
```

- [ ] **Step 3: Commit**

```bash
git add lib/controller/home_controller.dart
git commit -m "fix: remove dead navigation methods for unimplemented routes"
```

### Task 3: Add PageController disposal to all controllers

**Files:**
- Modify: `lib/controller/base_athkar_controller.dart`
- Modify: `lib/controller/athkar_sabah_controller.dart`
- Modify: `lib/controller/athkar_massa_controller.dart`
- Modify: `lib/controller/athkar_after_salat_controller.dart`
- Modify: `lib/controller/athkar_before_go_to_bed_controller.dart`
- Modify: `lib/controller/tasbih_controller.dart`
- Modify: `lib/controller/estigfar_controller.dart`
- Modify: `lib/controller/hamd_controller.dart`
- Modify: `lib/controller/salat_ala_rasoul_controller.dart`
- Modify: `lib/controller/duaa_men_quran_controller.dart`
- Modify: `lib/controller/duaa_men_sunnah_controller.dart`
- Modify: `lib/controller/floating_action_button_controller.dart`

- [ ] **Step 1: Add `onClose()` with pageController dispose to all 13 controllers**

```dart
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
```

For `FloatingButtonControllerImp` (no PageController, just call super):
```dart
  @override
  void onClose() {
    super.onClose();
  }
```

- [ ] **Step 2: Commit**

```bash
git add lib/controller/
git commit -m "fix: add PageController disposal in onClose() to prevent memory leaks"
```

### Task 4: Remove orphaned files

**Files:**
- Delete: `lib/core/data/json/adkar.json`
- Delete: `lib/core/data/model/model_list/assma_hussna_dynamic_list_model.dart`

- [ ] **Step 1: Verify no remaining references**

```bash
rg "adkar\.json|adkarJson" lib/
rg "assmaHussnaDynamicListModel|assma_hussna_dynamic" lib/
```

- [ ] **Step 2: Delete orphaned files**

```bash
rm lib/core/data/json/adkar.json
rm lib/core/data/model/model_list/assma_hussna_dynamic_list_model.dart
```

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "chore: remove orphaned files (unused adkar.json, dead code)"
```

### Task 5: Fix typo in FloatingButtonController method name

**Files:**
- Modify: `lib/controller/floating_action_button_controller.dart:6,16`
- Modify: All files referencing `increamentCouter`

- [ ] **Step 1: Rename `increamentCouter` to `incrementCounter` in controller**

```dart
  // Abstract class
  void incrementCounter();
  void increamentCounterUntil100();
  void reset();

  // Implementation
  @override
  void incrementCounter() {
    counter++;
    update();
  }
```

- [ ] **Step 2: Update all references**

Files to update: `lib/view/pages/tasbih.dart`, `lib/view/pages/estigfar.dart`, `lib/view/pages/hamd.dart`, `lib/view/pages/salat_ala_rasoul.dart`

Replace `increamentCouter()` → `incrementCounter()` in each.

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "fix: rename increamentCouter to incrementCounter"
```
