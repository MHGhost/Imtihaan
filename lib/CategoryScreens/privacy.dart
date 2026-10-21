import 'package:flutter/material.dart';

import '../app_config.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Notice'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Privacy Notice — Development Draft',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'This notice describes data handling visible in the current Imtihaan app. Review it against the final backend, AI provider, Firebase configuration, and applicable requirements before public release.',
          ),
          _section(
            'Account information',
            'When you create an account, the app uses Firebase Authentication for sign-in and stores your name, email address, and phone number in the Imtihaan Firebase project. Passwords are handled by Firebase Authentication and are not stored by the app. Profile images you upload are stored in Firebase Storage.',
          ),
          _section(
            'Study content and AI features',
            'Document files are selected and read on your device. To request a document summary or quiz, extracted document text and the requested operation are sent to the AI backend configured for the app. AI features are unavailable when no backend URL is configured. The backend and any AI provider it uses may process submitted text under their own service terms and retention settings. Do not submit content you are not allowed to share.',
          ),
          _section(
            'Local information',
            'Recognized handwriting text, generated summaries, and quiz score totals are stored on your device using local app preferences. They are not synced to the Imtihaan account by the current app. Clearing app data or uninstalling the app may remove this information.',
          ),
          _section(
            'Use, sharing, and retention',
            'Firebase processes account and profile data to provide sign-in, database, and image storage. Study text is shared with the configured AI backend only when you request a summary or quiz. Local history remains on the device until cleared or removed with app data. Retention for Firebase and AI backend data depends on the project and provider configuration.',
          ),
          _section(
            'Your choices and requests',
            'You can edit profile details in the app and clear local study history from My Work. The app does not currently provide an in-app account deletion flow. For privacy or account deletion requests, contact the address below.',
          ),
          _section(
            'Contact',
            'Privacy and support: ${AppConfig.supportEmail}',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  static Widget _section(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(fontSize: 16, height: 1.4)),
        ],
      ),
    );
  }
}
