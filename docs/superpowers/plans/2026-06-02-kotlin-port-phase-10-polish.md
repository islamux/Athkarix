# Phase 10: Utilities, Sharing, WhatsApp & Final Polish

> **Goal:** Share intents, WhatsApp launch, tablet scaling, RTL, and final verification.

**Depends on:** Phases 5-9 (all features built)
**Plan file for:** `kotlin_port_010`

---

### Subtask 10.1: ShareUtil

- [ ] Create `util/ShareUtil.kt`

```kotlin
object ShareUtil {
    fun shareText(context: Context, text: String) {
        val sendIntent = Intent().apply {
            action = Intent.ACTION_SEND
            putExtra(Intent.EXTRA_TEXT, text)
            type = "text/plain"
        }
        context.startActivity(Intent.createChooser(sendIntent, "مشاركة"))
    }

    fun shareApp(context: Context) {
        val intent = Intent().apply {
            action = Intent.ACTION_SEND
            putExtra(Intent.EXTRA_TEXT, "تطبيق أذكاري - https://play.google.com/store/apps/details?id=${context.packageName}")
            type = "text/plain"
        }
        context.startActivity(Intent.createChooser(intent, "مشاركة التطبيق"))
    }
}
```

### Subtask 10.2: WhatsAppUtil

- [ ] Create `util/WhatsAppUtil.kt`

```kotlin
object WhatsAppUtil {
    private const val PHONE = "967772699924"

    fun openWhatsApp(context: Context) {
        try {
            val uri = Uri.parse("https://wa.me/$PHONE")
            context.startActivity(Intent(Intent.ACTION_VIEW, uri))
        } catch (e: ActivityNotFoundException) {
            // WhatsApp not installed → fallback to Google Play
            try {
                val playUri = Uri.parse("https://play.google.com/store/apps/details?id=com.whatsapp")
                context.startActivity(Intent(Intent.ACTION_VIEW, playUri))
            } catch (e2: Exception) {
                Toast.makeText(context, "تعذر فتح واتساب", Toast.LENGTH_SHORT).show()
            }
        }
    }
}
```

### Subtask 10.3: Wire drawer actions

- [ ] In `CustomDrawer.kt`, wire all 3 drawer items:
  1. Notification settings → `onNavigate(Routes.NOTIFICATION_SETTINGS)`
  2. WhatsApp → `WhatsAppUtil.openWhatsApp(context)`
  3. Share app → `ShareUtil.shareApp(context)`

### Subtask 10.4: RTL layout enforcement

- [ ] In `AndroidManifest.xml`, add to `<application>`:
```xml
android:supportsRtl="true"
```
- [ ] In `AthkarixApp.kt` or `MainActivity.kt`, ensure RTL layout direction:
```kotlin
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.decorView.layoutDirection = View.LAYOUT_DIRECTION_RTL
        setContent { ... }
    }
}
```

### Subtask 10.5: Back press exit on Home

- [ ] Already planned in Phase 5 (AlertExitApp). Verify it works:
  - Home screen back press → shows "هل أنهيت أذكارك؟" dialog
  - "نعم" → finish activity
  - "لا" → dismiss dialog

### Subtask 10.6: Vertical scroll for long athkar texts

- [ ] In `AthkarTextSlider.kt`, each page should scroll vertically if text is too long:
```kotlin
HorizontalPager(...) { page ->
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState()) // ← add scroll
            .padding(24.dp, 48.dp),
        verticalArrangement = Arrangement.Center
    ) { ... }
}
```

### Subtask 10.7: Final feature verification checklist

- [ ] Run `./gradlew assembleDebug` — clean build
- [ ] Verify all 22 features:

| # | Feature | Status |
|---|---|---|
| 1 | Home page with 11 navigation buttons | ⬜ |
| 2 | Drawer (notifications, WhatsApp, share) | ⬜ |
| 3 | Search across all athkar | ⬜ |
| 4 | Search diacritic normalization | ⬜ |
| 5 | Search result → full dua display | ⬜ |
| 6 | Morning athkar page with 24 items | ⬜ |
| 7 | Sabah repetition counts (1,3,7,100) | ⬜ |
| 8 | Tap to advance counter + auto-page | ⬜ |
| 9 | Completion snackbar | ⬜ |
| 10 | Evening athkar page | ⬜ |
| 11 | Post-prayer athkar page | ⬜ |
| 12 | Bedtime athkar page | ⬜ |
| 13 | Tasbih page + FAB counter | ⬜ |
| 14 | Istighfar page + FAB counter | ⬜ |
| 15 | Hamd page + FAB counter | ⬜ |
| 16 | Salat ala Rasoul page + FAB counter | ⬜ |
| 17 | Dua from Quran page | ⬜ |
| 18 | Dua from Sunnah page | ⬜ |
| 19 | 99 Names with JSON loading | ⬜ |
| 20 | Font + / — controls | ⬜ |
| 21 | Font family switching (Amiri/Cairo) | ⬜ |
| 22 | Share dua text via Intent | ⬜ |
| 23 | WhatsApp contact link | ⬜ |
| 24 | Exit confirmation dialog | ⬜ |
| 25 | Notification settings (toggle + time) | ⬜ |
| 26 | Scheduled daily notifications | ⬜ |
| 27 | Tablet font/icon scaling (1.5x) | ⬜ |
| 28 | Golden/amber-on-black theme | ⬜ |
| 29 | RTL layout | ⬜ |
| 30 | Background images on all pages | ⬜ |

### Subtask 10.8: Build release APK

```bash
./gradlew assembleRelease
# APK at: app/build/outputs/apk/release/app-release.apk
```
