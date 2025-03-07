import 'package:flutter/material.dart';

class GameScreen4x4Twoplayers extends StatefulWidget {
  final String playerMode;
  final String gridSize;

  const GameScreen4x4Twoplayers({
    super.key,
    required this.playerMode,
    required this.gridSize,
  });

  @override
  State<GameScreen4x4Twoplayers> createState() =>
      _GameScreen4x4TwoplayersState();
}

class _GameScreen4x4TwoplayersState extends State<GameScreen4x4Twoplayers> {
  List<String> gridValues = List.filled(16, "");
  bool isXturn = true;
  String winner = "";
  int xScore = 0;
  int oScore = 0;
  bool isGameOver = false;
  List<int> winningTiles = [];
  List<int> moveHistory = [];

  void _handleTap(int index) {
    if (gridValues[index].isEmpty) {
      setState(() {
        gridValues[index] = isXturn ? "X" : "O";
        isXturn = !isXturn;
        moveHistory.add(index);
      });
      _checkWinner();
    }
  }

  void _checkWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [1, 2, 3],
      [4, 5, 6],
      [5, 6, 7],
      [8, 9, 10],
      [9, 10, 11],
      [12, 13, 14],
      [13, 14, 15],
      [0, 4, 8],
      [4, 8, 12],
      [1, 5, 9],
      [5, 9, 13],
      [2, 6, 10],
      [6, 10, 14],
      [3, 7, 11],
      [7, 11, 15],
      [0, 5, 10],
      [5, 10, 15],
      [1, 6, 11],
      [4, 9, 14],
      [3, 6, 9],
      [6, 9, 12],
      [7, 10, 13],
      [2, 5, 8],
    ];

    for (var pattern in winPatterns) {
      String a = gridValues[pattern[0]];
      String b = gridValues[pattern[1]];
      String c = gridValues[pattern[2]];

      if (a.isNotEmpty && a == b && a == c) {
        setState(() {
          winner = a;
          winningTiles = pattern;
          isGameOver = true;
          if (winner == "X") {
            xScore++;
          } else if (winner == "O") {
            oScore++;
          }
        });

        Future.delayed(Duration(milliseconds: 500), () {
          _showWinnerDialog(a);
        });

        return;
      }
    }
    if (!gridValues.contains("")) {
      setState(() {
        isGameOver = true;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          _showWinnerDialog("Draw");
        }
      });
    }
  }

  void _showWinnerDialog(String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(result == "Draw" ? "Game Over" : "Winner!"),
          content: Text(
            result == "Draw" ? "It's a draw" : "Player $result wins!",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  void _undoMove() {
    if (moveHistory.isNotEmpty) {
      setState(() {
        int lastMoveIndex = moveHistory.removeLast();
        gridValues[lastMoveIndex] = "";
      });
    }
  }

  void _resetGame() {
    setState(() {
      gridValues = List.filled(16, "");
      isXturn = true;
      winner = "";
      winningTiles.clear();
      isGameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Game Screen",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "X Score: $xScore ",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(width: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "O Score: $oScore",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Text(
              "Player Mode: ${widget.playerMode}",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Grid Size: ${widget.gridSize}",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _undoMove,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: Text(
                "Undo",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 300,
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            winningTiles.contains(index)
                                ? Colors.red
                                : Colors.white,
                        border: Border.all(color: Colors.brown, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          gridValues[index],
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Go Back",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
