# Imtihaan 📚

**A Flutter-based study companion designed to help students turn learning materials into study aids.**

Imtihaan combines Firebase authentication, document processing, handwriting recognition, and AI-powered study features in one mobile application.

## ✨ Features

- **Authentication:** Email/password and Google sign-in.
- **Document Summaries:** Extract text from PDF and DOCX files and generate AI summaries.
- **Handwriting OCR:** Convert handwritten content into digital text.
- **Practice Quizzes:** Generate multiple-choice questions using AI.
- **Performance Tracking:** Keep track of quiz performance totals.
- **Personalization:** Profile management, profile images, themes, and settings.

*AI summaries and quiz generation require a separately deployed backend.*

## 🛠️ Tech Stack

- **Framework:** Flutter / Dart
- **Backend services:** Firebase Authentication, Cloud Firestore, Firebase Storage
- **AI integration:** Backend API configured through `AI_PROXY_URL`
- **Document processing:** PDF/DOCX text extraction and handwriting OCR

## 🚀 Getting Started

### Prerequisites

- Flutter SDK compatible with Dart `^3.6.0`
- Android Studio and Android SDK, or Xcode for iOS development
- A configured Firebase project
- A deployed AI backend for AI-powered features

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/MHGhost/Imtihaan.git
   cd Imtihaan
   ```
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Configure Firebase for your target platform and enable the required authentication, Firestore, and Storage services.
4. Review and deploy the Firebase security rules using the Firebase CLI and an authorized project account:
   ```
   firebase deploy --only firestore:rules,storage
   ```
5. Run the application:
   ```
   flutter run
   ```
6. To enable AI features, configure your deployed backend URL at build time:
   ```bash
   flutter run --dart-define=AI_PROXY_URL=https://your-backend.example/api/ai
   ```
   Replace the example URL with your actual backend endpoint. Keep provider API keys on the backend, never inside the Flutter app.

## 🔒 Security & Release Notes

Before a production release:

- Replace the template application ID `com.example.imtihaan` with your production identifier and update Firebase configuration.
- Review and deploy Firebase security rules.
- Finalize the privacy notice and Terms of Service.
- Secure the AI backend with authentication, rate limiting, and input validation.
- Configure release signing and review data retention practices.
- Add automated tests for the app's main features.

## 📬 Contact

For privacy and support inquiries: [**safdarhamza115@gmail.com**](mailto:safdarhamza115@gmail.com)

## 📄 License

No license has been selected yet.
