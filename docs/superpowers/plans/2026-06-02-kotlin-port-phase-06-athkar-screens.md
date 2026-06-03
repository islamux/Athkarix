# Phase 6: 11 Athkar Screens

> **Goal:** All 11 athkar/dua screens with TopAppBar controls and AthkarTextSlider.

**Depends on:** Phase 4 (Base VM + components), Phase 5 (home navigation)
**Plan file for:** `kotlin_port_006`

---

### Subtask 6.1: Concrete ViewModels (11 total)

Each ViewModel extends `BaseAthkarViewModel` with hardcoded `dataList`, `maxPageCounters`, and `completionMessage`.

**Pattern (use for all):**
```kotlin
class AthkarSabahViewModel : BaseAthkarViewModel() {
    override val dataList = AthkarRepository.sabahList
    override val maxPageCounters = listOf(1, 1, 3, 1, 7, 1, 1, 7, 1, 1, 1, 1, 100, 10, 100, 3, 1, 100, 10, 1, 1, 1, 1, 1)
    override val completionMessage = "انهيت أذكار الصباح !"
}
```

| ViewModel | dataList | maxPageCounters | completionMessage |
|---|---|---|---|
| `AthkarSabahViewModel` | `sabahList` | [1,1,3,1,7,1,1,7,1,1,1,1,100,10,100,3,1,100,10,1,1,1,1,1] | "انهيت أذكار الصباح !" |
| `AthkarMassaViewModel` | `massaList` | `List.filled(22, 1)` | "انهيت قراءة أذكار المساء !" |
| `AthkarAfterSalatViewModel` | `afterSalatList` | `List.filled(11, 1)` | "انهيت قراءة أذكار مابعد الصلاة" |
| `AthkarBeforeBedViewModel` | `beforeBedList` | `List.filled(9, 1)` | "انهيت قراءة أذكار النوم !" |
| `TasbihViewModel` | `tasbihList` | `List.filled(29, 1)` | "انهيت قراءة رسائل التسبيح" |
| `EstigfarViewModel` | `estigfarList` | `List.filled(20, 1)` | "انهيت قراءة رسائل الاستغفار" |
| `HamdViewModel` | `hamdList` | `List.filled(56, 1)` | "انهيت قراءة رسائل الحمد" |
| `SalatAlaRasoulViewModel` | `salatAlaRasoulList` | `List.filled(40, 1)` | "انهيت الصلاة على الرسول" |
| `DuaMenQuranViewModel` | `duaMenQuranList` | `List.filled(12, 1)` | "انهيت قراءة أدعية من القرآن" |
| `DuaMenSunnahViewModel` | `duaMenSunnahList` | `List.filled(45, 1)` | "انهيت قراءة أدعية من السنة" |

Files: `ui/screens/athkar/{sabah,massa,after_salat,before_bed,tasbih,estigfar,hamd,salat_ala_rasoul,dua_men_quran,dua_men_sunnah}/{name}ViewModel.kt`

### Subtask 6.2: AthkarScreen composable — base pattern

Create a reusable athkar screen layout. All 11 screens follow this pattern:
```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AthkarScreen(
    viewModel: BaseAthkarViewModel,
    fontViewModel: FontViewModel,
    onBack: () -> Unit,
    onShare: (String) -> Unit,
    showFloatingCounter: Boolean = false,
    floatingCounterVM: FloatingCounterViewModel? = null,
    content: @Composable ColumnScope.() -> Unit = {}
) {
    val pageCounter by viewModel.currentPageCounter.collectAsState()

    LaunchedEffect(Unit) {
        viewModel.eventFlow.collect { event ->
            when (event) {
                is ViewEvent.ShowCompletion -> {
                    // Show snackbar with event.message
                }
                else -> {}
            }
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                navigationIcon = { IconButton(onClick = onBack) { Icon(Icons.AutoMirrored.Filled.ArrowBack, "رجوع", tint = AppColor.primaryGold) } },
                title = {},
                actions = {
                    // Share button
                    IconButton(onClick = { onShare(viewModel.getShareText(viewModel.currentPageIndex.value)) }) {
                        Icon(Icons.Default.Share, "مشاركة", tint = AppColor.primaryGold)
                    }
                    // Font controls
                    FontControls(fontViewModel)
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = Color.Black, titleContentColor = AppColor.primaryGold)
            )
        },
        floatingActionButton = {
            if (showFloatingCounter && floatingCounterVM != null) {
                val count by floatingCounterVM.counter.collectAsState()
                FloatingCounterFab(counter = count, onClick = { floatingCounterVM.increment() })
            }
        }
    ) { padding ->
        Box(Modifier.fillMaxSize().padding(padding)) {
            AthkarTextSlider(viewModel = viewModel, fontViewModel = fontViewModel)
        }
    }
}
```

### Subtask 6.3: Individual screen files (11 files)

Each screen file wires its specific ViewModel. Example:

**AthkarSabahScreen.kt:**
```kotlin
@Composable
fun AthkarSabahScreen(
    viewModel: AthkarSabahViewModel = remember { AppModule.provideAthkarSabahViewModel() },
    fontViewModel: FontViewModel,
    onBack: () -> Unit
) {
    AthkarScreen(
        viewModel = viewModel,
        fontViewModel = fontViewModel,
        onBack = onBack,
        onShare = { /* ShareUtil.shareText(it) */ }
    )
}
```

Same pattern for: `AthkarMassaScreen`, `AthkarAfterSalatScreen`, `AthkarBeforeBedScreen`.

For **TasbihScreen**, **EstigfarScreen**, **HamdScreen**, **SalatAlaRasoulScreen** — add `showFloatingCounter = true`:
```kotlin
@Composable
fun TasbihScreen(
    viewModel: TasbihViewModel = remember { AppModule.provideTasbihViewModel() },
    fontViewModel: FontViewModel,
    floatingCounterVM: FloatingCounterViewModel = remember { AppModule.provideFloatingCounterViewModel() },
    onBack: () -> Unit
) {
    AthkarScreen(
        viewModel = viewModel,
        fontViewModel = fontViewModel,
        floatingCounterVM = floatingCounterVM,
        showFloatingCounter = true,
        onBack = onBack,
        onShare = { /* ShareUtil.shareText(it) */ }
    )
}
```

### Subtask 6.4: Wire all screens in NavGraph

- [ ] Replace all placeholder routes in `NavGraph.kt` with real screen composables
- [ ] Verify each screen:
  - Shows correct athkar text
  - Tap advances counter / auto-advances page
  - Back button works
  - Share button opens share sheet
  - Font + / - buttons change text size
  - Completion snackbar shows on last page

### Subtask 6.5: FAB counter reset button (Tasbih/Estigfar/Hamd/Salat)

- [ ] Add a reset button next to the FAB for the 4 tasbeeh screens
- [ ] Can use a second small FAB or a long-press handler

### Subtask 6.6: Haptic feedback on AthkarSabah

- [ ] Override `incrementPageController()` in `AthkarSabahViewModel` to add haptic feedback (mirrors Flutter's `HapticFeedback.lightImpact()`)

```kotlin
// In AthkarSabahViewModel
override fun incrementPageController() {
    // Call super first
    // Then trigger haptic via a StateFlow event
}
```
