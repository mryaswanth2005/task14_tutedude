# Task 14 - Flutter Firebase Todo App

this is my drive link : https://drive.google.com/drive/folders/1PbWWqgKDBDorh525uecKaGZD21FGSoCeR?usp=drive_link

<img width="620" height="451" alt="image" src="https://github.com/user-attachments/assets/f6e248a9-ac39-4877-8601-cd13757d79be" />


A Flutter todo application with Firebase Authentication and Cloud Firestore.

## Features

- Email and password sign-in
- Google sign-in
- Add, edit, complete, and delete todos
- Real-time Firestore updates
- Web-ready Firebase initialization

## Tech Stack

- Flutter
- Firebase Core
- Firebase Auth
- Cloud Firestore
- Provider

## Project Structure

- `lib/main.dart` - app startup and Firebase initialization
- `lib/firebase_options.dart` - Firebase platform options
- `lib/models/todo.dart` - todo model
- `lib/services/auth_service.dart` - authentication logic
- `lib/services/firestore_service.dart` - todo database operations
- `lib/screens/login_screen.dart` - login UI
- `lib/screens/todo_screen.dart` - todo UI

## Prerequisites

- Flutter SDK installed
- A Firebase project
- FlutterFire CLI (recommended)

## Setup

1. Install dependencies:

```bash
flutter pub get
```

2. Configure Firebase for your platforms:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

3. Ensure your Firebase options are present in `lib/firebase_options.dart`.

4. If prompted by FlutterFire, add platform config files:
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

## Run

Run on the current connected device:

```bash
flutter run
```

Run specifically for web:

```bash
flutter run -d chrome
```

## Build Web

```bash
flutter build web --debug
```

## Notes

- This project initializes Firebase with `DefaultFirebaseOptions.currentPlatform`.
- If you change Firebase projects, re-run `flutterfire configure`.
