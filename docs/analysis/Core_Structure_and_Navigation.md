# Documentation: Core Structure & Navigation

This document outlines the foundational structure of the Athkarix application, including the main entry point, routing, and the home screen layout.

## 1. Application Entry Point (`main.dart`)

The application's entry point is the `main()` function in `lib/main.dart`.

### Key Responsibilities:
- **Initialization:** It calls `runApp()` to start the Flutter application with the root widget, `Athkari`.
- **Root Widget (`Athkari`):** This `StatelessWidget` is the core of the application.
  - It configures the app as a `GetMaterialApp`, which integrates the GetX package for state management and routing.
  - It sets the application's title to "Athkari".
  - It defines the default theme (`AppTheme.goldenTheme`).
  - It sets the initial screen to `Home()`.
  - It registers all the application's routes (`getPages: routes`).
  - It sets up initial bindings for controllers using `initialBinding: MyBinding()`.

```dart
// lib/main.dart

void main() {
  runApp(const Athkari());
}

class Athkari extends StatelessWidget {
  const Athkari({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Athkari',
      theme: AppTheme.goldenTheme,
      initialBinding: MyBinding(),
      home: const Home(),
      // Routes
      getPages: routes,
    );
  }
}
```

## 2. Routing (`route.dart`)

The application uses the **GetX** package for named routing, which is configured in `lib/route.dart`.

### Key Responsibilities:
- **Route Definitions:** It contains a `List<GetPage>` named `routes`.
- **Page Mapping:** Each `GetPage` object maps a route name (e.g., `AppRoute.athkarSabah`) to a specific page widget (e.g., `AthkarSabah()`). This provides a centralized and easy-to-manage routing system.
- **Navigation:** To navigate to a page, the code calls `Get.toNamed(AppRoute.routeName)`.

```dart
// lib/route.dart

List<GetPage<dynamic>> routes = [
  GetPage(name: AppRoute.athkarSabah, page: (() => const AthkarSabah())),
  GetPage(name: AppRoute.athkarMassa, page: () => const AthkarMassa()),
  GetPage(name: AppRoute.athkarAfterSalat, page: (() => const AthkarAfterSalat())),
  // ... other routes
];
```

## 3. Home Screen (`lib/view/pages/home.dart`)

The `Home` widget is the main screen users see when they open the app. It serves as the central hub for navigating to all other features.

### UI Components:
- **AppBar:** A top app bar with the title "أذكــــاري", a search icon, and a share button.
- **Drawer:** A slide-out navigation drawer (`CustomDrawerListView`) for accessing settings or other information.
- **Body:**
  - A background image provides a pleasant aesthetic.
  - A `ListView` contains a series of `CustomButton` widgets.
  - Each button is clearly labeled (e.g., "أذكار الصبـــاح", "التسبيح") and navigates to a different feature of the app.

### Logic and State Management:
- **Controller:** It uses `HomeControllerImp` (found via `Get.find()`) to handle the logic for button presses.
- **Navigation:** Each button's `onPressed` callback calls a method in the controller (e.g., `controllerE.goToAthkarSabah()`), which then uses GetX to navigate to the corresponding route.
- **Exit Confirmation:** It uses a `PopScope` widget to intercept the back button press and show an exit confirmation dialog (`alertExitApp()`), preventing accidental app closure.

```dart
// lib/view/pages/home.dart

// ... (build method)
SizedBox(
  height: 400,
  child: ListView(
    // ...
    children: [
      CustomButton(
        customText: "أذكار الصبـــاح   ",
        onPressed: () => controllerE.goToAthkarSabah(),
        icon: const Icon(Icons.menu_book),
      ),
      // ... other buttons
    ],
  ),
),
// ...
```
