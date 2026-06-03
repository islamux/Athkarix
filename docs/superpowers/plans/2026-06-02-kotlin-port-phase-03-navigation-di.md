# Phase 3: Navigation + DI Wiring

> **Goal:** Route constants, navigation graph, and manual DI module.

**Depends on:** Phase 1 (project structure exists)
**Plan file for:** `kotlin_port_003`

---

### Subtask 3.1: Route constants

- [ ] Create `navigation/Routes.kt` with 13 route string constants

```kotlin
object Routes {
    const val HOME = "home"
    const val ATHKAR_SABAH = "athkarSabah"
    const val ATHKAR_MASSA = "athkarMassa"
    const val ESTIGFAR = "estigfar"
    const val TASBIH = "tasbih"
    const val HAMD = "hamd"
    const val SALAT_ALA_RASOUL = "salatAlaRasoulAllah"
    const val DUA_MEN_QURAN = "duaMenQuran"
    const val DUA_MEN_SUNNAH = "duaMenSunnah"
    const val ATHKAR_AFTER_SALAT = "athkarAfterSalat"
    const val ASSMA_HUSSNA = "assmaHussna"
    const val ATHKAR_BEFORE_BED = "athkarBeforeGoToBed"
    const val NOTIFICATION_SETTINGS = "notificationSettings"
    const val SEARCH = "search"
    const val SEARCH_RESULT = "searchResult/{text}"
}
```

### Subtask 3.2: DI module

- [ ] Create `di/AppModule.kt` with factory functions for all ViewModels

```kotlin
object AppModule {
    private var assmaHussnaService: AssmaHussnaService? = null

    fun provideAssmaHussnaService(context: Context): AssmaHussnaService {
        if (assmaHussnaService == null) {
            assmaHussnaService = AssmaHussnaService(context)
        }
        return assmaHussnaService!!
    }

    fun provideSharedPrefsManager(context: Context): SharedPrefsManager {
        return SharedPrefsManager(context)
    }

    // ViewModel factories — called from Screens
    fun provideHomeViewModel(): HomeViewModel = HomeViewModel()
    fun provideAthkarSabahViewModel(): AthkarSabahViewModel = AthkarSabahViewModel()
    fun provideAthkarMassaViewModel(): AthkarMassaViewModel = AthkarMassaViewModel()
    fun provideAthkarAfterSalatViewModel(): AthkarAfterSalatViewModel = AthkarAfterSalatViewModel()
    fun provideAthkarBeforeBedViewModel(): AthkarBeforeBedViewModel = AthkarBeforeBedViewModel()
    fun provideTasbihViewModel(): TasbihViewModel = TasbihViewModel()
    fun provideEstigfarViewModel(): EstigfarViewModel = EstigfarViewModel()
    fun provideHamdViewModel(): HamdViewModel = HamdViewModel()
    fun provideSalatAlaRasoulViewModel(): SalatAlaRasoulViewModel = SalatAlaRasoulViewModel()
    fun provideDuaMenQuranViewModel(): DuaMenQuranViewModel = DuaMenQuranViewModel()
    fun provideDuaMenSunnahViewModel(): DuaMenSunnahViewModel = DuaMenSunnahViewModel()
    fun provideAssmaHussnaViewModel(service: AssmaHussnaService): AssmaHussnaViewModel = AssmaHussnaViewModel(service)
    fun provideNotificationSettingsViewModel(prefs: SharedPrefsManager): NotificationSettingsViewModel = NotificationSettingsViewModel(prefs)
    fun provideFontViewModel(): FontViewModel = FontViewModel()
    fun provideFloatingCounterViewModel(): FloatingCounterViewModel = FloatingCounterViewModel()
}
```

### Subtask 3.3: NavGraph with placeholders

- [ ] Create `navigation/NavGraph.kt` with all 13 routes
- [ ] Each route gets a placeholder `Text()` composable
- [ ] Wire routes to real screens as they're built

```kotlin
@Composable
fun AthkarixNavGraph(navController: NavHostController) {
    val fontVM = remember { AppModule.provideFontViewModel() }
    val floatingCounterVM = remember { AppModule.provideFloatingCounterViewModel() }

    NavHost(navController, startDestination = Routes.HOME) {
        composable(Routes.HOME) {
            HomeScreen(
                onNavigate = { route -> navController.navigate(route) },
                onSearch = { navController.navigate(Routes.SEARCH) }
            )
        }
        composable(Routes.ATHKAR_SABAH) {
            AthkarSabahScreen(
                viewModel = remember { AppModule.provideAthkarSabahViewModel() },
                fontViewModel = fontVM,
                onBack = { navController.popBackStack() }
            )
        }
        // ... 12 more routes
    }
}
```

### Subtask 3.4: Verify navigation

- [ ] Run the app
- [ ] Confirm all 13 placeholder screens navigate correctly
- [ ] Confirm back button returns to home
