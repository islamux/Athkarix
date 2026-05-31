# 📿 Athkarix - تطبيق الأذكار الذكي

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter&style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blueviolet?style=flat-square)
![License](https://img.shields.io/badge/License-GPLv3-blue?logo=gnu&style=flat-square)

> **Athkarix** is a modern app for daily Islamic Athkar (remembrances) and Duas, offering a beautiful, multilingual, and user-friendly experience for Muslims worldwide.  
> Built with ❤️ by [@islamux](https://github.com/islamux)

---

## 🚀 Features

- 🕌 Comprehensive collection of daily Athkar, Duas, and Quranic supplications
- 🌙 Dark & Light mode support
- 🌍 Multilingual support (Arabic & English)
- 📱 Fully responsive and adaptive for phones & tablets
- 🔔 Smart reminders for morning/evening Athkar
- ✨ Smooth animations and elegant design
- 🧮 Tasbeeh counter & custom zikr support
- 📊 Usage statistics & progress tracking
- 📝 Local data for fast offline use

---

## 📷 Preview

<!-- Add a screenshot here if available
![App Preview](screenshots/preview.png)
-->

---

## 📦 Requirements

- Flutter SDK (compatible with Dart `>=2.18.2 <3.0.0`)
- Android Studio / Xcode (for running on device or emulator)

Install dependencies:

```bash
flutter pub get
```

---

## 🧪 How to Use

```bash
git clone https://github.com/islamux/Athkarix.git
cd Athkarix

# Install dependencies
flutter pub get

# Run on Android
flutter run

# Run on iOS (ensure you have Xcode installed)
flutter run
```

## 🧠 How It Works

- Uses local JSON/TypeScript data modules for Athkar and Duas.
- Internationalization via Flutter's localization system (`l10n/`).
- Athkar are displayed and filtered client-side, with dynamic language and theme switching.
- Fully responsive and visually enhanced with Flutter widgets and animations.
- Smart notification system to remind users at the right times.

---

## 📂 Documentation Directory

All developer and project documentation is located in the [docs/](file:///media/islamux/Variety/Flutter_Projects/Athkarix/docs) directory:

- **[BACKLOG.md](file:///media/islamux/Variety/Flutter_Projects/Athkarix/docs/BACKLOG.md)**: Main project roadmap, feature backlog, and optimization list.
- **[ai-rules.md](file:///media/islamux/Variety/Flutter_Projects/Athkarix/docs/ai-rules.md)**: Universal AI agent protocols — 5-phase workflow for all tasks.
- **[SETUP_COMMAND_CENTER.md](file:///media/islamux/Variety/Flutter_Projects/Athkarix/docs/SETUP_COMMAND_CENTER.md)**: Setup and operation guide for the command center TUI dashboard (`ccui`) and MCP.
- **[APK_DISTRIBUTION_GUIDE.md](file:///media/islamux/Variety/Flutter_Projects/Athkarix/docs/APK_DISTRIBUTION_GUIDE.md)**: Build and release process for Android APK distribution.
- **[SEARCH_FUNCTIONALITY.md](file:///media/islamux/Variety/Flutter_Projects/Athkarix/docs/SEARCH_FUNCTIONALITY.md)**: Design blueprint for search and indexing features.
- **[workflow.md](file:///media/islamux/Variety/Flutter_Projects/Athkarix/docs/workflow.md)**: Task lifecycle state-machine and agent workflow guidelines.
- **[archive/](file:///media/islamux/Variety/Flutter_Projects/Athkarix/docs/archive)**: Historical blueprints and scratchpad documents.
- **[superpowers/](file:///media/islamux/Variety/Flutter_Projects/Athkarix/docs/superpowers)**: Superpowers implementation plans and design specifications.

---

## 📜 License

This project is licensed under the **GNU General Public License v3.0**.  
Feel free to use, share, and contribute!  
Read more: [https://www.gnu.org/licenses/gpl-3.0.html](https://www.gnu.org/licenses/gpl-3.0.html)

---

## ✨ Author

**[@islamux](https://github.com/islamux)**  
💻 Muslim Developer • Linux Terminal Lover • Open Source Enthusiast  
🕊️ "وَمَا أَرْسَلْنَاكَ إِلَّا رَحْمَةً لِّلْعَالَمِينَ" – الأنبياء 107  
*Using technology to spread peace and benefit all of humanity.*

---

## ☁️ Future Ideas

- Add cloud sync for user data & progress
- Audio recitation for Athkar and Duas
- More languages and custom themes
- Community-contributed Athkar/duas
- Widget support for quick access
