# Guide: Migrating Athkarix from GetX to BLoC

Hello! This guide will walk you through converting the Athkarix app from using GetX for state management to using the BLoC library. We'll go step-by-step, focusing on one feature at a time to make the process clear and manageable.

### Why Migrate?

While GetX is great for rapid development, BLoC is often preferred in larger projects for its clear separation of concerns and testability. It makes the flow of data in your app very explicit: UI sends an **Event**, the **BLoC** processes it and emits a new **State**, and the UI rebuilds based on that state.

### The Overall Strategy

We will migrate the app feature by feature. Our general workflow for each feature will be:

1.  **Create** the new BLoC files (State, Event, BLoC).
2.  **Provide** the BLoC to the widget tree.
3.  **Replace** the GetX controller and `GetBuilder` with the BLoC and `BlocBuilder` in the UI.
4.  **Repeat** for all features.
5.  **Clean up** GetX dependencies.

---

## Phase 0: Preparation

First, let's add the necessary dependencies to your project.

1.  **Add BLoC to `pubspec.yaml`**

    Open your `pubspec.yaml` file and add the following lines under `dependencies`:

    ```yaml
    # Add these for BLoC state management
    flutter_bloc: ^8.1.3
    equatable: ^2.0.5
    ```

    > **Why `equatable`?** It helps us compare state objects. This prevents BLoC from emitting the same state multiple times, which avoids unnecessary UI rebuilds.

2.  **Install the new packages**

    Run this command in your terminal:

    ```bash
    flutter pub get
    ```

---

## Phase 1: Migrating a Single Feature (Athkar Al-Sabah)

We'll start with the Morning Athkar feature. This is a perfect example because it involves loading data and managing UI state (counters, page index).

### Step 1: Define the State

The "State" is a simple class that holds all the data your UI needs to display. If any of this data changes, we'll emit a new state.

Create a new file: `lib/bloc/athkar_sabah/athkar_sabah_state.dart`

```dart
part of 'athkar_sabah_bloc.dart';

enum AthkarStatus { initial, loading, success, failure }

class AthkarSabahState extends Equatable {
  const AthkarSabahState({
    this.status = AthkarStatus.initial,
    this.athkar = const [],
    this.currentPageIndex = 0,
    this.currentCounter = 0,
  });

  final AthkarStatus status;
  final List<dynamic> athkar;
  final int currentPageIndex;
  final int currentCounter;

  AthkarSabahState copyWith({
    AthkarStatus? status,
    List<dynamic>? athkar,
    int? currentPageIndex,
    int? currentCounter,
  }) {
    return AthkarSabahState(
      status: status ?? this.status,
      athkar: athkar ?? this.athkar,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      currentCounter: currentCounter ?? this.currentCounter,
    );
  }

  @override
  List<Object> get props => [status, athkar, currentPageIndex, currentCounter];
}
```

> **What's happening here?**
> - We define a `status` to track whether we are loading data, have succeeded, or failed.
> - We have properties for the `athkar` list and the UI counters.
> - `copyWith` is a helper method to easily create a new state object based on the old one.
> - `props` comes from `equatable` and lists all the properties that define the state's uniqueness.

### Step 2: Define the Events

Events are actions the user takes or events that happen in the app (like data loading).

Create a new file: `lib/bloc/athkar_sabah/athkar_sabah_event.dart`

```dart
part of 'athkar_sabah_bloc.dart';

abstract class AthkarSabahEvent extends Equatable {
  const AthkarSabahEvent();

  @override
  List<Object> get props => [];
}

// Event to tell the BLoC to load the JSON data
class AthkarSabahLoaded extends AthkarSabahEvent {}

// Event when the user taps the screen to count
class AthkarSabahCounterIncremented extends AthkarSabahEvent {}
```

### Step 3: Create the BLoC

The BLoC listens for events and emits new states. This is where the logic from your old `AthkarSabahControllerImp` will go.

Create a new file: `lib/bloc/athkar_sabah/athkar_sabah_bloc.dart`

