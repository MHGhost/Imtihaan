import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {

  double correctAnswer = 0;
  double incorrectAnswer = 0;

  @override
  void initState() {
    super.initState();
    loadQuizResults();
  }

  // Load quiz results from SharedPreferences
  Future<void> loadQuizResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? quizResults = prefs.getStringList("quiz_results");

    if (quizResults != null) {
      double totalCorrect = 0;
      double totalQuestions = 0;

      // Calculate the total correct answers and total questions
      for (var result in quizResults) {
        Map<String, dynamic> resultMap = jsonDecode(result);
        totalCorrect += resultMap['correctAnswers'];
        totalQuestions += resultMap['totalQuestions'];
      }

      setState(() {
        correctAnswer = totalCorrect;
        incorrectAnswer = totalQuestions - totalCorrect;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Your Performance",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // pie chart
            SizedBox(
              height: 400,
              child: PieChart(PieChartData(
                sections: showingSections(),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 70
              )
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                legendItem(Colors.blue, "Right Answer"),
                const SizedBox(width: 20),
                legendItem(Colors.yellow, "Wrong Answer"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                answerCard("Right Answers", correctAnswer.toInt(), Colors.blue.shade100, Colors.blue),
                answerCard("Wrong Answers", incorrectAnswer.toInt(), Colors.orange.shade100, Colors.orange),
              ],
            )
          ],
        )
      ),
    );
  }

  // Widget for legend items
  Widget legendItem(Color color, String text) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  // Widget for answer cards
  Widget answerCard(String title, int count, Color bgColor, Color textColor) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {

    return [
      PieChartSectionData(
        value: correctAnswer,
        title: '${correctAnswer.toInt()}',
        color: Colors.blue
      ),
      PieChartSectionData(
        value: incorrectAnswer,
        title: '${incorrectAnswer.toInt()}',
        color: Colors.yellow
      )
    ];

  }
}
