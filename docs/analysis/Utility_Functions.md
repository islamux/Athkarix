# Documentation: Utility Functions

This document outlines the helper and utility functions located in the `lib/function/` directory. These functions encapsulate reusable logic that is used across multiple parts of the application.

---

### 1. `alert_exit_app.dart`

- **Function:** `Future<bool> alertExitApp()`
- **Purpose:** To prevent users from accidentally closing the app.
- **Implementation:**
  - This function is triggered by the `PopScope` widget on the `Home` page.
  - It uses `Get.defaultDialog()` from the GetX package to display a confirmation dialog.
  - The dialog asks the user, "هل أنهيت أذكارك ؟" (Have you finished your remembrances?).
  - It presents two `CustomButton` widgets:
    - **"نعم" (Yes):** Calls `exit(0)` to terminate the application.
    - **"لا" (No):** Calls `Get.back()` to close the dialog and return to the app.
- **Usage:** It provides a user-friendly way to confirm the exit action, reducing accidental closures.

---

### 2. `custom_share_content.dart`

- **Function:** `String customShareContent(var controller)`
- **Purpose:** To share the text of the currently displayed dhikr or dua.
- **Implementation:**
  - It accepts a generic `controller` object as a parameter. This controller is expected to be an instance of a class that extends `BaseAthkarController`.
  - It retrieves the current page index from `controller.currentPageIndex`.
  - It calls `controller.getShareText(index)` to get the specific text for that page.
  - It uses the `share_plus` package (`Share.share(shareText)`) to open the native OS share sheet, allowing the user to share the text with other apps.
- **Usage:** This function provides a generic and reusable way to implement the share feature across all content pages without duplicating code. By passing the specific page controller, it can adapt to any content type.

---

### 3. `call_us_via_whatsup.dart`

- **Function:** `void callUsViaWhatsUp()`
- **Purpose:** To allow users to contact the developer via WhatsApp.
- **Implementation:**
  - It uses the `url_launcher` package to attempt to open a WhatsApp URL (`whatsapp://send?phone=...`).
  - It includes a hard-coded phone number.
  - **Error Handling:** It wraps the `launchUrl` call in a `try...on PlatformException`. If it catches an exception with the code `ACTIVITY_NOT_FOUND`, it means WhatsApp is not installed.
  - **Fallback:** In case of an error, it opens the Google Play Store page for WhatsApp, prompting the user to install it.
- **Usage:** This provides a direct line of communication for user feedback or support.

---

### 4. `remove_search_diacritics.dart`

- **Function:** `String removeSearchDiacritics(String text)`
- **Purpose:** To prepare Arabic text for searching by removing diacritics (tashkeel).
- **Implementation:**
  - It takes a string as input.
  - It uses a regular expression (`RegExp(r'[^\u0621-\u064A\s]')`) to match any character that is **not** an Arabic letter (from `ء` to `ي`) or a whitespace character.
  - It replaces all matched characters (the diacritics) with an empty string.
- **Usage:** This function is crucial for the search functionality. When a user types a search query, they typically do not include diacritics. By stripping the diacritics from both the search query and the content being searched, the app can perform a more reliable and user-friendly search.
