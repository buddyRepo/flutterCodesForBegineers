import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../constants.dart'; //define array (wordList) in constant file

class WordGuessingGame extends StatefulWidget {
  @override
  _WordGuessingGameState createState() => _WordGuessingGameState();
}

class _WordGuessingGameState extends State<WordGuessingGame> {
  late String word;
  late List<String> options;
  late String correctOption;
  int score = 0;
  late String wordToDisplay;

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  String replaceCharWithUnderscore(String original, int index) {
    if (index >= 0 && index < original.length) {
      List<String> charList = original.split('');
      charList[index] = '_';
      return charList.join('');
    } else {
      return original;
    }
  }

  void generateQuestion() {
    word = wordList[Random().nextInt(wordList.length)];
    int emptyIndex = Random().nextInt(word.length);
    options = List.generate(4, (index) {
      if (index == 0) {
        return word[emptyIndex];
      } else {
        return generateRandomAlphabet();
      }
    });
    correctOption = word[emptyIndex];
    wordToDisplay = replaceCharWithUnderscore(word, emptyIndex);
    options.shuffle();
  }

  String generateRandomAlphabet() {
    int randomCharCode = Random().nextInt(26) + 'A'.codeUnitAt(0);
    return String.fromCharCode(randomCharCode);
  }

  void checkAnswer(String selectedOption) {
    if (selectedOption == correctOption) {
      setState(() {
        score++;
      });
    } else {
      showGameOverDialog();
    }
    generateQuestion();
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
    });
    generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Guessing Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Score: $score',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                'Complete the word:',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              Text(
                wordToDisplay,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.0,
                runSpacing: 10.0,
                children: options.map((option) {
                  return ElevatedButton(
                    onPressed: () {
                      checkAnswer(option);
                      AudioPlayer()
                          .play(AssetSource('audios/game_button_click.mp3'));
                    },
                    child: Text(option),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
