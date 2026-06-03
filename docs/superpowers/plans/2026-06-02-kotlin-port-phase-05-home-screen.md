# Phase 5: Home Screen

> **Goal:** Home page with navigation buttons, drawer, search entry, and exit dialog.

**Depends on:** Phase 3 (navigation), Phase 4 (components)
**Plan file for:** `kotlin_port_005`

---

### Subtask 5.1: HomeViewModel

- [ ] Create `ui/screens/home/HomeViewModel.kt`

```kotlin
class HomeViewModel : ViewModel() {
    private val _eventFlow = MutableSharedFlow<ViewEvent>()
    val eventFlow: SharedFlow<ViewEvent> = _eventFlow.asSharedFlow()

    fun goToSabah() = emit(Routes.ATHKAR_SABAH)
    fun goToMassa() = emit(Routes.ATHKAR_MASSA)
    fun goToAfterSalat() = emit(Routes.ATHKAR_AFTER_SALAT)
    fun goToBeforeBed() = emit(Routes.ATHKAR_BEFORE_BED)
    fun goToTasbih() = emit(Routes.TASBIH)
    fun goToEstigfar() = emit(Routes.ESTIGFAR)
    fun goToHamd() = emit(Routes.HAMD)
    fun goToSalatAlaRasoul() = emit(Routes.SALAT_ALA_RASOUL)
    fun goToDuaMenQuran() = emit(Routes.DUA_MEN_QURAN)
    fun goToDuaMenSunnah() = emit(Routes.DUA_MEN_SUNNAH)
    fun goToAssmaHussna() = emit(Routes.ASSMA_HUSSNA)
    fun goToNotificationSettings() = emit(Routes.NOTIFICATION_SETTINGS)

    private fun emit(route: String) {
        viewModelScope.launch { _eventFlow.emit(ViewEvent.NavigateTo(route)) }
    }
}
```

### Subtask 5.2: HomeScreen layout

- [ ] Create `ui/screens/home/HomeScreen.kt`
- [ ] Scaffold + TopAppBar (search action) + background image + scrollable button list

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    onNavigate: (String) -> Unit = {},
    onSearch: () -> Unit = {}
) {
    val viewModel = remember { AppModule.provideHomeViewModel() }
    val isTablet = FontScaleUtil.isTablet()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Athkarix", fontFamily = FontFamily.Cairo) },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Color.Black,
                    titleContentColor = AppColor.primaryGold
                ),
                actions = {
                    IconButton(onClick = onSearch) {
                        Icon(Icons.Default.Search, "بحث", tint = AppColor.primaryGold)
                    }
                }
            )
        },
        drawerContent = {
            CustomDrawer(
                onNotificationSettings = { onNavigate(Routes.NOTIFICATION_SETTINGS) },
                onWhatsApp = { /* WhatsAppUtil.openWhatsApp(context) */ },
                onShare = { /* ShareUtil.shareApp(context) */ }
            )
        }
    ) { padding ->
        Box(Modifier.fillMaxSize().padding(padding)) {
            // Background
            Image(
                painter = painterResource(R.drawable.bg_home),
                contentDescription = null,
                contentScale = ContentScale.Crop,
                modifier = Modifier.fillMaxSize()
            )
            // Scrollable buttons
            LazyColumn(
                modifier = Modifier.fillMaxSize().padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                item { Text("اسحب للأعلى للمزيد", color = AppColor.textSecondary, ...) }
                item { CustomButton(Icons.Default.WbSunny, "أذكار الصباح") { onNavigate(Routes.ATHKAR_SABAH) } }
                item { CustomButton(Icons.Default.NightsStay, "أذكار المساء") { onNavigate(Routes.ATHKAR_MASSA) } }
                item { CustomButton(Icons.Default.TempleBuddhist, "أذكار بعد الصلاة") { onNavigate(Routes.ATHKAR_AFTER_SALAT) } }
                item { CustomButton(Icons.Default.Bed, "أذكار النوم") { onNavigate(Routes.ATHKAR_BEFORE_BED) } }
                item { CustomButton(Icons.Default.Repeat, "التسبيح") { onNavigate(Routes.TASBIH) } }
                item { CustomButton(Icons.Default.VolumeUp, "الاستغفار") { onNavigate(Routes.ESTIGFAR) } }
                item { CustomButton(Icons.Default.Favorite, "الحمد") { onNavigate(Routes.HAMD) } }
                item { CustomButton(Icons.Default.AutoAwesome, "الصلاة على الرسول") { onNavigate(Routes.SALAT_ALA_RASOUL) } }
                item { CustomButton(Icons.Default.MenuBook, "أدعية من القرآن") { onNavigate(Routes.DUA_MEN_QURAN) } }
                item { CustomButton(Icons.Default.Book, "أدعية من السنة") { onNavigate(Routes.DUA_MEN_SUNNAH) } }
                item { CustomButton(Icons.Default.Star, "أسماء الله الحسنى") { onNavigate(Routes.ASSMA_HUSSNA) } }
            }
        }
    }
}
```

### Subtask 5.3: Exit confirmation dialog

- [ ] Create `ui/components/AlertExitApp.kt`
- [ ] "هل أنهيت أذكارك؟" dialog on back press from Home

```kotlin
@Composable
fun AlertExitApp(onExit: () -> Unit, onDismiss: () -> Unit) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("تأكيد الخروج") },
        text = { Text("هل أنهيت أذكارك؟") },
        confirmButton = { TextButton(onClick = onExit) { Text("نعم") } },
        dismissButton = { TextButton(onClick = onDismiss) { Text("لا") } }
    )
}
```

Wire in NavGraph:
```kotlin
composable(Routes.HOME) {
    var showExitDialog by remember { mutableStateOf(false) }
    BackHandler { showExitDialog = true }
    if (showExitDialog) {
        AlertExitApp(
            onExit = { /* finish activity */ },
            onDismiss = { showExitDialog = false }
        )
    }
    HomeScreen(...)
}
```

### Subtask 5.4: Wire to NavGraph

- [ ] Replace `HomeScreen` placeholder in NavGraph with real implementation
- [ ] Verify all navigation buttons work
- [ ] Verify drawer opens
- [ ] Verify back press shows exit dialog
