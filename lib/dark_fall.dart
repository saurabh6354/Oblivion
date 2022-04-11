import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class LightsOutGame extends StatefulWidget {
  LightsOutGame({Key? key}) : super(key: key);

  @override
  _LightsOutGame createState() => _LightsOutGame();
}

class _LightsOutGame extends State<LightsOutGame> {
  // Number of possible states for each cell. For the standard lights out game,
  // it is 2 (on/off). Changing states is `(currentState + 1) % numValues`.
  final int numValues = 2;
  final int gridSize = 5;
  late List<List<int>> gridValues;

  @override
  void initState() {
    super.initState();
    _randomizeBoard();
  }

  // Purely random board generation is not valid as the board will not
  // always be solvable. Instead, clear the board and then either click or
  // don't click on each cell with a 50/50 probability. If we can get
  // to the end state by clicking, it can be solved.
  static List<List<int>> randomGridValues(int gridSize, int numValues) {
    var gridValues =
        new List.generate(gridSize, (_) => List.filled(gridSize, 0));

    var rand = Random();
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (rand.nextBool()) {
          clickCell(gridValues, i, j, gridSize, numValues);
        }
      }
    }
    return gridValues;
  }

  void _randomizeBoard() {
    setState(() {
      gridValues = randomGridValues(gridSize, numValues);
    });
  }

  // clickCell updates the input gridValues based on clicking at the specified
  // row and column.
  static void clickCell(List<List<int>> gridValues, int rowIndex, int colIndex,
      int gridSize, int numValues) {
    List<Point<int>> coords = [
      new Point(rowIndex, colIndex),
      new Point(rowIndex - 1, colIndex),
      new Point(rowIndex + 1, colIndex),
      new Point(rowIndex, colIndex - 1),
      new Point(rowIndex, colIndex + 1),
    ];

    coords.forEach((coord) {
      if ((coord.x < 0 || coord.y < 0) ||
          (coord.x >= gridSize || coord.y >= gridSize)) {
        // print("skipping at [$i,$j]");
        return;
      }
      // print("toggling at [$i,$j]");
      gridValues[coord.x][coord.y] =
          (gridValues[coord.x][coord.y] + 1) % numValues;
    });
  }

  void _clickCell(BuildContext context, int rowIndex, int colIndex) {
    setState(() {
      // print("Detected click at [$rowIndex,$colIndex]");
      clickCell(gridValues, rowIndex, colIndex, gridSize, numValues);

      if (gameComplete()) {
        print('game over!');
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
                  title: Text("Winner!"),
                  content: Text("Press OK to start a new game."),
                  actions: [
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        // print('pressed newgame button');
                        _randomizeBoard();
                        Navigator.of(context).pop(); // Dismiss the button.
                      },
                    ),
                  ],
                ));
      }
    });
  }

  bool gameComplete() {
    int value = gridValues[0][0];
    for (int i = 0; i < gridValues.length; i++) {
      for (int j = 0; j < gridValues[i].length; j++) {
        if (gridValues[i][j] != value) {
          return false;
        }
      }
    }
    return true;
  }

  Container buildCell(
      BuildContext context, int value, int rowIndex, int colIndex) {
    double minDimension = min(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    double cellDimensions = minDimension / gridSize * 0.9;

    Widget content;
    if (numValues == 2) {
      content = Container(
          decoration: BoxDecoration(
              color: (value == 0) ? Colors.black54 : Colors.white,
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.grey, width: 3),
              borderRadius: BorderRadius.all(Radius.zero)),
          width: cellDimensions,
          height: cellDimensions,
          child: AspectRatio(
            aspectRatio: 1,
            child: Text(
              "$value",
              style: TextStyle(
                color: (value == 0) ? Colors.black54 : Colors.white,
                fontSize: 72,
              ),
            ),
          ));
    } else {
      content = Text("$value",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 72,
          ));
    }

    return Container(
        child: GestureDetector(
            onTap: () {
              _clickCell(context, rowIndex, colIndex);
              SystemSound.play(SystemSoundType.click);
            },
            child: content));
  }

  Row buildRow(List<int> rowValues, int rowIndex) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowValues.asMap().entries.map<Container>((columnEntry) {
        int colIndex = columnEntry.key;
        int value = columnEntry.value;
        return Container(child: buildCell(context, value, rowIndex, colIndex));
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: this.gridValues.asMap().entries.map<Row>((rowEntry) {
              int rowIndex = rowEntry.key;
              List<int> rowValues = rowEntry.value;
              return buildRow(rowValues, rowIndex);
            }).toList()));
  }
}
