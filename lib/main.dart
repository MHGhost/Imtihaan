import 'package:flutter/material.dart';
import 'package:imtihaan/CategoryScreens/feedback.dart';
import 'package:imtihaan/CategoryScreens/handwriting_to_notes.dart';
import 'package:imtihaan/CategoryScreens/help_support.dart';
import 'package:imtihaan/CategoryScreens/lecture_summary.dart';
import 'package:imtihaan/CategoryScreens/mock_exams.dart';
import 'package:imtihaan/CategoryScreens/notification_settings.dart';
import 'package:imtihaan/CategoryScreens/privacy.dart';
import 'package:imtihaan/CategoryScreens/your_performance.dart';
import 'package:imtihaan/my_work_page.dart';
import 'package:imtihaan/profile_page.dart';
import 'package:imtihaan/setting_page.dart';
import 'package:imtihaan/sign_in.dart';
import 'package:imtihaan/sign_up.dart';
import 'package:imtihaan/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'SettingUi/theme_notifier.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: Wrapper(),
        routes: {
          '/signin': (context) => SignIn(),
          '/signup': (context) => SignUp(),
          '/profile': (context) => const ProfilePage(),
          '/setting': (context) => const SettingPage(),
          '/my_work': (context) => const MyWorkPage(),
          '/handwriting_to_notes': (context) => const HandwritingToNotesScreen(),
          '/lecture_summary': (context) => const LectureSummaryUploadScreen(),
          '/your_performance': (context) => const PerformanceScreen(),
          '/mock_exams': (context) => const MockExamSimulatorScreen(),
          '/help_support': (context) => const HelpSupportScreen(),
          '/notification_settings': (context) => const NotificationScreen(),
          '/feedback': (context) => FeedbackForm(),
          '/privacy': (context) => const PrivacyScreen(),
        },
      );
    });
  }
}
