import 'dart:io';

// const input = "/Users/elle/projects/AOC_2023/three/example.txt";
const input = "/Users/elle/projects/AOC_2023/three/input.txt";

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

int totalEngine = 0;
void partOne() {
  // Construct the 2D map.
  forEachLine(input, (line) => lineOp1(line));

  for (int i = 0; i < inputMap.length; i++) {
    int lineNum = 0;
    bool busy = false;
    bool isEnginePart = false;

    for (int j = 0; j < inputMap[i].length; j++) {
      String current = inputMap[i][j];

      // Skip symbols and full stops.
      if (current == "." || !isInt(current)) {
        if (isEnginePart) {
          totalEngine += lineNum;
        }

        busy = false;
        lineNum = 0;
        isEnginePart = false;

        continue;
      }

      // Now we know it is an int.
      int n = int.parse(current);

      // Check if this part of the number makes the greater number an engine
      // part.
      for (int y = i - 1; y <= i + 1; y++) {
        for (int x = j - 1; x <= j + 1; x++) {
          if (x == j && y == i) {
            continue;
          }
          if (x < 0 ||
              y < 0 ||
              y >= inputMap.length ||
              x >= inputMap[y].length) {
            continue;
          }

          String eval = inputMap[y][x];
          if (eval == "." || isInt(eval)) {
            continue;
          }

          isEnginePart = true;
        }
      }

      // If we were constructing a number before, we continue building the
      // number.
      if (busy) {
        lineNum = (lineNum * 10) + n;
      } else {
        lineNum = n;
        busy = true;
      }
    }

    if (isEnginePart) {
      totalEngine += lineNum;
    }
  }

  print(totalEngine);
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
