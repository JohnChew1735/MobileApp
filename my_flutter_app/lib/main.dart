import 'package:flutter/material.dart';
import 'dart:developer';
import "gamescreen_3x3_2players.dart";
import "gamescreen_4x4_2players.dart";
import "gamescreen_3x3_1player.dart";
import "gamescreen_4x4_1player.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: const ModeSelection(),
    );
  }
}

class ModeSelection extends StatefulWidget {
  const ModeSelection({super.key});

  @override
  ModeSelectionState createState() => ModeSelectionState();
}

class ModeSelectionState extends State<ModeSelection> {
  String selectedPlayerMode = "Not selected";
  String selectedGridSize = "Not selected";
  bool isLoading = false;

  void _selectPlayerMode(String mode) {
    setState(() {
      selectedPlayerMode = mode;
    });
    log("Selected Player Mode: $mode");
  }

  void _selectGridSize(String grid) {
    setState(() {
      selectedGridSize = grid;
    });
    log("Selected Grid Size: $grid");
  }

  void _startGame() {
    if (selectedGridSize == "Not selected" &&
        selectedPlayerMode == "Not selected") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a player mode and grid size!"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (selectedGridSize == "Not selected") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a grid size."),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (selectedPlayerMode == "Not selected") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a player mode."),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (selectedGridSize.trim().toLowerCase() == "3x3 grid" &&
        selectedPlayerMode.trim().toLowerCase() == "2 players") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => GameScreen3x3Twoplayers(
                playerMode: selectedPlayerMode,
                gridSize: selectedGridSize,
              ),
        ),
      );
    } else if (selectedGridSize.trim().toLowerCase() == "4x4 grid" &&
        selectedPlayerMode.trim().toLowerCase() == "2 players") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => GameScreen4x4Twoplayers(
                playerMode: selectedPlayerMode,
                gridSize: selectedGridSize,
              ),
        ),
      );
    } else if (selectedGridSize.trim().toLowerCase() == "3x3 grid" &&
        selectedPlayerMode.trim().toLowerCase() == "1 player") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => GameScreen3x3Oneplayer(
                playerMode: selectedPlayerMode,
                gridSize: selectedGridSize,
              ),
        ),
      );
    } else if (selectedGridSize.trim().toLowerCase() == "4x4 grid" &&
        selectedPlayerMode.trim().toLowerCase() == "1 player") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => GameScreen4x4Oneplayer(
                playerMode: selectedPlayerMode,
                gridSize: selectedGridSize,
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error!"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Tic Tac Toe",
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://static.vecteezy.com/system/resources/previews/004/532/221/original/tic-tac-toe-seamless-background-on-dark-blue-illustration-vector.jpg",
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withAlpha(150), // Adjust the opacity (0.0 to 1.0)
              BlendMode.lighten, // Lightens dark areas
            ),
          ),
        ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Please select number of players.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _selectPlayerMode("1 Player"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                child: const Text(
                  "1 player",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectPlayerMode("2 Players"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                child: const Text(
                  "2 players",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Selected players: $selectedPlayerMode",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 100),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Text(
                  "Please select number of grid.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _selectGridSize("3x3 grid"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                child: const Text(
                  "3x3 grid",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectGridSize("4x4 grid"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                child: const Text(
                  "4x4 grid",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Selected grid size: $selectedGridSize",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                child: const Text(
                  "Start",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
