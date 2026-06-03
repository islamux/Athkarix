# Phase 4: Base ViewModel + Shared Components

> **Goal:** Core architecture — base ViewModel, font/counter controllers, reusable UI widgets.

**Depends on:** Phase 2 (data models), Phase 3 (DI)
**Plan file for:** `kotlin_port_004`

---

### Subtask 4.1: BaseAthkarViewModel

- [ ] Create `ui/screens/athkar/base/BaseAthkarViewModel.kt`
- [ ] Abstract class with paging logic, counter, completion events

```kotlin
sealed class ViewEvent {
    data class NavigateTo(val route: String) : ViewEvent()
    data class ShowCompletion(val message: String) : ViewEvent()
    object NavigateBack : ViewEvent()
}

abstract class BaseAthkarViewModel : ViewModel() {
    protected val _currentPageIndex = MutableStateFlow(0)
    val currentPageIndex: StateFlow<Int> = _currentPageIndex.asStateFlow()

    protected val _currentPageCounter = MutableStateFlow(0)
    val currentPageCounter: StateFlow<Int> = _currentPageCounter.asStateFlow()

    protected val _eventFlow = MutableSharedFlow<ViewEvent>()
    val eventFlow: SharedFlow<ViewEvent> = _eventFlow.asSharedFlow()

    abstract val dataList: List<AthkarItem>
    abstract val maxPageCounters: List<Int>
    abstract val completionMessage: String

    val pagerState = PagerState(pageCount = { dataList.size })

    fun incrementPageController() {
        val max = maxPageCounters.getOrElse(_currentPageIndex.value) { 1 }
        val newCount = _currentPageCounter.value + 1
        if (newCount >= max) {
            _currentPageCounter.value = 0
            val nextIndex = _currentPageIndex.value + 1
            if (nextIndex < dataList.size) {
                _currentPageIndex.value = nextIndex
            } else {
                viewModelScope.launch {
                    _eventFlow.emit(ViewEvent.ShowCompletion(completionMessage))
                }
            }
        } else {
            _currentPageCounter.value = newCount
        }
    }

    fun onPageChanged(index: Int) {
        _currentPageIndex.value = index
        _currentPageCounter.value = 0
    }

    fun goToPage(index: Int) {
        _currentPageIndex.value = index
        _currentPageCounter.value = 0
    }

    fun resetCounter() {
        _currentPageCounter.value = 0
    }

    fun goToHome() {
        viewModelScope.launch { _eventFlow.emit(ViewEvent.NavigateTo(Routes.HOME)) }
    }
}
```

### Subtask 4.2: FontViewModel

- [ ] Create `ui/screens/athkar/base/FontViewModel.kt`

```kotlin
class FontViewModel : ViewModel() {
    private val _fontSize = MutableStateFlow(28.6f)
    val fontSize: StateFlow<Float> = _fontSize.asStateFlow()

    private val _fontFamily = MutableStateFlow("Amiri")
    val fontFamily: StateFlow<String> = _fontFamily.asStateFlow()

    fun increaseFontSize() {
        if (_fontSize.value < 37f) _fontSize.value += 1f
    }

    fun decreaseFontSize() {
        if (_fontSize.value > 21f) _fontSize.value -= 1f
    }

    fun setFont(family: String) {
        _fontFamily.value = family
    }
}
```

### Subtask 4.3: FloatingCounterViewModel

- [ ] Create `ui/screens/athkar/base/FloatingCounterViewModel.kt`

```kotlin
class FloatingCounterViewModel : ViewModel() {
    private val _counter = MutableStateFlow(0)
    val counter: StateFlow<Int> = _counter.asStateFlow()

    fun increment() {
        _counter.value = (_counter.value + 1) % 100
    }

    fun incrementUntil100() {
        if (_counter.value >= 99) {
            _counter.value = 0
            // Haptic feedback
        } else {
            _counter.value += 1
        }
    }

    fun reset() {
        _counter.value = 0
    }
}
```

### Subtask 4.4: AthkarTextSlider component

- [ ] Create `ui/components/AthkarTextSlider.kt`
- [ ] HorizontalPager with background image, RTL, tap-to-advance

