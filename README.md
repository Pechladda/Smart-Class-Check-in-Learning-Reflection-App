# Smart Class Check-in & Learning Reflection App

## 1. Project Overview

Smart Class Check-in & Learning Reflection App is a Flutter mobile application for university students. The app supports class attendance by combining QR code scanning and GPS location verification. It also helps students reflect on their learning before and after each class.

This project is developed for a university midterm submission.

## 2. Features

- QR code scanning for class check-in and class finish workflows
- GPS location capture (latitude and longitude)
- Before-class reflection:
	- Previous class topic
	- Expected topic today
	- Mood score (1–5)
- After-class reflection:
	- What did you learn today
	- Feedback about the class
- Data persistence using Firebase Firestore for storing all check-in and learning reflection records.

## 3. App Screens

### Home Screen
- Check-in to Class
- Finish Class

### Check-in Screen (Before Class)
- Scan QR code
- Get GPS location
- Enter previous class topic
- Enter expected topic today
- Select mood score (1–5)
- Submit data

### Finish Class Screen (After Class)
- Scan QR code
- Get GPS location
- Enter what was learned today
- Enter class feedback
- Save data

## 4. Technology Stack

- Flutter
- Material UI (Material Design widgets)
- `mobile_scanner` (QR code scanning)
- `geolocator` (GPS location)
- Firebase Firestore (cloud data storage)
- Firebase Hosting (deployment)

## 5. Installation

### Prerequisites

Make sure the following are installed:
- Flutter SDK (stable)
- Dart SDK (included with Flutter)
- Xcode (for iOS/macOS development)
- Android Studio + Android SDK (for Android development)
- Firebase CLI (`npm install -g firebase-tools`) for hosting deployment

### Clone and Setup

```bash
git clone <your-repository-url>
cd smart_class_app
flutter pub get
```

### Platform Permissions

Location and camera permissions are required.
- iOS: configure permission keys in `ios/Runner/Info.plist`
- Android: configure camera/location permissions in `android/app/src/main/AndroidManifest.xml`

## 6. How to Run the App

```bash
flutter run
```

To run on a specific device:

```bash
flutter devices
flutter run -d <device_id>
```

To run tests:

```bash
flutter test
```

## 7. Firebase Deployment

### A) Firestore Setup

1. Create a Firebase project at https://console.firebase.google.com/
2. Add Android/iOS/Web apps to the Firebase project.
3. Configure FlutterFire:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

4. Add required packages:

```bash
flutter pub add firebase_core cloud_firestore
```

5. Initialize Firebase in app startup (`main.dart`) before using Firestore.

### B) Firebase Hosting (Web)

Build Flutter web:

```bash
flutter build web
```

Initialize and deploy hosting:

```bash
firebase login
firebase init hosting
firebase deploy
```

Use `build/web` as the public directory when prompted.

## 8. Project Structure

```text
smart_class_app/
├── lib/
│   ├── main.dart
│   ├── home_screen.dart
│   ├── checkin_screen.dart
│   ├── finish_class_screen.dart
│   └── local_storage_service.dart
├── android/
├── ios/
├── web/
├── test/
├── pubspec.yaml
└── README.md
```

## 9. Future Improvements

- Integrate full Firestore read/write flow for all records
- Add Firebase Authentication for student identity
- Add geofencing and classroom location validation
- Add instructor dashboard and analytics
- Add export/report feature (CSV/PDF)
- Add offline sync support

## 10. Author

- University Midterm Project Team
- Project: Smart Class Check-in & Learning Reflection App
