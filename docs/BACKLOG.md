# Athkarix App Backlog

This backlog tracks planned tasks, optimizations, and feature requests for the Athkarix Flutter application.

## 📱 UI & Responsiveness

- [ ] **Adaptive Screens**: Refactor layouts using `MediaQuery` or `LayoutBuilder` to ensure the app is fully responsive to any screen size (phones, tablets, foldable devices).
- [ ] **Index Page**: Add an index/page view as a table of contents to easily navigate to any remembrance.
- [ ] **Current Font Size Indicator**: Show the current font size value to the user when adjusting font options.
- [ ] **Custom Fonts**: Add more Arabic and English font choices, allowing users to select their preferred typeface.

## 📿 Tasbeeh & Custom Dhikr

- [ ] **Dhikr Counter Adjustments**:
  - Add a decrement button (decrease counter towards `0`) on the tasbeeh bar.
- [ ] **Custom Remembrances**: Add support for a "My Dhikr" feature, allowing users to add custom phrases.
- [ ] **Vibration Feedback**:
  - Add vibration when completing a remembrance.
  - Specific vibration pattern when sending blessings upon the Prophet ﷺ (e.g., at 33, 66, 100, and every subsequent 100 repetitions).

## 🕌 New Supplications & Content

- [ ] **Distress Supplications**: Add a dedicated section for supplications during times of distress and anxiety.
- [ ] **Meanings & Explanations**: Integrate the meanings and explanations of the dhikr from classical references (e.g., *Al-Munjid*).
- [ ] **Sunnah Supplications**: Add the list of "One Hundred Supplications from the Sunnah" (from *Al-Munjid*).
- [ ] **Formulas for Forgiveness**: Copy and format standard formulas for seeking forgiveness (*Istighfar*).
- [ ] **Istighfar Benefits**: Display notes or margins detailing the spiritual benefits of seeking forgiveness.

## 🔔 Notifications & System

- [ ] **Reminders**: Implement localized notifications to remind users to read their Morning and Evening Athkar.
- [ ] **GetX State Optimization**: Refactor floating action buttons to remove the parent `GetBuilder` wrap, and apply it only to the specific internal text widget needing updates (improving widget rebuild performance).
