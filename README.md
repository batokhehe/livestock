# Livestock

A Flutter project for livestock management, built with Clean Architecture and Riverpod.

## Environment Info
- **Flutter Version:** 3.35.5 (Stable)
- **Dart Version:** 3.9.2
- **State Management:** Riverpod (`flutter_riverpod`)
- **Architecture:** Clean Architecture

## Getting Started

1.  **Dependencies**: Run `flutter pub get`
2.  **Environment**: Ensure you are using Flutter 3.35.5
3.  **Run**: `flutter run`

## Release Guidance (Android)

This project is configured to upload releases directly to **Firebase App Distribution**.

### 1. Preparation
Ensure the following files are present in the `android/` directory (these are usually not tracked by Git):
- `local.properties`: Must include `firebaseAppId`.
- `key.properties`: Android signing configuration.
- `livestock-keystore.jks`: The signing keystore file.
- `app-distribution-key.json`: Firebase Service Account credentials.
- `release-notes.txt`: Content for the release notes in App Distribution.

### 2. Release Command
Run the following command from the root directory to build and upload:

```bash
./gradlew -p android assembleRelease appDistributionUploadRelease
```

Or navigate to the android directory:
```bash
cd android
./gradlew assembleRelease appDistributionUploadRelease
```

> [!IMPORTANT]
> Make sure `firebaseAppId` in `local.properties` matches your Firebase Project App ID.
