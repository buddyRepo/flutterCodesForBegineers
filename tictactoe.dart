import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));

  String currentPlayer = 'X';
  Color getCellColor(int row, int col) {
    if (board[row][col] == 'X') {
      return Colors.blue; 
    } else if (board[row][col] == 'O') {
      return Colors.red;
    } else {
      return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current Player: $currentPlayer',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.all(10),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                int row = index ~/ 3;
                int col = index % 3;

                return GestureDetector(
                  onTap: () {
                    if (board[row][col].isEmpty) {
                      setState(() {
                        board[row][col] = currentPlayer;
                        if (checkWinner(row, col)) {
                          AudioPlayer()
                              .play(AssetSource('audios/game_win.mp3'));
                          showWinDialog(context, currentPlayer, false);
                        } else if (isBoardFull()) {
                          AudioPlayer()
                              .play(AssetSource('audios/game_draw.mp3'));
                          showWinDialog(context, currentPlayer, true);
                        } else {
                          AudioPlayer().play(
                              AssetSource('audios/game_button_click.mp3'));
                          currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
                        }
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius:
                          BorderRadius.circular(16), // Add rounded corners
                      color: getCellColor(row, col),
                    ),
                    child: Center(
                      child: Text(
                        board[row][col],
                        style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white), // Set text color
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                resetGame();
              });
            },
            child: Text('Reset Game'),
          ),
        ],
      ),
    );
  }

  bool checkWinner(int row, int col) {
    // Check row
    if (board[row].every((element) => element == currentPlayer)) {
      return true;
    }

    // Check column
    if (board.every((element) => element[col] == currentPlayer)) {
      return true;
    }

    // Check diagonals
    if ((row == col &&
            List.generate(3, (index) => board[index][index])
                .every((element) => element == currentPlayer)) ||
        (row + col == 2 &&
            List.generate(3, (index) => board[index][2 - index])
                .every((element) => element == currentPlayer))) {
      return true;
    }

    return false;
  }

  void resetGame() {
    board = List.generate(3, (_) => List.filled(3, ''));
    currentPlayer = 'X';
  }

  void showWinDialog(BuildContext context, String winner, bool draw) {
    String message;
    message = 'Player $winner wins!';
    if (draw) {
      message = 'It\'s a Draw!';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Game Over',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  resetGame();
                });
              },
              child: Text('Restart Game'),
            ),
          ],
        );
      },
    );
  }

  bool isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          return false; 
        }
      }
    }
    return true; 
  }
}
