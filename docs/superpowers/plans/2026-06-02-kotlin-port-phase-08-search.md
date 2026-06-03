# Phase 8: Search System

> **Goal:** Search across all athkar with diacritic normalization and result display.

**Depends on:** Phase 2 (data layer), Phase 5 (home search icon)
**Plan file for:** `kotlin_port_008`

---

### Subtask 8.1: SearchViewModel

- [ ] Create `ui/screens/search/SearchViewModel.kt`

```kotlin
class SearchViewModel : ViewModel() {
    private val _query = MutableStateFlow("")
    val query: StateFlow<String> = _query.asStateFlow()

    private val _results = MutableStateFlow<List<SearchResult>>(emptyList())
    val results: StateFlow<List<SearchResult>> = _results.asStateFlow()

    data class SearchResult(
        val category: String,  // Arabic category name
        val categoryKey: String, // Routes constant
        val item: AthkarItem,
        val index: Int
    )

    fun search(q: String) {
        _query.value = q
        if (q.isBlank()) {
            _results.value = emptyList()
            return
        }
        val normalized = DiacriticUtil.remove(q).lowercase()
        _results.value = AthkarRepository.allLists.flatMap { (key, list) ->
            list.mapIndexedNotNull { index, item ->
                val text = DiacriticUtil.remove(item.duaText ?: "").lowercase()
                if (text.contains(normalized)) {
                    SearchResult(
                        category = categoryName(key),
                        categoryKey = categoryRoute(key),
                        item = item,
                        index = index
                    )
                } else null
            }
        }
    }

    private fun categoryName(key: String): String = when (key) {
        "sabah" -> "أذكار الصباح"
        "massa" -> "أذكار المساء"
        // ...
        else -> key
    }

    private fun categoryRoute(key: String): String = when (key) {
        "sabah" -> Routes.ATHKAR_SABAH
        "massa" -> Routes.ATHKAR_MASSA
        // ...
        else -> Routes.HOME
    }
}
```

### Subtask 8.2: SearchScreen

- [ ] Create `ui/screens/search/SearchScreen.kt`

```kotlin
@Composable
fun SearchScreen(
    viewModel: SearchViewModel = remember { SearchViewModel() },
    onResultClick: (SearchViewModel.SearchResult) -> Unit,
    onBack: () -> Unit
) {
    val query by viewModel.query.collectAsState()
    val results by viewModel.results.collectAsState()

    Column(Modifier.fillMaxSize().background(Color.Black)) {
        // Search bar
        TextField(
            value = query,
            onValueChange = { viewModel.search(it) },
            placeholder = { Text("بحث في الأذكار...", color = AppColor.textSecondary) },
            colors = TextFieldDefaults.colors(
                focusedTextColor = AppColor.primaryGold,
                unfocusedTextColor = AppColor.primaryGold,
                focusedContainerColor = AppColor.surface,
                unfocusedContainerColor = AppColor.surface,
                cursorColor = AppColor.primaryGold
            ),
            leadingIcon = { Icon(Icons.Default.Search, null, tint = AppColor.primaryGold) },
            trailingIcon = {
                if (query.isNotEmpty()) {
                    IconButton(onClick = { viewModel.search("") }) {
                        Icon(Icons.Default.Close, "مسح", tint = AppColor.primaryGold)
                    }
                }
            },
            modifier = Modifier.fillMaxWidth().padding(8.dp)
        )
        // Results
        LazyColumn {
            items(results) { result ->
                ListItem(
                    headlineContent = {
                        Text(
                            result.item.duaText ?: "",
                            maxLines = 2,
                            overflow = TextOverflow.Ellipsis,
                            color = AppColor.primaryGold
                        )
                    },
                    supportingContent = { Text(result.category, color = AppColor.textSecondary) },
                    modifier = Modifier.clickable { onResultClick(result) }
                )
            }
        }
        if (query.isNotEmpty() && results.isEmpty()) {
            Text("لا توجد نتائج", color = AppColor.textSecondary, modifier = Modifier.padding(16.dp))
        }
    }
}
```

### Subtask 8.3: SearchResultScreen

- [ ] Create `ui/screens/search/SearchResultScreen.kt`
- [ ] Shows full dua text + footer when tapping a search result

```kotlin
@Composable
fun SearchResultScreen(
    item: AthkarItem,
    onBack: () -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                navigationIcon = { IconButton(onClick = onBack) { Icon(Icons.AutoMirrored.Filled.ArrowBack, "رجوع") } },
                title = {},
                colors = TopAppBarDefaults.topAppBarColors(containerColor = Color.Black, titleContentColor = AppColor.primaryGold)
            )
        },
        colors = ScaffoldColors(containerColor = Color.Black)
    ) { padding ->
        Box(Modifier.fillMaxSize().padding(padding).verticalScroll(rememberScrollState()).padding(24.dp)) {
            Column(verticalArrangement = Arrangement.Center) {
                Text(item.duaText ?: "", color = AppColor.primaryGold, fontFamily = FontFamily.Amiri, textAlign = TextAlign.Center)
                if (!item.footer.isNullOrBlank()) {
                    Spacer(Modifier.height(16.dp))
                    Text(item.footer, color = AppColor.footer)
                }
            }
        }
    }
}
```

### Subtask 8.4: Wire search in NavGraph

- [ ] Add search route: `composable(Routes.SEARCH) { SearchScreen(...) }`
- [ ] Add search result route: `composable("searchResult/{text}") { ... }`
- [ ] Wire search icon in Home TopAppBar
- [ ] Verify: search finds results, diacritic removal works, tapping opens full text
