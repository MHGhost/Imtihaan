import 'package:flutter/material.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  int _selectedEmoji = 1;
  final List<bool> _selectedTags = [false, false, false, false, false];
  double _rating = 0.0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEmoji(0, Icons.sentiment_very_dissatisfied),
                _buildEmoji(1, Icons.sentiment_neutral),
                _buildEmoji(2, Icons.sentiment_very_satisfied),
              ],
            ),
            SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              children: [
                _buildTag(0, 'Service'),
                _buildTag(1, 'Tests are easy'),
                _buildTag(2, 'Tests are Difficult'),
                _buildTag(3, 'Accurate Results'),
                _buildTag(4, 'Whold you tell others about this app'),
              ],
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Care to share more',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Rating:'),
                SizedBox(width: 8.0),
                _buildStarRating(),
              ],
            ),
            SizedBox(height: 16.0),
            const Center(
              child: Text('Feedback submission is not configured in this build.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmoji(int index, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEmoji = index;
        });
      },
      child: Icon(
        icon,
        color: _selectedEmoji == index ? Colors.blue : Colors.grey,
        size: 40.0,
      ),
    );
  }

  Widget _buildTag(int index, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedTags[index],
      onSelected: (selected) {
        setState(() {
          _selectedTags[index] = selected;
        });
      },
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1.0;
            });
          },
        );
      }),
    );
  }
}
