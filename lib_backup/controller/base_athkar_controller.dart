import 'package:athkarix/core/data/static/routes_constant.dart';
import 'package:athkarix/core/data/static/theme/app_color_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseAthkarController extends GetxController {
  // --- Abstract Properties (Must be implemented by subclasses) ---

  // The PageController specific to the page view
  PageController get pageController;

  // The list containing the maximum counter for each page/item
  List<int> get maxPageCounters;

  // The list of data models (e.g., AssmaHussnaModel, AthkarSabahModel)
  List<dynamic> get dataList; // Using dynamic for flexibility

  // The message to show in the Snackbar when completed
  String get completionMessage;

  // --- Common Properties ---
  int currentPageIndex = 0;
  int currentPageCounter =
      0; // Initial counter value might vary, subclasses can override resetCounter if needed

  // --- Common Methods ---
  void goToHome() {
    Get.toNamed(AppRoute.home);
  }

  // Reset counter - subclasses can override if the initial value isn't 0
  void resetCounter() {
    currentPageCounter = 0;
    update();
  }

  // Handle page change in the PageView
  void onPageChanged(int index) {
    currentPageIndex = index;
    resetCounter(); // Reset counter when page changes
    update(); // Update UI if needed
  }

  // Get text for sharing - uses the abstract dataList
  String getShareText(int index) {
    // Assuming the data models have a 'duaText' property or similar
    // Might need adjustment based on actual model structure
    if (index >= 0 && index < dataList.length) {
      // Basic check, might need more robust error handling
      return dataList[index].duaText ?? '';
    }
    return '';
  }

  // Navigate the PageView to a specific page index
  void goToPage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300), // Adjusted duration
      curve: Curves.easeInOut,
    );
  }

  // Increment counter and potentially navigate to the next page
  void increamentPageController() {
    currentPageCounter++;

    if (currentPageCounter >= maxPageCounters[currentPageIndex]) {
      currentPageIndex++;

      if (currentPageIndex < maxPageCounters.length) {
        currentPageCounter = 0; // Reset counter for the new page

        // Consider adding HapticFeedback here if desired universally
        // HapticFeedback.vibrate();

        pageController.nextPage(
            duration: const Duration(milliseconds: 500), // Adjusted duration
            curve: Curves.easeInOut);
      } else {
        // Reached the end
        Get.snackbar(
          'الحمدلله', // Title
          completionMessage, // Use the abstract completion message
          colorText: AppColor.black,
          backgroundColor: AppColor.transparent, // Consider a subtle background
          duration: const Duration(seconds: 4), // Adjusted duration
          snackPosition: SnackPosition.BOTTOM,
        );
        // Optional: Navigate back home or reset?
        // goToHome();
      }
    }
    update(); // Update UI to reflect counter change
  }
}
