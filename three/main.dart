import 'dart:io';

// const input = "/Users/elle/projects/AOC_2023/three/example.txt";
const input = "/Users/elle/projects/AOC_2023/three/input.txt";

void main() {
  // partOne();
  partTwo();
}

List<List<String>> inputMap = [];

class Coord {
  int x;
  int y;

  Coord(this.x, this.y);
}

void partTwo() {
  // Construct the 2D map.
  forEachLine(input, (line) => lineOp1(line));

  List<Coord> stars = [];
  List<List<int>> nums = [];

  for (int i = 0; i < inputMap.length; i++) {
    nums.add([]);

    int lineNum = 0;
    List<Coord> numCoords = [];

    for (int j = 0; j < inputMap[i].length; j++) {
      nums[i].add(-1);

      String current = inputMap[i][j];

      if (current == "." || !isInt(current)) {
        // Make a note of the coordinate of any star.
        if (current == "*") {
          stars.add(Coord(j, i));
        }

        for (Coord c in numCoords) {
          nums[c.y][c.x] = lineNum;
        }

        numCoords = [];
        lineNum = 0;

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
        }
      }

      // If we were constructing a number before, we continue building the
      // number.
      if (numCoords.length > 0) {
        lineNum = (lineNum * 10) + n;
      } else {
        lineNum = n;
      }
      numCoords.add(Coord(j, i));

      if (j == inputMap[i].length - 1) {
        for (Coord c in numCoords) {
          nums[c.y][c.x] = lineNum;
        }
      }
    }
  }

  int gearRatioSum = 0;

  // Check if any star is a gear.
  for (Coord star in stars) {
    // Loop around its coordinates to find numbers.
    List<int> starNums = [];

    for (int y = star.y - 1; y <= star.y + 1; y++) {
      bool foundMiddleNum = false;
      for (int x = star.x - 1; x <= star.x + 1; x++) {
        if (x == star.x && y == star.y) {
          continue;
        }
        if (x < 0 || y < 0 || y >= inputMap.length || x >= inputMap[y].length) {
          continue;
        }
        if (foundMiddleNum) {
          continue;
        }

        int n = nums[y][x];

        if (n == -1) {
          continue;
        }

        if (x == star.x) {
          foundMiddleNum = true;

          // We may have already accounted for this number.
          if (x - 1 >= 0 && nums[y][x - 1] != -1) {
            continue;
          }
        }

        starNums.add(n);
      }
    }

    if (starNums.length != 2) {
      continue;
    }

    int ratio = starNums[0] * starNums[1];

    gearRatioSum += ratio;
  }

  print(gearRatioSum);
}

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
