# Phase 9: Notification System

> **Goal:** Schedule daily morning/evening notifications with settings screen.

**Depends on:** Phase 3 (navigation/DI), Phase 5 (drawer entry point)
**Plan file for:** `kotlin_port_009`

---

### Subtask 9.1: AthkarReminderReceiver

- [ ] Create `data/service/AthkarReminderReceiver.kt` — BroadcastReceiver

```kotlin
class AthkarReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val title = when (intent.action) {
            "SHOW_MORNING_REMINDER" -> "أذكار الصباح"
            "SHOW_EVENING_REMINDER" -> "أذكار المساء"
            else -> "تذكير بالأذكار"
        }
        val notification = NotificationCompat.Builder(context, NotificationService.CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(title)
            .setContentText("حان وقت قراءة الأذكار")
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setAutoCancel(true)
            .build()

        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(System.currentTimeMillis().toInt(), notification)
    }
}
```

### Subtask 9.2: NotificationService

- [ ] Create `data/service/NotificationService.kt`

```kotlin
class NotificationService(private val context: Context) {
    companion object {
        const val CHANNEL_ID = "athkar_reminders"
        const val MORNING_REQUEST_CODE = 1001
        const val EVENING_REQUEST_CODE = 1002
    }

    fun initialize() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "أذكار",
            NotificationManager.IMPORTANCE_DEFAULT
        ).apply {
            description = "تذكير بأذكار الصباح والمساء"
        }
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.createNotificationChannel(channel)
    }

    fun scheduleMorning(hour: Int, minute: Int) {
        schedule(hour, minute, "SHOW_MORNING_REMINDER", MORNING_REQUEST_CODE)
    }

    fun scheduleEvening(hour: Int, minute: Int) {
        schedule(hour, minute, "SHOW_EVENING_REMINDER", EVENING_REQUEST_CODE)
    }

    private fun schedule(hour: Int, minute: Int, action: String, requestCode: Int) {
        val intent = Intent(context, AthkarReminderReceiver::class.java).apply { this.action = action }
        val pendingIntent = PendingIntent.getBroadcast(context, requestCode, intent, PendingIntent.FLAG_IMMUTABLE)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
        }
        alarmManager.setRepeating(
            AlarmManager.RTC_WAKEUP,
            calendar.timeInMillis,
            AlarmManager.INTERVAL_DAY,
            pendingIntent
        )
    }

    fun cancelMorning() = cancel(MORNING_REQUEST_CODE)
    fun cancelEvening() = cancel(EVENING_REQUEST_CODE)
    fun cancelAll() { cancelMorning(); cancelEvening() }

    private fun cancel(requestCode: Int) {
        val intent = Intent(context, AthkarReminderReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(context, requestCode, intent, PendingIntent.FLAG_IMMUTABLE)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(pendingIntent)
    }
}
```

### Subtask 9.3: Register receiver in manifest

- [ ] Add to `AndroidManifest.xml`:
```xml
<receiver android:name=".data.service.AthkarReminderReceiver" android:exported="false" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
```

### Subtask 9.4: NotificationSettingsViewModel

- [ ] Create `ui/screens/settings/NotificationSettingsViewModel.kt`

```kotlin
class NotificationSettingsViewModel(
    private val prefs: SharedPrefsManager,
    private val notificationService: NotificationService
) : ViewModel() {
    val morningEnabled = MutableStateFlow(prefs.morningEnabled)
    val eveningEnabled = MutableStateFlow(prefs.eveningEnabled)
    val morningHour = MutableStateFlow(prefs.morningHour)
    val morningMinute = MutableStateFlow(prefs.morningMinute)
    val eveningHour = MutableStateFlow(prefs.eveningHour)
    val eveningMinute = MutableStateFlow(prefs.eveningMinute)

    fun setMorningEnabled(enabled: Boolean) {
        morningEnabled.value = enabled
        prefs.morningEnabled = enabled
        if (enabled) notificationService.scheduleMorning(morningHour.value, morningMinute.value)
        else notificationService.cancelMorning()
    }

    fun setMorningTime(hour: Int, minute: Int) {
        morningHour.value = hour
        morningMinute.value = minute
        prefs.morningHour = hour
        prefs.morningMinute = minute
        if (morningEnabled.value) {
            notificationService.cancelMorning()
            notificationService.scheduleMorning(hour, minute)
        }
    }

    // Same for evening...
}
```

### Subtask 9.5: NotificationSettingsScreen

- [ ] Create `ui/screens/settings/NotificationSettingsScreen.kt`

```kotlin
@Composable
fun NotificationSettingsScreen(
    viewModel: NotificationSettingsViewModel,
    onBack: () -> Unit
) {
    val morningEnabled by viewModel.morningEnabled.collectAsState()
    val eveningEnabled by viewModel.eveningEnabled.collectAsState()

    Scaffold(
        topBar = {
            TopAppBar(
                navigationIcon = { IconButton(onClick = onBack) { Icon(Icons.AutoMirrored.Filled.ArrowBack, "رجوع") } },
                title = { Text("إعدادات التذكير") },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = Color.Black, titleContentColor = AppColor.primaryGold)
            )
        }
    ) { padding ->
        Column(Modifier.fillMaxSize().padding(padding).padding(16.dp)) {
            // Morning toggle
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Text("تذكير الصباح", color = AppColor.textPrimary)
                Switch(checked = morningEnabled, onCheckedChange = { viewModel.setMorningEnabled(it) })
            }
            if (morningEnabled) {
                // Time picker row
                TextButton(onClick = { /* show TimePicker */ }) {
                    Text("${viewModel.morningHour.value}:${viewModel.morningMinute.value}", color = AppColor.primaryGold)
                }
            }
            Spacer(Modifier.height(24.dp))
            // Evening toggle (same pattern)
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Text("تذكير المساء", color = AppColor.textPrimary)
                Switch(checked = eveningEnabled, onCheckedChange = { viewModel.setEveningEnabled(it) })
            }
            if (eveningEnabled) {
                TextButton(onClick = { /* show TimePicker */ }) {
                    Text("${viewModel.eveningHour.value}:${viewModel.eveningMinute.value}", color = AppColor.primaryGold)
                }
            }
        }
    }
}
```

### Subtask 9.6: Initialize notification service in AthkarixApp

```kotlin
class AthkarixApp : Application() {
    override fun onCreate() {
        super.onCreate()
        NotificationService(this).initialize()
    }
}
```

### Subtask 9.7: Wire in NavGraph + Drawer

- [ ] Add settings route in NavGraph
- [ ] Wire "notification settings" drawer item
- [ ] Verify: toggles persist across app restart, notification appears at scheduled time
