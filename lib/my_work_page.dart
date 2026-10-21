import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Services/preferences_helper.dart';

class MyWorkPage extends StatefulWidget {
  const MyWorkPage({super.key});

  @override
  State<MyWorkPage> createState() => _MyWorkPageState();
}

class _MyWorkPageState extends State<MyWorkPage> {
  List<Map<String, dynamic>> historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final List<Map<String, dynamic>> data = await _getAllHistory();
    setState(() {
      historyList = data.reversed.toList(); // Show latest first
    });
  }

  Future<List<Map<String, dynamic>>> _getAllHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedHistory = prefs.getStringList("history");

    if (storedHistory != null) {
      return storedHistory.map((entry) {
        List<String> parts = entry.split('|');
        return {
          "timestamp": _formatTimestamp(parts[0]),
          "type": parts[1],
          "content": parts[2],
        };
      }).toList();
    } else {
      return [];
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime); // Proper format
    } catch (e) {
      return "Invalid Date";
    }
  }

  // Function to clear history using PreferencesHelper
  Future<void> _clearHistory() async {
    await PreferencesHelper.clearHistory(); // Call to PreferencesHelper to clear the history
    setState(() {
      historyList.clear(); // Update UI to reflect cleared history
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (historyList.isNotEmpty)
            Padding(
                padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: _clearHistory,
                    child: const Text(
                      "Clear History",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    )
                ),
              ),
            ),
          Expanded(
              child: historyList.isEmpty
                  ? const Center(child: Text("No data found"))
                  : ListView.builder(
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final entry = historyList[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          entry["type"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(entry["content"],
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: Text(entry["timestamp"],
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        onTap: () {
                          // Navigate to details screen when tapped
                        },
                        onLongPress: () {
                          // Show options to copy or share text
                          _showOptionsDialog(entry["content"]);
                        },
                      ),
                    );
                  }
              )
          )
        ],
      )
    );
  }

  // Show dialog for Copy & Share options
  void _showOptionsDialog(String content) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text("Copy Text"),
              onTap: () {
                _copyToClipboard(content);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Share Text"),
              onTap: () {
                _shareText(content);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Function to copy text to clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard")),
    );
  }

  // Function to share text
  void _shareText(String text) {
    Share.share(text);
  }
}