```dart
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'athkar_sabah_event.dart';
part 'athkar_sabah_state.dart';

class AthkarSabahBloc extends Bloc<AthkarSabahEvent, AthkarSabahState> {
  AthkarSabahBloc() : super(const AthkarSabahState()) {
    on<AthkarSabahLoaded>(_onAthkarLoaded);
    on<AthkarSabahCounterIncremented>(_onCounterIncremented);
  }

  Future<void> _onAthkarLoaded(AthkarSabahLoaded event, Emitter<AthkarSabahState> emit) async {
    emit(state.copyWith(status: AthkarStatus.loading));
    try {
      final jsonString = await rootBundle.loadString('lib/core/data/json/adhkar_sabah.json');
      final adhkarList = json.decode(jsonString);
      emit(state.copyWith(
        status: AthkarStatus.success,
        athkar: adhkarList,
      ));
    } catch (_) {
      emit(state.copyWith(status: AthkarStatus.failure));
    }
  }

  void _onCounterIncremented(AthkarSabahCounterIncremented event, Emitter<AthkarSabahState> emit) {
    if (state.status != AthkarStatus.success) return;

    final maxCount = state.athkar[state.currentPageIndex]['count'] as int? ?? 1;
    final newCount = state.currentCounter + 1;

    if (newCount >= maxCount) {
      // Move to next page
      if (state.currentPageIndex < state.athkar.length - 1) {
        HapticFeedback.vibrate();
        emit(state.copyWith(
          currentPageIndex: state.currentPageIndex + 1,
          currentCounter: 0, // Reset counter for new page
        ));
      } else {
        // Handle completion (e.g., show snackbar - we'll do this in the UI)
      }
    } else {
      // Just increment counter
      emit(state.copyWith(currentCounter: newCount));
    }
  }
}
```

### Step 4: Provide the BLoC and Refactor the UI

Now we connect our new BLoC to the UI.

Open `lib/view/pages/athkar_sabah_page.dart`.

1.  **Wrap the page with a `BlocProvider`**. The best place to do this is often in your routing setup, but for a single page, we can do it directly.

    *Self-correction: Instead of wrapping the page itself, we'll modify the route in a later step. For now, let's assume the BLoC is provided and focus on the UI changes.*

2.  **Replace `GetBuilder` with `BlocBuilder`** and update the UI to use the new `state` object.

**Before (GetX):**
```dart
// lib/view/pages/athkar_sabah_page.dart (Simplified)
class AthkarSabah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controllerS = Get.find<AthkarSabahControllerImp>();
    return Scaffold(
      // ...
      body: SafeArea(
        child: GestureDetector(
            onTap: () => controllerS.increamentPageController(),
            child: const CustomTextSliderAthkarSabah()),
      ),
      floatingActionButton: GetBuilder<AthkarSabahControllerImp>(
        builder: (context) {
          return CustomFloatingButton(
            onPressed: () => controllerS.increamentPageController(),
            text: Text('${controllerS.currentPageCounter}'),
          );
        },
      ),
    );
  }
}
```

**After (BLoC):**

First, we need a way to provide the BLoC. Let's create a new "view" or "route" page that provides the BLoC and returns the actual UI page.

Create `lib/view/pages/athkar_sabah_route.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athkarix/bloc/athkar_sabah/athkar_sabah_bloc.dart';
import 'package:athkarix/view/pages/athkar_sabah_page.dart';

class AthkarSabahRoute extends StatelessWidget {
  const AthkarSabahRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AthkarSabahBloc()..add(AthkarSabahLoaded()),
      child: const AthkarSabahPage(),
    );
  }
}
```

Now, update `athkar_sabah_page.dart` to `AthkarSabahPage`:

