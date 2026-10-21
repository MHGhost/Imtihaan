import 'package:flutter/material.dart';

import '../Services/preferences_helper.dart';
import '../home_page.dart';

class MCQQuizScreen extends StatefulWidget {
  final String fileName;
  final List<Map<String, dynamic>> mcqs;

  const MCQQuizScreen({super.key, required this.fileName, required this.mcqs});

  @override
  State<MCQQuizScreen> createState() => _MCQQuizScreenState();
}

class _MCQQuizScreenState extends State<MCQQuizScreen> {
  final Map<int, String> selectedAnswers = {};

  void submitAnswers() async {

    int correctAnswers = 0;

    for (int i = 0; i < widget.mcqs.length; i++) {
      final mcq = widget.mcqs[i];
      final correctAnswerText = mcq['answer'];  // Correct answer is now the text itself

      // Compare selected answer directly with the correct answer
      if (selectedAnswers[i] == correctAnswerText) {
        correctAnswers++;
      }
    }

    // Save the result to SharedPreferences
    await PreferencesHelper.saveQuizResult(
      widget.mcqs.length,      // Total questions
      correctAnswers,          // Correct answers
      widget.fileName,         // Use actual file name
    );

    // Show result dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Results"),
        content: Text(
          "You answered $correctAnswers out of ${widget.mcqs.length} questions correctly.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }



  @override
  void initState() {
    super.initState();
    debugPrint("MCQs: ${widget.mcqs}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: ListView.builder(
        itemCount: widget.mcqs.length,
        itemBuilder: (context, index) {
          final mcq = widget.mcqs[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Q${index + 1}: ${mcq['question']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  for (int i = 0; i < mcq['options'].length; i++)
                    RadioListTile<String>(
                      title: Text(mcq['options'][i]),
                      value: mcq['options'][i],
                      groupValue: selectedAnswers[index],
                      onChanged: (value) {
                        setState(() {
                          selectedAnswers[index] = value!;
                        });
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: selectedAnswers.length == widget.mcqs.length
              ? submitAnswers
              : null,
          child: const Text("Submit Answers"),
        ),
      ),
    );
  }
}
