// math_quiz_screen.dart

import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MathQuizScreen extends StatefulWidget {
  @override
  _MathQuizScreenState createState() => _MathQuizScreenState();
}

class _MathQuizScreenState extends State<MathQuizScreen> {
  late int num1, num2;
  late String operation;
  List<int> options = [];
  late int correctAnswer;
  int score = 0;
  int difficulty = 1;

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    // Generate random numbers and operation
    num1 = Random().nextInt(10 * difficulty);
    num2 = Random().nextInt(10 * difficulty);
    operation = ['+', '-', '×', '÷'][Random().nextInt(4)];

    // Special case for division to ensure numbers are divisible
    if (operation == '÷') {
      // Generate random divisor
      int divisor;
      do {
        divisor =
            Random().nextInt(10 * difficulty) + 1; // Ensure divisor is not zero
      } while (num1 % divisor != 0 || divisor == 1);

      // Calculate the dividend
      num2 = divisor;
      num1 = num1 * divisor;
    }

    // Calculate correct answer
    switch (operation) {
      case '+':
        correctAnswer = num1 + num2;
        break;
      case '-':
        correctAnswer = num1 - num2;
        break;
      case '×':
        correctAnswer = num1 * num2;
        break;
      case '÷':
        correctAnswer = num1 ~/ num2; // Use integer division for exact division
        break;
    }

    // Initialize options before using them
    options = List.generate(4, (index) {
      if (index == 0) {
        return correctAnswer;
      } else {
        int randomOption;
        do {
          randomOption = Random().nextInt(20 * difficulty);
        } while (
            randomOption == correctAnswer || options.contains(randomOption));
        return randomOption;
      }
    });

    // Shuffle options
    options.shuffle();
  }

  void checkAnswer(int selectedAnswer) {
    if (selectedAnswer == correctAnswer) {
      // User answered correctly, increase score and difficulty
      setState(() {
        score++;
        if (score % 10 == 0) {
          difficulty++;
        }
      });
      // Generate the next question
      generateQuestion();
    } else {
      // User answered incorrectly, end the game
      showGameOverDialog();
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          content: Text('Your Score: $score'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      difficulty = 1;
    });
    generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math Hunt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Score: $score',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '$num1 $operation $num2 = ?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    AudioPlayer()
                        .play(AssetSource('audios/game_button_click.mp3'));
                    checkAnswer(options[0]);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20), // Adjust padding as needed
                  ),
                  child: Text(
                    options[0].toString(),
                    style:
                        TextStyle(fontSize: 18), // Adjust font size as needed
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    AudioPlayer()
                        .play(AssetSource('audios/game_button_click.mp3'));
                    checkAnswer(options[1]);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20), // Adjust padding as needed
                  ),
                  child: Text(
                    options[1].toString(),
                    style:
                        TextStyle(fontSize: 18), // Adjust font size as needed
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    AudioPlayer()
                        .play(AssetSource('audios/game_button_click.mp3'));
                    checkAnswer(options[2]);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20), // Adjust padding as needed
                  ),
                  child: Text(
                    options[2].toString(),
                    style:
                        TextStyle(fontSize: 18), // Adjust font size as needed
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    AudioPlayer()
                        .play(AssetSource('audios/game_button_click.mp3'));
                    checkAnswer(options[3]);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20), // Adjust padding as needed
                  ),
                  child: Text(
                    options[3].toString(),
                    style:
                        TextStyle(fontSize: 18), // Adjust font size as needed
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