```kotlin
@Composable
fun AthkarTextSlider(
    viewModel: BaseAthkarViewModel,
    fontViewModel: FontViewModel,
    modifier: Modifier = Modifier
) {
    val pageIndex by viewModel.currentPageIndex.collectAsState()
    val fontSize by fontViewModel.fontSize.collectAsState()
    val fontFamily by fontViewModel.fontFamily.collectAsState()

    Box(modifier = modifier.fillMaxSize()) {
        // Background image
        Image(
            painter = painterResource(R.drawable.bg_91k),
            contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        // Dark overlay
        Box(Modifier.fillMaxSize().background(Color.Black.copy(alpha = 0.4f)))
        // Page slider
        HorizontalPager(
            pageCount = { viewModel.dataList.size },
            state = viewModel.pagerState,
            reverseLayout = true,
            modifier = Modifier.fillMaxSize().clickable { viewModel.incrementPageController() }
        ) { page ->
            val item = viewModel.dataList[page]
            Column(
                modifier = Modifier.fillMaxSize().padding(24.dp, 48.dp),
                verticalArrangement = Arrangement.Center
            ) {
                Text(
                    text = item.duaText ?: "",
                    fontFamily = if (fontFamily == "Amiri") FontFamily.Amiri else FontFamily.Cairo,
                    fontSize = fontSize.sp,
                    color = AppColor.primaryGold,
                    textAlign = TextAlign.Center
                )
                if (!item.footer.isNullOrBlank()) {
                    Spacer(Modifier.height(16.dp))
                    Text(
                        text = item.footer,
                        fontFamily = FontFamily.Amiri,
                        fontSize = (fontSize * 0.7f).sp,
                        color = AppColor.footer,
                        textAlign = TextAlign.Center
                    )
                }
            }
        }
    }
}
```

### Subtask 4.5: Shared UI components

- [ ] Create `ui/components/CustomButton.kt` — gold rounded button with icon + text

```kotlin
@Composable
fun CustomButton(
    icon: ImageVector,
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Button(
        onClick = onClick,
        modifier = modifier.fillMaxWidth().height(56.dp).padding(horizontal = 16.dp, vertical = 4.dp),
        colors = ButtonDefaults.buttonColors(containerColor = AppColor.darkGold),
        shape = RoundedCornerShape(28.dp)
    ) {
        Icon(icon, contentDescription = null, tint = Color.White)
        Spacer(Modifier.width(12.dp))
        Text(text, color = Color.White, fontFamily = FontFamily.Cairo)
    }
}
```

- [ ] Create `ui/components/FloatingCounterFab.kt`

```kotlin
@Composable
fun FloatingCounterFab(counter: Int, onClick: () -> Unit) {
    FloatingActionButton(
        onClick = onClick,
        containerColor = AppColor.darkGold,
        contentColor = Color.White,
        shape = CircleShape
    ) {
        Text(text = "$counter", fontSize = 18.sp)
    }
}
```

- [ ] Create `ui/components/CustomDrawer.kt` — 3 items: notifications, WhatsApp, share

```kotlin
@Composable
fun CustomDrawer(
    onNotificationSettings: () -> Unit,
    onWhatsApp: () -> Unit,
    onShare: () -> Unit
) {
    ModalDrawerSheet {
        Text("Athkarix", Modifier.padding(16.dp), fontFamily = FontFamily.Cairo)
        Divider()
        // Notification settings
        // WhatsApp
        // Share app
    }
}
```

- [ ] Create `ui/components/FontControls.kt` — + and - buttons for font size in TopAppBar

```kotlin
@Composable
fun FontControls(fontViewModel: FontViewModel) {
    Row {
        IconButton(onClick = { fontViewModel.decreaseFontSize() }) {
            Icon(Icons.Default.TextDecrease, "تصغير الخط")
        }
        IconButton(onClick = { fontViewModel.increaseFontSize() }) {
            Icon(Icons.Default.TextIncrease, "تكبير الخط")
        }
    }
}
```

### Subtask 4.6: DiacriticUtil

- [ ] Create `util/DiacriticUtil.kt` for Arabic diacritic removal

```kotlin
object DiacriticUtil {
    private val diacritics = Regex("[\u064B-\u065F\u0670]")

    fun remove(text: String): String = text.replace(diacritics, "")
}
```

### Subtask 4.7: FontScaleUtil

- [ ] Create `util/FontScaleUtil.kt` for tablet detection and scaling

```kotlin
object FontScaleUtil {
    @Composable
    fun isTablet(): Boolean = LocalConfiguration.current.screenWidthDp >= 600

    @Composable
    fun scaledFontSize(baseSize: Float): Float =
        if (isTablet()) baseSize * 1.5f else baseSize

    @Composable
    fun scaledSize(base: Float): Float =
        if (isTablet()) base * 1.5f else base
}
```
