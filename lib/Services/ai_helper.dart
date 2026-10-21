import 'dart:convert';

import 'package:http/http.dart' as http;

/// Calls the application's trusted AI backend. Never place an OpenAI API key
/// in a Flutter app; mobile binaries can be inspected and the key extracted.
class OpenAIHelper {
  /// Configure with --dart-define=AI_PROXY_URL=https://your-backend.example/api/ai
  static const String apiUrl = String.fromEnvironment('AI_PROXY_URL');

  static Uri get _endpoint {
    if (apiUrl.isEmpty) {
      throw StateError(
        'AI features are not configured. Set AI_PROXY_URL to your secure AI backend.',
      );
    }
    return Uri.parse(apiUrl);
  }

  static Future<String> generateSummary(String inputText) async {
    final response = await http.post(
      _endpoint,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'action': 'summary', 'text': inputText}),
    );

    if (response.statusCode != 200) {
      throw Exception('Summary service failed (${response.statusCode}).');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['result'] as String).trim();
  }

  static Future<List<Map<String, dynamic>>> generateMCQs(String text) async {
    final response = await http.post(
      _endpoint,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'action': 'mcqs', 'text': text}),
    );

    if (response.statusCode != 200) {
      throw Exception('Quiz service failed (${response.statusCode}).');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final result = data['result'];
    if (result is! List) {
      throw const FormatException('Quiz service returned an invalid question list.');
    }
    return result.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  // Retained for callers that need to normalize JSON returned as plain text.
  static List<Map<String, dynamic>> parseMCQsFromAIOutput(String output) {
    final sanitized = output
        .replaceFirst(RegExp(r'^\s*```(?:json)?\s*'), '')
        .replaceFirst(RegExp(r'\s*```\s*$'), '')
        .trim();
    final parsed = jsonDecode(sanitized);
    if (parsed is! List) {
      throw const FormatException('Expected a JSON array of questions.');
    }
    return parsed.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }
}
