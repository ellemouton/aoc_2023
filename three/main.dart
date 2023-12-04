import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/three/example.txt";

void main() {
  partOne();
}

class Coordinate {
  int x;
  int y;

  Coordinate(this.x, this.y);
}

List<List<String>> inputMap = [];

List<Coordinate> symbols = [];

void partOne() {
  // Construct the 2D map.
  forEachLine(input, (line) => lineOp1(line));

  for (int i = 0; i < inputMap.length; i++) {
    int lineNum = 0;
    bool busy = false;

    for (int j = 0; j < inputMap[i].length; j++) {
      String current = inputMap[i][j];

      // Skip symbols and full stops.
      if (current == "." || !isInt(current)) {
        if (busy) {
          print(lineNum);
        }

        busy = false;
        lineNum = 0;

        continue;
      }

      // Now we know it is an int.
      int n = int.parse(current);

      // If we were constructing a number before, we continue building the
      // number.
      if (busy) {
        lineNum = (lineNum * 10) + n;
      } else {
        lineNum = n;
        busy = true;
      }
    }

    if (busy) {
      print(lineNum);
    }
  }
}

void lineOp1(String line) {
  inputMap.add(line.split(''));
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}

bool isInt(String s) {
  return int.tryParse(s) != null;
}
