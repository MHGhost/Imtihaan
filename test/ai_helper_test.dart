import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imtihaan/Services/ai_helper.dart';
import 'package:imtihaan/CategoryScreens/privacy.dart';
import 'package:imtihaan/CategoryScreens/help_support.dart';
import 'package:imtihaan/app_config.dart';

void main() {
  group('OpenAIHelper.parseMCQsFromAIOutput', () {
    test('parses a JSON array of questions', () {
      final result = OpenAIHelper.parseMCQsFromAIOutput(
        '[{"question":"Q?","options":["A","B","C","D"],"answer":"A"}]',
      );

      expect(result, hasLength(1));
      expect(result.single['question'], 'Q?');
      expect(result.single['answer'], 'A');
    });

    test('parses JSON wrapped in a Markdown code fence', () {
      final result = OpenAIHelper.parseMCQsFromAIOutput(
        '```json\n[{"question":"Q?","options":[],"answer":"A"}]\n```',
      );

      expect(result.single['question'], 'Q?');
    });

    test('rejects output that is not a JSON array', () {
      expect(
        () => OpenAIHelper.parseMCQsFromAIOutput('{"question":"Q?"}'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  testWidgets('privacy notice shows the configured contact and AI data flow',
    (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrivacyScreen()));

    expect(find.text('Privacy Notice — Development Draft'), findsOneWidget);
    expect(AppConfig.supportEmail, 'safdarhamza115@gmail.com');
  });

  testWidgets('support screen shows the configured email', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HelpSupportScreen()));

    expect(find.text('safdarhamza115@gmail.com'), findsOneWidget);
  });
}