```dart
// lib/view/pages/athkar_sabah_page.dart (Simplified & Renamed)
class AthkarSabahPage extends StatelessWidget {
  const AthkarSabahPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The PageController from the old controller needs to be created here now
    final PageController pageController = PageController();

    return BlocConsumer<AthkarSabahBloc, AthkarSabahState>(
      listener: (context, state) {
        // Use listener for side-effects like navigation or snackbars
        pageController.animateToPage(
          state.currentPageIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      builder: (context, state) {
        if (state.status == AthkarStatus.loading || state.status == AthkarStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == AthkarStatus.failure) {
          return const Center(child: Text('Failed to load Athkar'));
        }
        return Scaffold(
          // ... (AppBar remains mostly the same)
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                // Add an event instead of calling a method
                context.read<AthkarSabahBloc>().add(AthkarSabahCounterIncremented());
              },
              // You will need to adapt CustomTextSliderAthkarSabah to take the athkar list and index from the state
              child: CustomTextSliderAthkarSabah(athkar: state.athkar, pageController: pageController),
            ),
          ),
          floatingActionButton: CustomFloatingButton(
            onPressed: () {
              context.read<AthkarSabahBloc>().add(AthkarSabahCounterIncremented());
            },
            text: Text('${state.currentCounter}'),
          ),
        );
      },
    );
  }
}
```

> **What we did:**
> - Created a new route widget to use `BlocProvider`. This is where we also trigger the initial `AthkarSabahLoaded` event.
> - Used `BlocConsumer` which combines `BlocListener` (for side-effects like page navigation) and `BlocBuilder` (for rebuilding UI).
> - The UI now builds based on the `state` object from the BLoC.
> - User actions now `add` an `Event` to the BLoC instead of calling a controller method.

---

## Phase 2: Migrating Routing & Global State

### Step 1: Replace `GetMaterialApp`

In `main.dart`, replace `GetMaterialApp` with `MaterialApp` and use `MultiBlocProvider` to provide any global BLoCs (like a `FontCubit`).

**Before:**
```dart
// lib/main.dart
return GetMaterialApp(
  initialBinding: MyBinding(),
  home: const Home(),
  getPages: routes,
);
```

**After:**
```dart
// lib/main.dart
// First, create a FontCubit to replace FontControllerImp
// lib/cubit/font_cubit.dart
import 'package:bloc/bloc.dart';
class FontCubit extends Cubit<double> {
  FontCubit() : super(21.0); // Initial font size
  void increase() => emit(state + 2.0);
  void decrease() => emit(state - 2.0);
}

// Then, in main.dart
return MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => FontCubit()),
    // ... add other global BLoCs here
  ],
  child: MaterialApp(
    home: const Home(),
    // We will handle routes next
    routes: appRoutes, // Define appRoutes similar to the old routes list
  ),
);
```

### Step 2: Update Navigation

Replace the GetX `routes` list with a standard `Map<String, WidgetBuilder>`.

- Delete `lib/route.dart`.
- In a new file or in `main.dart`, define your routes:

```dart
final Map<String, WidgetBuilder> appRoutes = {
  AppRoute.home: (context) => const Home(),
  // Use our new BLoC-powered route!
  AppRoute.athkarSabah: (context) => const AthkarSabahRoute(), 
  // ... migrate other routes similarly
};
```

- Replace all `Get.toNamed(AppRoute.home)` calls with `Navigator.pushNamed(context, AppRoute.home)`.

---

## Phase 3: Repeat and Refactor

Now, you just need to repeat **Phase 1** for every other feature:

1.  `AthkarMassa`
2.  `Tasbih` (This one can use a simple `CounterCubit`)
3.  `DuaMenQuran`
4.  ...and so on.

For each one, create the State, Event, and BLoC files, provide the BLoC, and refactor the UI.

---

## Phase 4: Final Cleanup

Once all features have been migrated to BLoC:

1.  Go to `pubspec.yaml` and remove the `get:` dependency.
2.  Run `flutter pub get`.
3.  Delete all the old controller files in the `lib/controller/` directory.
4.  Delete the `lib/binding.dart` file.
5.  Search your project for any remaining `Get.` calls and replace them with their `Navigator` or BLoC equivalents.

Congratulations! You have successfully migrated your application from GetX to BLoC. Your app now has a more structured and predictable state management architecture.
