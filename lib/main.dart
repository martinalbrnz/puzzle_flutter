import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Puzzle App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Puzzle'),
        ),
        body: const Puzzle(),
      ),
    );
  }
}

class Puzzle extends StatefulWidget {
  const Puzzle({Key? key}) : super(key: key);

  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  bool completed = false;
  int width = 4;
  int height = 4;
  List puzzle = [];
  List solution = [];
  int current = 0;

  @override
  void initState() {
    super.initState();
    createPuzzle();
    current = puzzle.length - 1;
    puzzle[current] = "_";
    solution = [...puzzle];
    shufflePuzzle();
  }

  void createPuzzle() {
    int identifier = 0;
    for (var i = 0; i < height; i++) {
      for (var j = 0; j < width; j++) {
        puzzle.add("$identifier");
        identifier++;
      }
    }
  }

  void shufflePuzzle() {
    puzzle.removeLast();
    puzzle.shuffle();
    puzzle.shuffle();
    puzzle.add("_");
  }

  void isAdyacent(tapped) {
    if (current + width == tapped ||
        current - width == tapped ||
        (current + 1 == tapped && current % width < tapped % width) ||
        (current - 1 == tapped && current % width > tapped % width)) {
      swapPlaces(tapped);
    }
  }

  void swapPlaces(tapped) {
    setState(() {
      puzzle[current] = puzzle[tapped];
      puzzle[tapped] = "_";
      current = tapped;
    });
    isCompleted();
  }

  void isCompleted() {
    if (listEquals(solution, puzzle)) {
      setState(() {
        completed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (completed) {
      return const Center(child: Text("COMPLETED!!! YAY!!!"));
    }
    return Center(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width,
            childAspectRatio: 1.0,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: puzzle.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => isAdyacent(index),
              child: Container(
                color: puzzle[index] == "_" ? Colors.grey[300] : Colors.blue,
                child: Center(
                  child: Text("${puzzle[index]}"),
                ),
              ),
            );
          }),
    );
  }
}
