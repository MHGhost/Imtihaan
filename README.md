# Imtihaan

Imtihaan is a Flutter study app for turning course materials into study aids. It includes Firebase email/Google authentication, document summaries, generated practice questions, handwriting OCR, quiz performance tracking, and profile/settings screens.

## Current status

This repository is being prepared for development and review. AI features require a separately deployed backend; the app intentionally contains no OpenAI secret. Configure `AI_PROXY_URL` at build time after deploying that backend. The backend should accept `POST` JSON shaped as `{"action":"summary|mcqs","text":"..."}` and return `{"result":"..."}` for summaries or `{"result":[...]}` for MCQs. Keep the provider API key only in the backend's secret store, authenticate/rate-limit requests, and validate input and output.

Firebase is currently configured for the Android and iOS app registrations in `imtihaan-ucp`. The application ID is still the Flutter template value `com.example.imtihaan`; register a production package/bundle ID in Firebase and regenerate platform configuration before publishing. Firebase security rules are included in this repository and must be deployed to the Firebase project.

Privacy and support contact: `safdarhamza115@gmail.com`. The in-app privacy notice is a development draft based on current source behavior; review it against the final deployed AI backend and project settings before public release.

## Requirements

- Flutter SDK compatible with Dart `^3.6.0`
- A Firebase project configured for Android and/or iOS, with Authentication, Cloud Firestore, and Storage enabled
- An AI backend for document summaries and MCQ generation

## Run locally

1. Install Flutter and the platform tooling (Android Studio/Android SDK or Xcode).
2. Fetch dependencies: `flutter pub get`.
3. Configure Firebase for the platforms you will run. Do not commit service-account credentials, signing keys, or provider secrets.
4. Authenticate the Firebase CLI with the project owner account, review the included rules, then deploy them with `firebase deploy --only firestore:rules,storage`.
5. Run the app: `flutter run`.
6. To enable AI, pass the backend URL at build/run time, for example `flutter run --dart-define=AI_PROXY_URL=https://your-backend.example/api/ai`.

## Features

- Email/password and Google sign-in
- Profile and profile-image management
- PDF/DOCX text extraction and AI summaries
- Handwriting text recognition
- AI-generated multiple-choice quizzes and locally stored performance totals
- Local history, theme, and settings screens

## Before public release

- Replace the template application ID and regenerate Firebase platform configuration.
- Have the development privacy notice and Terms of Service reviewed and finalized for your release and data handling.
- Deploy and secure the AI backend; never embed its provider key in the app.
- Review Firebase rules, platform permissions, release signing, and privacy/data retention practices.
- Replace the starter widget test with tests for Imtihaan's actual flows and run analysis/tests on supported platforms.

## License

No license has been selected yet. Add a license before accepting external contributions or granting reuse rights.
