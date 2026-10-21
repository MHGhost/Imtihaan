
import 'package:flutter/material.dart';
import 'package:imtihaan/CategoryScreens/feedback.dart';
import 'package:imtihaan/CategoryScreens/help_support.dart';
import 'package:imtihaan/CategoryScreens/notification_settings.dart';
import 'package:imtihaan/CategoryScreens/privacy.dart';
import 'package:imtihaan/SettingUi/section_tile.dart';
import 'package:imtihaan/SettingUi/settings_tile.dart';
import 'package:imtihaan/SettingUi/theme_notifier.dart';
import 'package:imtihaan/sign_in.dart';
import 'package:provider/provider.dart';

import 'Services/auth_services.dart';
import 'SettingUi/setting_tile_switch.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
        children: [
          const SizedBox(height: 5),
          // Appearance Section
          const SectionTitle(title: "APPEARANCE"),
          Consumer<ThemeNotifier>(
              builder: (context, themeNotifier,child) {
                return SettingsTileWithSwitch(
                  icon: Icons.dark_mode_outlined,
                  title: "Night mode",
                  value: themeNotifier.isDarkMode,
                  onChanged: (bool value) {
                    // Handle switch toggle
                    themeNotifier.toggleTheme();
                  },
                );
              }
          ),
          const SizedBox(height: 5),
          // Other Settings Section
          const SectionTitle(title: "OTHER SETTINGS"),
          SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy",
            trailingIcon: Icons.warning_amber_outlined,
            onTap: () {
              // Handle navigation
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyScreen()),
              );
            },
          ),
          SettingsTile(
            icon: Icons.notifications_outlined,
            title: "Notification",
            onTap: () {
              // Handle navigation
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
          SettingsTile(
            icon: Icons.help_outline,
            title: "Help & Support",
            onTap: () {
              // Handle navigation
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpSupportScreen()),
              );
            },
          ),
          SettingsTile(
            icon: Icons.feedback_outlined,
            title: "Feedback",
            onTap: () {
              // Handle navigation
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackForm()),
              );
            },
          ),
          SettingsTile(
            icon: Icons.logout,
            title: "Logout",
            onTap: () async {
              // Handle navigation
              await AuthServices().signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
                    (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}
