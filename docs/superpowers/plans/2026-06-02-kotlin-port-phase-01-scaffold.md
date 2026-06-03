# Phase 1: Project Scaffold & Theme

> **Goal:** Create the Android project skeleton with Gradle Kotlin DSL, dependencies, and the golden dark theme.

**Depends on:** Nothing
**Plan file for:** `kotlin_port_001`

---

### Subtask 1.1: Create project structure

- [ ] Create root `build.gradle.kts` with Kotlin plugin + Android Gradle plugin
- [ ] Create `settings.gradle.kts` with project name
- [ ] Create `gradle.properties` with Android config
- [ ] Create `app/build.gradle.kts` with Compose dependencies
- [ ] Create `AndroidManifest.xml` (minSdk 24, targetSdk 34)

**Key deps in app/build.gradle.kts:**
```kotlin
plugins {
    id("com.android.application") version "8.2.0"
    id("org.jetbrains.kotlin.android") version "1.9.22"
}

android {
    namespace = "com.athkarix.app"
    compileSdk = 34
    defaultConfig {
        minSdk = 24
        targetSdk = 34
    }
    buildFeatures { compose = true }
    composeOptions { kotlinCompilerExtensionVersion = "1.5.8" }
}

dependencies {
    implementation(platform("androidx.compose:compose-bom:2024.01.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.navigation:navigation-compose:2.7.6")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0")
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation("androidx.work:work-runtime-ktx:2.9.0")
}
```

### Subtask 1.2: Application class + MainActivity

- [ ] Create `AthkarixApp.kt` extending `Application` (WorkManager init here later)
- [ ] Create `MainActivity.kt` with `setContent { AthkarixTheme { ... } }`
- [ ] Register `AthkarixApp` in `AndroidManifest.xml`

**MainActivity.kt:**
```kotlin
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            AthkarixTheme {
                AthkarixNavGraph(rememberNavController())
            }
        }
    }
}
```

### Subtask 1.3: Golden dark theme

- [ ] Create `AppColor.kt` with color constants (mirrors Flutter `AppColor`)
- [ ] Create `AppTheme.kt` with `MaterialTheme` (dark color scheme)

**AppColor.kt:**
```kotlin
object AppColor {
    val primaryGold = Color(0xFFFFD700)
    val darkGold = Color(0xFFD4AF37)
    val amber = Color(0xFFFFBF00)
    val background = Color(0xFF000000)
    val surface = Color(0xFF1A1A1A)
    val textPrimary = Color(0xFFFFD700)
    val textSecondary = Color(0xFFCCCCCC)
    val footer = Color(0xFFB0B0B0)
    val ayahHadith = Color(0xFF9C27B0)
}
```

**AppTheme.kt:**
```kotlin
private val DarkColorScheme = darkColorScheme(
    primary = AppColor.primaryGold,
    onPrimary = AppColor.background,
    secondary = AppColor.amber,
    background = AppColor.background,
    surface = AppColor.surface,
    onBackground = AppColor.textPrimary,
    onSurface = AppColor.textPrimary,
)

@Composable
fun AthkarixTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = DarkColorScheme,
        typography = Typography(...),
        content = content
    )
}
```

### Subtask 1.4: Add font resources

- [ ] Copy Amiri-Regular.ttf, Amiri-Bold.ttf to `app/src/main/res/font/`
- [ ] Copy Cairo-Regular.ttf, Cairo-Bold.ttf to `app/src/main/res/font/`
- [ ] Create `res/font/font_cairo.xml` and `res/font/font_amiri.xml` font family XML files

**font_amiri.xml:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<font-family xmlns:android="http://schemas.android.com/apk/res/android">
    <font android:font="@font/amiri_regular" android:fontStyle="normal" android:fontWeight="400"/>
    <font android:font="@font/amiri_bold" android:fontStyle="normal" android:fontWeight="700"/>
</font-family>
```

### Subtask 1.5: Add background images

- [ ] Copy `91k.jpg` and `athkari5.jpg` to `app/src/main/res/drawable/`
- [ ] Create `res/drawable` XML references if needed

### Subtask 1.6: Verify build

- [ ] Run `./gradlew assembleDebug`
- [ ] Confirm no compilation errors
- [ ] Confirm theme renders (dark bg, gold accents)
