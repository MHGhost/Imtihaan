import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> notifications = [
      {'title': 'App Update', 'body': 'A new version of the app is available. Please update to the latest version.'},
      {'title': 'Promotion', 'body': 'Are you ready for a new test! open Imtihaan to see how you are doing in your course by giving a mock exam.'},
      {'title': 'Reminder', 'body': 'Don\'t forget to study today.'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text(notifications[index]['title']!),
            subtitle: Text(notifications[index]['body']!),
          );
        },
      ),
    );
  }
}
