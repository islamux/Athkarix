# Phase 7: AssmaHussna — 99 Names Screen

> **Goal:** 99 Names of Allah screen with JSON loading, error handling, and search.

**Depends on:** Phase 4 (Base VM), Phase 5 (home navigation)
**Plan file for:** `kotlin_port_007`

---

### Subtask 7.1: ViewModel with loading/error states

- [ ] Create `ui/screens/assma_hussna/AssmaHussnaViewModel.kt`

```kotlin
class AssmaHussnaViewModel(
    private val service: AssmaHussnaService
) : BaseAthkarViewModel() {

    private val _isLoading = MutableStateFlow(true)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _hasError = MutableStateFlow(false)
    val hasError: StateFlow<Boolean> = _hasError.asStateFlow()

    private val _errorMessage = MutableStateFlow("")
    val errorMessage: StateFlow<String> = _errorMessage.asStateFlow()

    // Convert AssmaHussnaItem -> AthkarItem for slider compatibility
    private val _assmaHussnaList = mutableListOf<AssmaHussnaItem>()
    override val dataList: List<AthkarItem>
        get() = _assmaHussnaList.map { AthkarItem(duaText = "${it.name}\n${it.text}", footer = null) }

    override val maxPageCounters: List<Int>
        get() = List(_assmaHussnaList.size) { 1 }

    override val completionMessage = "انهيت قراءة أسماء الله الحسنى"

    fun loadData() {
        _isLoading.value = true
        _hasError.value = false
        viewModelScope.launch(Dispatchers.IO) {
            try {
                val data = service.getAll()
                _assmaHussnaList.clear()
                _assmaHussnaList.addAll(data)
                _isLoading.value = false
            } catch (e: Exception) {
                // Fallback to static data
                _assmaHussnaList.clear()
                _assmaHussnaList.addAll(AssmaHussnaText.staticList)
                _isLoading.value = false
                _hasError.value = true
                _errorMessage.value = e.message ?: "فشل تحميل البيانات"
            }
        }
    }

    fun searchByName(query: String): List<AssmaHussnaItem> = service.searchByName(query)
    fun searchByText(query: String): List<AssmaHussnaItem> = service.searchByText(query)
}
```

### Subtask 7.2: Screen with loading/error states

- [ ] Create `ui/screens/assma_hussna/AssmaHussnaScreen.kt`

```kotlin
@Composable
fun AssmaHussnaScreen(
    viewModel: AssmaHussnaViewModel = remember {
        AppModule.provideAssmaHussnaViewModel(AppModule.provideAssmaHussnaService(LocalContext.current))
    },
    fontViewModel: FontViewModel,
    onBack: () -> Unit
) {
    val isLoading by viewModel.isLoading.collectAsState()
    val hasError by viewModel.hasError.collectAsState()
    val errorMsg by viewModel.errorMessage.collectAsState()

    LaunchedEffect(Unit) { viewModel.loadData() }

    Scaffold(
        topBar = {
            TopAppBar(
                navigationIcon = { IconButton(onClick = onBack) { Icon(Icons.AutoMirrored.Filled.ArrowBack, "رجوع") } },
                title = { Text("أسماء الله الحسنى") },
                actions = { FontControls(fontViewModel) },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = Color.Black, titleContentColor = AppColor.primaryGold)
            )
        }
    ) { padding ->
        Box(Modifier.fillMaxSize().padding(padding)) {
            when {
                isLoading -> CircularProgressIndicator(Modifier.align(Alignment.Center), color = AppColor.primaryGold)
                hasError -> {
                    Column(Modifier.align(Alignment.Center)) {
                        Text(errorMsg, color = AppColor.textSecondary)
                        Spacer(Modifier.height(16.dp))
                        Button(onClick = { viewModel.loadData() }) { Text("إعادة المحاولة") }
                    }
                }
                else -> AthkarTextSlider(viewModel = viewModel, fontViewModel = fontViewModel)
            }
        }
    }
}
```

### Subtask 7.3: Wire in NavGraph

- [ ] Add `AssmaHussnaScreen` to NavGraph
- [ ] Verify JSON loads from assets
- [ ] Verify fallback on missing JSON
- [ ] Verify search methods work

### Subtask 7.4: Add assma-hussna.json asset

- [ ] Copy `assets/json/assma-hussna.json` from Flutter project to `app/src/main/assets/json/assma-hussna.json`
