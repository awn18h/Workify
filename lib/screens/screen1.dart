import 'package:flutter/material.dart';

import 'screen2.dart';

class QuestionScreenOne extends StatefulWidget {
  const QuestionScreenOne({super.key});

  @override
  State<QuestionScreenOne> createState() {
    return _QuestionScreenOneState();
  }
}

class _QuestionScreenOneState extends State<QuestionScreenOne> {
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is the capital of Jordan?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            RadioListTile<String>(
              title: const Text('Amman'),
              value: 'Amman',
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Irbid'),
              value: 'Irbid',
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Aqaba'),
              value: 'Aqaba',
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedAnswer == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuestionScreenTwo(),
                          ),
                        );
                      },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
