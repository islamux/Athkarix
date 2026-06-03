# Phase 2: Data Layer — Models + Static Text

> **Goal:** Create data models and port all 12 Flutter static text files to Kotlin objects.

**Depends on:** Phase 1 (project structure)
**Plan file for:** `kotlin_port_002`

---

### Subtask 2.1: Data models

- [ ] Create `data/model/AthkarItem.kt`
- [ ] Create `data/model/AssmaHussnaItem.kt`

**AthkarItem.kt:**
```kotlin
package com.athkarix.app.data.model

data class AthkarItem(
    val duaText: String?,
    val footer: String?
)
```

**AssmaHussnaItem.kt:**
```kotlin
package com.athkarix.app.data.model

data class AssmaHussnaItem(
    val id: Int,
    val name: String,
    val text: String
) {
    companion object {
        fun fromJson(json: org.json.JSONObject): AssmaHussnaItem = AssmaHussnaItem(
            id = json.getInt("id"),
            name = json.getString("name"),
            text = json.getString("text")
        )
    }
}
```

### Subtask 2.2: Static text — AthkarSabahText

- [ ] Port `lib/core/data/static/text/athkar_sabah_text.dart` to `data/text/AthkarSabahText.kt`
- [ ] 24 entries with `TITLE_N`, `TEXT_N`, `FOOTER_N`

**AthkarSabahText.kt:**
```kotlin
package com.athkarix.app.data.text

object AthkarSabahText {
    const val TITLE_1 = "آيَةُ الْكُرْسِيِّ"
    const val TEXT_1 = "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ..."
    const val FOOTER_1 = "سورة البقرة 255"
    // ... 24 entries total
}
```

### Subtask 2.3: Static text — remaining 11 files

- [ ] Port each Flutter text file to a Kotlin object:
  - `AthkarMassaText.kt` (~22 entries)
  - `AthkarAfterSalatText.kt` (~11 entries)
  - `AthkarBeforeBedText.kt` (9 entries)
  - `TasbihText.kt` (~29 entries)
  - `EstigfarText.kt` (~20 entries)
  - `HamdText.kt` (~56 entries)
  - `SalatAlaRasoulText.kt` (~40 entries)
  - `DuaMenQuranText.kt` (12 entries)
  - `DuaMenSunnahText.kt` (~45 entries)
  - `AssmaHussnaText.kt` (~217 entries / 99 Names)
  - `HadithText.kt` (hadith references)

### Subtask 2.4: AthkarRepository

- [ ] Create `data/repository/AthkarRepository.kt`
- [ ] All 12 lists aggregated from text objects
- [ ] `searchAll()` method placeholder

**AthkarRepository.kt:**
```kotlin
package com.athkarix.app.data.repository

import com.athkarix.app.data.model.AthkarItem
import com.athkarix.app.data.text.*

object AthkarRepository {
    val sabahList: List<AthkarItem> = listOf(
        AthkarItem(AthkarSabahText.TEXT_1, AthkarSabahText.FOOTER_1),
        // ... all 24 entries
    )
    val massaList: List<AthkarItem> = listOf(
        AthkarItem(AthkarMassaText.TEXT_1, AthkarMassaText.FOOTER_1),
        // ...
    )
    // ... all 12 lists
    val allLists: Map<String, List<AthkarItem>> = mapOf(
        "sabah" to sabahList,
        "massa" to massaList,
        // ...
    )
}
```

### Subtask 2.5: AssmaHussnaService

- [ ] Create `data/service/AssmaHussnaService.kt`
- [ ] Load from `assets/json/assma-hussna.json`
- [ ] Cache loaded data
- [ ] `searchByName()`, `searchByText()`, `clearCache()`

**AssmaHussnaService.kt:**
```kotlin
package com.athkarix.app.data.service

import android.content.Context
import com.athkarix.app.data.model.AssmaHussnaItem
import org.json.JSONArray

class AssmaHussnaService(private val context: Context) {
    private var cached: List<AssmaHussnaItem>? = null

    fun getAll(): List<AssmaHussnaItem> {
        if (cached == null) {
            val json = context.assets.open("json/assma-hussna.json")
                .bufferedReader().use { it.readText() }
            val arr = JSONArray(json)
            cached = (0 until arr.length()).map {
                AssmaHussnaItem.fromJson(arr.getJSONObject(it))
            }
        }
        return cached!!
    }

    fun searchByName(query: String): List<AssmaHussnaItem> {
        val q = query.lowercase()
        return getAll().filter { it.name.lowercase().contains(q) }
    }

    fun searchByText(query: String): List<AssmaHussnaItem> {
        val q = query.lowercase()
        return getAll().filter { it.text.lowercase().contains(q) }
    }

    fun clearCache() { cached = null }
}
```

### Subtask 2.6: SharedPrefsManager

- [ ] Create `data/service/SharedPrefsManager.kt`
- [ ] Wrapper around `SharedPreferences` for notification settings

**SharedPrefsManager.kt:**
```kotlin
package com.athkarix.app.data.service

import android.content.Context
import android.content.SharedPreferences

class SharedPrefsManager(context: Context) {
    private val prefs: SharedPreferences =
        context.getSharedPreferences("athkarix_prefs", Context.MODE_PRIVATE)

    var morningEnabled: Boolean
        get() = prefs.getBoolean("morning_enabled", true)
        set(value) = prefs.edit().putBoolean("morning_enabled", value).apply()

    var eveningEnabled: Boolean
        get() = prefs.getBoolean("evening_enabled", true)
        set(value) = prefs.edit().putBoolean("evening_enabled", value).apply()

    var morningHour: Int
        get() = prefs.getInt("morning_hour", 6)
        set(value) = prefs.edit().putInt("morning_hour", value).apply()

    var morningMinute: Int
        get() = prefs.getInt("morning_minute", 0)
        set(value) = prefs.edit().putInt("morning_minute", value).apply()

    var eveningHour: Int
        get() = prefs.getInt("evening_hour", 17)
        set(value) = prefs.edit().putInt("evening_hour", value).apply()

    var eveningMinute: Int
        get() = prefs.getInt("evening_minute", 0)
        set(value) = prefs.edit().putInt("evening_minute", value).apply()
}
```
