# Auth App

## Overview
A Flutter-based authentication demo app using BLoC. The app supports login, register, and a protected `HomeScreen`. Authentication is managed by an `AuthBloc` that emits `AuthAuthenticated` / `AuthUnauthenticated` states. Native platform code (Android/iOS) and plugins may include Kotlin, Java, C++, and Gradle components.

Key files:
- `lib/blocs/auth/auth_bloc.dart` — authentication logic and state transitions.
- `lib/src/features/home/presentation/pages/home_screen.dart` — home UI shown to authenticated users.
- `lib/src/features/login/presentation/pages/login_screen.dart` — login UI (referenced by `HomeScreen`).

## Auth flow (important note)
There was a race where, immediately after login/register, the app sometimes redirected back to the login screen because the bloc queried the repository for the current user before the repository updated. This was fixed by preferring the `User` carried by the `UserLoggedIn` event (if provided) inside `lib/blocs/auth/auth_bloc.dart`. Ensure that login and register code dispatch `UserLoggedIn(user: newlyCreatedOrFetchedUser)` to avoid the race.

## Prerequisites (macOS)
- Flutter SDK (recommend Flutter 3.x or later). Install from https://flutter.dev
- Dart SDK (bundled with Flutter)
- Android SDK (via Android Studio)
- Android Studio (your environment: Android Studio Otter 2 Feature Drop | 2025.2.2 is supported)
- Java JDK (version 11 or later)
- Xcode (if building/running for iOS)
- CocoaPods (for iOS): `sudo gem install cocoapods` or `brew install cocoapods`
- `git` and a GitHub account (for repository checkout)
- If the project uses native C++/NDK features: Android NDK (install via Android Studio SDK Manager)
- Any backend/API keys or environment configuration required by the app (check repository docs or `lib/` for API config)

## Setup
1. Clone the repository:
   - `git clone <repo-url>`
   - `cd <repo-name>`

2. Install Dart/Flutter dependencies:
   - `flutter pub get`

3. Platform-specific setup:
   - Android: ensure an Android emulator or device is connected; set `ANDROID_HOME` / `ANDROID_SDK_ROOT` if needed.
   - iOS: run `pod install` in `ios/` (or `flutter run` will do this) and open the workspace in Xcode if you need to modify native signing.

4. Build & run:
   - Run on connected device / emulator: `flutter run`
   - Build APK: `flutter build apk`
   - Build iOS: `flutter build ios` (requires Xcode & proper code signing)

## Recommended commands
- Get packages: `flutter pub get`
- Run analyzer: `flutter analyze`
- Run tests: `flutter test`
- Format code: `flutter format .`

## Configuration & environment
- Check for any `.env`, `assets/`, or config files in the project root. The repository may expect an API base URL or keys; add these before running.
- If the app uses Firebase, follow Firebase console steps and add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).

## Where to look for auth-related code
- Authentication state and logic: `lib/blocs/auth/auth_bloc.dart`, `lib/blocs/auth/auth_event.dart`, `lib/blocs/auth/auth_state.dart`
- Repository that interacts with backend/local storage: `lib/repositories/auth_repository.dart` (or similar path)
- Login / Register UIs: `lib/src/features/login/...`
- Home UI: `lib/src/features/home/presentation/pages/home_screen.dart`

## Troubleshooting
- App immediately redirects to login after entering credentials:
  - Confirm the login/register code dispatches `UserLoggedIn(user: user)` with the newly created/returned `User`.
  - Confirm `lib/blocs/auth/auth_bloc.dart` uses the event `user` when available (this prevents the repository-race condition).
- `flutter pub get` errors: run `flutter clean` then `flutter pub get`.
- Android build errors about Gradle or JDK: ensure JDK 11+, update Gradle wrapper via Android Studio.
- iOS code signing: open `ios/Runner.xcworkspace` in Xcode and set a valid development team.

## Notes
- This README is generic to cover typical Flutter + native components used in this project. Inspect the project root for any additional README, `.env.example`, or platform-specific instructions added by the repo author.
