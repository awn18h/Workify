import 'package:flutter/material.dart';
import 'package:workify_prototype/loginscreen/signin_screen.dart';

class QuestionScreenTwo extends StatefulWidget {
  const QuestionScreenTwo({super.key});

  @override
  State<QuestionScreenTwo> createState() {
    return _QuestionScreenTwoState();
  }
}

class _QuestionScreenTwoState extends State<QuestionScreenTwo> {
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flutter uses which programming language?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            RadioListTile<String>(
              title: const Text('Java'),
              value: 'Java',
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Dart'),
              value: 'Dart',
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Python'),
              value: 'Python',
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
                        print('Answer: $selectedAnswer');

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                child: const Text('Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
