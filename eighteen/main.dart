import 'dart:io';
import 'ten.dart';

const input = "/Users/elle/projects/AOC_2023/eighteen/input.txt";

void main() {
  partOne();
}

enum direction { left, right, up, down }

List<Coord> trench = [];

class Coord {
  int x;
  int y;
  String symbol;

  Coord(this.x, this.y, this.symbol);

  Coord move(direction d, direction nextDir) {
    switch (d) {
      case direction.up:
        if (nextDir == direction.up) {
          return Coord(x, y - 1, "|");
        }
        if (nextDir == direction.left) {
          return Coord(x, y - 1, "7");
        }
        if (nextDir == direction.right) {
          return Coord(x, y - 1, "F");
        }
        throw ("bad");

      case direction.down:
        if (nextDir == direction.down) {
          return Coord(x, y + 1, "|");
        }
        if (nextDir == direction.left) {
          return Coord(x, y + 1, "J");
        }
        if (nextDir == direction.right) {
          return Coord(x, y + 1, "L");
        }
        throw ("bad");

      case direction.left:
        if (nextDir == direction.left) {
          return Coord(x - 1, y, "-");
        }
        if (nextDir == direction.down) {
          return Coord(x - 1, y, "F");
        }
        if (nextDir == direction.up) {
          return Coord(x - 1, y, "L");
        }
        throw ("bad");

      case direction.right:
        if (nextDir == direction.right) {
          return Coord(x + 1, y, "-");
        }
        if (nextDir == direction.down) {
          return Coord(x + 1, y, "7");
        }
        if (nextDir == direction.up) {
          return Coord(x + 1, y, "J");
        }
        throw ("bad");
    }
  }
}

class Instruction {
  late direction d;
  final int count;

  Instruction(String dir, this.count) {
    switch (dir) {
      case "R":
        d = direction.right;
      case "L":
        d = direction.left;
      case "U":
        d = direction.up;
      case "D":
        d = direction.down;
    }
  }

  display() {
    print("$d: $count");
  }
}

List<Instruction> instructs = [];

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  Coord current = Coord(0, 0, "F");
  // trench.add(current);
  int minY = 0;
  int minX = 0;
  int maxX = 0;

  for (int j = 0; j < instructs.length; j++) {
    // Get next direction.
    direction nextDir = instructs[0].d;
    if (j + 1 < instructs.length) {
      nextDir = instructs[j + 1].d;
    }

    for (int i = 0; i < instructs[j].count; i++) {
      direction nd = instructs[j].d;
      if (i == instructs[j].count - 1) {
        nd = nextDir;
      }
      current = current.move(instructs[j].d, nd);
      trench.add(current);

      if (current.x < minX) {
        minX = current.x;
      }

      if (current.x > maxX) {
        maxX = current.x;
      }

      if (current.y < minY) {
        minY = current.y;
      }
    }
  }

  trench.forEach((coord) {
    coord.x += minX.abs();
    coord.y += minY.abs();
    maxX += minX.abs();
  });

  trench.forEach((coord) {
    while (maze.length <= coord.y) {
      maze.add([]);
    }

    maze[coord.y].add(Pipe(coord.x, coord.symbol));

    maze[coord.y].sort((a, b) {
      if (a.x == b.x) {
        return 0;
      }

      if (a.x < b.x) {
        return -1;
      }

      return 1;
    });
  });

  print(trench.length + countInside());
}

void lineOp1(String line) {
  line = line.substring(0, line.indexOf("(") - 1);
  List<String> parts = line.split(" ");

  instructs.add(Instruction(parts[0], int.parse(parts[1])));
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
