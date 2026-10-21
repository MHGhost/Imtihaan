import 'package:flutter/material.dart';

import '../app_config.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildFaqItem(
            'How do I change my password?',
            'Password changes are not available in the app yet. Use your account provider’s password reset flow.',
          ),
          _buildFaqItem(
            'How can I contact customer support?',
            'Email ${AppConfig.supportEmail} for support.',
          ),
          _buildFaqItem(
            'How do I update my profile information?',
            'To update your profile information, navigate to settings and click on "Personal Information" Make the necessary changes and save.',
          ),
          SizedBox(height: 20),
          Text(
            'Contact Support',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: const Text('Email support'),
            subtitle: SelectableText(AppConfig.supportEmail),
          ),
          SizedBox(height: 20),
          Text(
            'Troubleshooting Tips',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildTipItem(
            'App is crashing or not responding?',
            'Try restarting the app. If the issue persists, reinstall the app from the app store.',
          ),
          _buildTipItem(
            'Cannot connect to the internet?',
            'Ensure that your device is connected to a stable internet connection. Check your Wi-Fi settings or contact your internet service provider.',
          ),
          _buildTipItem(
            'Experiencing slow performance?',
            'Close unused apps running in the background. Clear the app cache from the device settings.',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(answer),
        ),
      ],
    );
  }

  Widget _buildTipItem(String title, String description) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
    );
  }
}
