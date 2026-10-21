
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {

  static Future<void> saveToHistory(String content, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList("history") ?? [];

    String timestamp = DateTime.now().toString();
    String formattedEntry = "$timestamp|$type|$content"; // Format: timestamp|type|content

    history.add(formattedEntry);
    await prefs.setStringList("history", history);
  }

  /// Retrieve saved history
  static Future<List<Map<String, String>>> getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedHistory = prefs.getStringList("history") ?? [];

    return savedHistory.map((entry) {
      List<String> splitData = entry.split("|");
      return {
        "timestamp": splitData[0], // ISO timestamp
        "type": splitData[1], // Either "summary" or "notes"
        "content": splitData[2],
      };
    }).toList();
  }

  static Future<void> saveQuizResult(int totalQuestions, int correctAnswers, String documentName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> history = prefs.getStringList("quiz_results") ?? [];

    // Create a map for the result data
    Map<String, dynamic> resultData = {
      'documentName': documentName,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
    };

    // Convert the map to a JSON string
    String resultJson = jsonEncode(resultData);

    // Add the result to the history
    history.add(resultJson);

    // Save the updated history back to SharedPreferences
    await prefs.setStringList("quiz_results", history);
  }

  // Create a method to retrieve all saved quiz results
  static Future<List<Map<String, dynamic>>> getQuizResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList("quiz_results");

    if (history != null) {
      return history
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();
    } else {
      return [];
    }
  }

  /// Clear all history (optional method)
  static Future<void> clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("history");
  }
}