import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen3x3Oneplayer extends StatefulWidget {
  final String playerMode;
  final String gridSize;

  const GameScreen3x3Oneplayer({
    super.key,
    required this.playerMode,
    required this.gridSize,
  });

  @override
  State<GameScreen3x3Oneplayer> createState() => _GameScreen3x3OneplayerState();
}

class _GameScreen3x3OneplayerState extends State<GameScreen3x3Oneplayer> {
  List<String> gridValues = List.filled(9, "");
  bool isXturn = true;
  String winner = "";
  bool isAiThinking = false;
  late bool isSinglePlayer;
  List<int> winningTiles = [];
  List<int> moveHistory = [];

  @override
  void initState() {
    super.initState();
    isSinglePlayer = true; // Enable AI mode
  }

  void _handleTap(int index) {
    if (gridValues[index].isEmpty &&
        winner.isEmpty &&
        isXturn &&
        !isAiThinking) {
      setState(() {
        gridValues[index] = "X"; // Player move
        isXturn = false;
        moveHistory.add(index);
      });
      _checkWinner();

      if (isSinglePlayer && !isXturn && winner.isEmpty) {
        isAiThinking = true; // Prevent player from interacting
        Future.delayed(const Duration(milliseconds: 500), () {
          _aiMove();
          isAiThinking = false; // Re-enable player moves
        });
      }
    }
  }

  void _undoMove() {
    if (moveHistory.isNotEmpty) {
      setState(() {
        int lastMoveIndex = moveHistory.removeLast();
        gridValues[lastMoveIndex] = "";
        if (moveHistory.isNotEmpty) {
          setState(() {
            int lastMoveIndex = moveHistory.removeLast();
            gridValues[lastMoveIndex] = "";
          });
        }

        isXturn = true;
      });
    }
  }

  void _aiMove() {
    int? bestMove;

    // Check if AI can win in one move
    for (int i = 0; i < gridValues.length; i++) {
      if (gridValues[i].isEmpty) {
        gridValues[i] = "O";
        if (_checkIfWinningMove("O")) {
          bestMove = i;
          gridValues[i] = ""; // Reset after checking
          break;
        }
        gridValues[i] = ""; // Reset
      }
    }

    // Check if AI needs to block player's winning move
    if (bestMove == null) {
      for (int i = 0; i < gridValues.length; i++) {
        if (gridValues[i].isEmpty) {
          gridValues[i] = "X";
          if (_checkIfWinningMove("X")) {
            bestMove = i;
          }
          gridValues[i] = ""; // Reset
        }
      }
    }

    // Pick a random available move if no winning or blocking move
    if (bestMove == null) {
      List<int> emptySpots = [];
      for (int i = 0; i < gridValues.length; i++) {
        if (gridValues[i].isEmpty) emptySpots.add(i);
      }
      if (emptySpots.isNotEmpty) {
        bestMove = emptySpots[Random().nextInt(emptySpots.length)];
      }
    }

    // Perform AI move
    if (bestMove != null) {
      setState(() {
        gridValues[bestMove!] = "O";
        moveHistory.add(bestMove);
        isXturn = true; // Switch turn back to player
      });
      _checkWinner();
    }
  }

  bool _checkIfWinningMove(String player) {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      String a = gridValues[pattern[0]];
      String b = gridValues[pattern[1]];
      String c = gridValues[pattern[2]];

      if ((a == player && b == player && c.isEmpty) ||
          (a == player && c == player && b.isEmpty) ||
          (b == player && c == player && a.isEmpty)) {
        return true;
      }
    }
    return false;
  }

  void _checkWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (gridValues[pattern[0]].isNotEmpty &&
          gridValues[pattern[0]] == gridValues[pattern[1]] &&
          gridValues[pattern[1]] == gridValues[pattern[2]]) {
        setState(() {
          winner = gridValues[pattern[0]];
          winningTiles = pattern;
        });
        Future.delayed(Duration(milliseconds: 500), () {
          _showWinnerDialog(winner);
        });

        return;
      }
    }
    if (!gridValues.contains("") && winner.isEmpty) {
      Future.delayed(Duration(milliseconds: 500), () {
        _showWinnerDialog("Draw");
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

  void _resetGame() {
    setState(() {
      gridValues = List.filled(9, "");
      isXturn = true;
      winner = "";
      winningTiles = [];
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
            Text(
              "Player Mode: ${widget.playerMode}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Grid Size: ${widget.gridSize}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            winningTiles.contains(index)
                                ? Colors.red
                                : Colors.white,
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          gridValues[index],
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
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
              onPressed: () => Navigator.pop(context),
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
