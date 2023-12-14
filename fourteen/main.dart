import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/fourteen/example.txt";

void main() {
  // partOne();
  partTwo();
}

void partTwo() {
  forEachLine(input, (line) => lineOp1(line));

  // Rotate anti clockwise once to get North to be left.
  rotateMapAntiClockWise();

  int cycles = 1000000000;

  for (int i = 0; i < cycles; i++) {
    print("cycle: $i");
    map.forEach((line) {
      tilt(line);
    });

    // Rotate clockwise to get West left.
    rotateMapClockWise();

    map.forEach((line) {
      tilt(line);
    });

    // Rotate clockwise to get South left.
    rotateMapClockWise();

    map.forEach((line) {
      tilt(line);
    });

    // Rotate clockwise to get East left.
    rotateMapClockWise();

    map.forEach((line) {
      tilt(line);
    });

    // Rotate clockwise to get North left.
    rotateMapClockWise();
  }

  // rotate once more to get North at the top.
  rotateMapClockWise();

  print(calcLoad());
}

void rotateMapClockWise() {
  List<List<String>> newMap = [];
  int xLen = map[0].length;

  for (int i = 0; i < xLen; i++) {
    newMap.add([]);

    for (int j = map.length - 1; j >= 0; j--) {
      String itemToMove = map[j][i];

      newMap[i].add(itemToMove);
    }
  }
  map = newMap;
}

void rotateMapAntiClockWise() {
  List<List<String>> newMap = [];
  for (int i = 0; i < map.length; i++) {
    for (int j = map[i].length - 1; j >= 0; j--) {
      String itemToMove = map[i][j];

      // new x = old y.
      int newX = j;

      // new y = xlen-oldx
      int newY = map[i].length - j;

      while (newMap.length <= newY) {
        newMap.add([]);
      }

      newMap[newY].add(itemToMove);
    }
  }
  map = newMap.sublist(1);
}

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  // Rotate anti clockwise.
  rotateMapAntiClockWise();

  map.forEach((line) {
    tilt(line);
  });

  // Rotate it back.
  rotateMapClockWise();

  print(calcLoad());
}

int calcLoad() {
  int load = 0;
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      if (map[i][j] != "O") {
        continue;
      }

      load += map.length - i;
    }
  }

  return load;
}

void tilt(List<String> line) {
  int barrier = -1;
  for (int i = 0; i < line.length; i++) {
    if (line[i] == "#") {
      barrier = i;
      continue;
    }

    if (line[i] == ".") {
      continue;
    }

    if (line[i] == "O") {
      // Between the barrier and current position, is there somewhere
      // we can move this rock?.
      int finalPos = i;
      for (int s = barrier + 1; s < i; s++) {
        if (line[s] != ".") {
          continue;
        }

        // Found a free space. Put the rock there and remove
        // it from here.
        line[s] = "O";
        line[i] = ".";

        finalPos = s;

        break;
      }

      barrier = finalPos;
    }
  }
}

List<List<String>> map = [];

void lineOp1(String line) {
  map.add(line.split(""));
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
