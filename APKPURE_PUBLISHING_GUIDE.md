# APKPure Publishing Guide for Athkarix App

## Overview
This document outlines the complete process for preparing and publishing the Athkarix Flutter app (أذكاري) to APKPure.

## Pre-Publishing Checklist

### ✅ Completed Steps

#### 1. App Version Configuration
- **Previous Version:** 1.0.0+1
- **Updated Version:** 1.0.1+2
- **Location:** `pubspec.yaml`
```yaml
version: 1.0.1+2
```

#### 2. Package Name Update
- **Previous:** com.example.athkarix (default example package)
- **Updated:** com.athkarix.app (unique package identifier)
- **Files Modified:**
  - `android/app/build.gradle` - namespace and applicationId
  
#### 3. Android Signing Configuration

##### Keystore Creation
- **Keystore File:** `android/app/upload-keystore.jks`
- **Alias:** upload
- **Validity:** 10,000 days
- **Algorithm:** RSA 2048-bit

##### Key Properties File
- **Location:** `android/key.properties`
- **Contents:**
```properties
storePassword=athkarix2024
keyPassword=athkarix2024
keyAlias=upload
storeFile=upload-keystore.jks
```

##### Build.gradle Configuration
Added signing configuration for release builds:
```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.release
    }
}
```

#### 4. Security Configuration
Added to `.gitignore`:
```
# Keep signing keys secure
/android/key.properties
/android/app/upload-keystore.jks
```

#### 5. App Icons Configuration
- **Icon Source:** `assets/icons/dua.png`
- **Configuration:** flutter_launcher_icons in pubspec.yaml
- **Generated:** All required Android mipmap densities (hdpi, mdpi, xhdpi, xxhdpi, xxxhdpi)
- **Command Used:** `flutter pub run flutter_launcher_icons`

#### 6. App Metadata
- **App Name:** أذكاري
- **Package Name:** com.athkarix.app
- **Min SDK:** 21
- **Target SDK:** 34
- **Compile SDK:** 34

#### 7. Code Analysis
Ran `flutter analyze` - Found 55 issues (mostly informational):
- Print statements in production code (can be kept for now)
- Missing type annotations
- Deprecated API usage warnings
- These are non-critical and won't prevent building

## ✅ Build Results

### Successfully Built APKs

#### Universal APK (All Architectures)
- **File:** `app-release.apk`
- **Size:** 52.1MB
- **Path:** `/build/app/outputs/flutter-apk/app-release.apk`
- **Recommendation:** Use this for APKPure submission

#### Split APKs (Per Architecture)
- **arm64-v8a-release.apk:** 19.4MB (Most modern devices)
- **armeabi-v7a-release.apk:** 16.8MB (Older 32-bit devices)
- **x86_64-release.apk:** 20.6MB (Intel/AMD devices)

## Remaining Steps to Complete

### ✅ Step 8: Build Release APK [COMPLETED]
```bash
# Clean build artifacts
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release
```

The release APK will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

### 📝 Step 9: Alternative Build Options

#### Option A: Build Universal APK (Recommended for APKPure)
```bash
flutter build apk --release
```
- Single APK file
- Larger size (~15-25MB typically)
- Works on all devices

#### Option B: Build App Bundle (AAB)
```bash
flutter build appbundle --release
```
- Location: `build/app/outputs/bundle/release/app-release.aab`
- Smaller size
- Google Play preferred format

#### Option C: Build Split APKs
```bash
flutter build apk --split-per-abi --release
```
- Creates separate APKs for each architecture
- Smaller individual files
- Files created:
  - app-armeabi-v7a-release.apk
  - app-arm64-v8a-release.apk
  - app-x86_64-release.apk

### 📝 Step 10: Test Release APK
1. Transfer APK to Android device
2. Enable "Install from Unknown Sources"
3. Install and test all features
4. Verify:
   - App name displays correctly (أذكاري)
   - Icon appears correctly
   - All functionality works
   - No crashes or errors

### 📝 Step 11: APK Optimization (Optional)
```bash
# Check APK size
ls -lh build/app/outputs/flutter-apk/app-release.apk

# Analyze APK size breakdown
flutter build apk --analyze-size
```

### 📝 Step 12: Prepare for APKPure Submission

#### Required Materials:
1. **APK File:** `app-release.apk`
2. **App Information:**
   - App Name: أذكاري (Athkarix)
   - Category: Books & Reference or Lifestyle
   - Language: Arabic
   - Description: Islamic remembrance (Athkar) application

3. **Screenshots:** Prepare at least 2-8 screenshots showing:
   - Main screen
   - Morning Athkar
   - Evening Athkar
   - Allah's Names (Asma ul Husna)
   - Settings/Features

4. **App Icon:** High-resolution version (512x512 px recommended)

5. **Description in English and Arabic:**
   ```
   English: Athkarix is a comprehensive Islamic remembrance app featuring morning and evening Athkar, 
   post-prayer supplications, and the 99 names of Allah with meanings.
   
   Arabic: تطبيق أذكاري شامل يحتوي على أذكار الصباح والمساء، أذكار ما بعد الصلاة، 
   وأسماء الله الحسنى مع المعاني.
   ```

### 📝 Step 13: Upload to APKPure

1. Visit: https://apkpure.com/submit-apk
2. Create developer account if needed
3. Fill in app details:
   - Upload APK file
   - Add app name and description
   - Select appropriate category
   - Upload screenshots
   - Add contact information

4. Submit for review

### 📝 Step 14: Post-Submission

1. **Monitor Review Status:** Usually takes 1-3 business days
2. **Respond to Feedback:** If APKPure requests changes
3. **Update Regularly:** Plan for future updates

## Important Notes

### ⚠️ Keystore Security
- **NEVER** lose your keystore file or passwords
- **BACKUP** your keystore in multiple secure locations
- You cannot update your app without the original keystore

### 📱 Testing Recommendations
Before publishing, test on:
- Different Android versions (especially min SDK 21)
- Different screen sizes
- Different device manufacturers
- Both Arabic and English locales

### 🔄 Version Management
For future updates:
- Increment version name (e.g., 1.0.2, 1.1.0)
- Always increment build number (e.g., 3, 4, 5...)
- Keep changelog of changes

### 📊 APK Size Optimization Tips
If APK is too large:
1. Use `--split-per-abi` for architecture-specific APKs
2. Optimize images (compress PNG files)
3. Remove unused dependencies
4. Enable code shrinking in build.gradle

## Troubleshooting

### Common Issues:

1. **Build Fails:**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

2. **Signing Issues:**
   - Verify key.properties path is correct
   - Check keystore file exists
   - Ensure passwords are correct

3. **Large APK Size:**
   - Use split APKs
   - Optimize assets
   - Remove debug symbols

## Commands Reference

```bash
# Clean project
flutter clean

# Get dependencies
flutter pub get

# Analyze code
flutter analyze

# Build release APK
flutter build apk --release

# Build with size analysis
flutter build apk --release --analyze-size

# Build split APKs
flutter build apk --split-per-abi --release

# Check APK details
aapt dump badging build/app/outputs/flutter-apk/app-release.apk
```

## Next Steps After Publishing

1. Monitor download statistics
2. Respond to user reviews
3. Plan regular updates
4. Consider publishing to other stores:
   - Google Play Store
   - Amazon App Store
   - Huawei AppGallery
   - Samsung Galaxy Store

---

**Document Created:** January 3, 2025
**App Version:** 1.0.1+2
**Package:** com.athkarix.app
