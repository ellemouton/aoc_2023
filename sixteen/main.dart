import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/sixteen/input.txt";

void main() {
  // partOne();
  partTwo();
}

List<List<String>> map = [];

Map<String, bool> energised = {};

Map<String, bool> visited = {};

void partTwo() {
  forEachLine(input, (line) => lineOp1(line));

  int max = 0;

  // Check the top row. For each block, have an initial trajectory of downward.
  for (int j = 0; j < map[0].length; j++) {
    traverse(Coord(j, 0, direction.down));
    int count = energised.length;
    if (count > max) {
      max = count;
    }
    energised = {};
    visited = {};
  }

  // Check the bottom row. For each block, have an initial trajectory of upwards.
  for (int j = 0; j < map[map.length - 1].length; j++) {
    traverse(Coord(j, map.length - 1, direction.up));
    int count = energised.length;
    if (count > max) {
      max = count;
    }
    energised = {};
    visited = {};
  }

  // Side ways.
  for (int i = 0; i < map.length; i++) {
    traverse(Coord(0, i, direction.right));
    int count = energised.length;
    if (count > max) {
      max = count;
    }
    energised = {};
    visited = {};

    traverse(Coord(map[i].length - 1, i, direction.left));
    count = energised.length;
    if (count > max) {
      max = count;
    }
    energised = {};
    visited = {};
  }

  print(max);
}

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  traverse(Coord(0, 0, direction.right));

  print(energised.length);
}

enum direction {
  left,
  right,
  up,
  down,
}

class Coord {
  int x;
  int y;
  direction d;

  Coord(this.x, this.y, this.d);

  Coord move(direction d) {
    switch (d) {
      case direction.down:
        return moveDown();

      case direction.up:
        return moveUp();

      case direction.left:
        return moveLeft();

      case direction.right:
        return moveRight();
    }
  }

  bool marked() {
    String key = "$x-$y";

    return energised[key] == true;
  }

  markBusy() {
    String key = "$x-$y";
    energised[key] = true;

    String keyWithDirection = "$x-$y-$d";

    if (visited[keyWithDirection] != null) {
      throw "bad";
    }

    visited[keyWithDirection] = false;
  }

  markEnergised() {
    String keyWithDirection = "$x-$y-$d";

    visited[keyWithDirection] = true;
  }

  bool partOfThisLoop() {
    String keyWithDirection = "$x-$y-$d";

    return visited[keyWithDirection] == false;
  }

  bool alreadyDone() {
    String keyWithDirection = "$x-$y-$d";

    return visited[keyWithDirection] != null;
  }

  Coord moveUp() {
    return Coord(x, y - 1, direction.up);
  }

  Coord moveDown() {
    return Coord(x, y + 1, direction.down);
  }

  Coord moveLeft() {
    return Coord(x - 1, y, direction.left);
  }

  Coord moveRight() {
    return Coord(x + 1, y, direction.right);
  }

  display() {
    print("($x, $y) - $d");
  }
}

void traverse(Coord c) {
  Map<String, bool> localCache = {};

  // Stopping conditions:
  // 1) the coordinate is off the map.
  if (c.x < 0 || c.y < 0 || c.x >= map[0].length || c.y >= map.length) {
    return;
  }

  // 2) We've entered this tile in this direction in the current loop we are on
  // (in other words we would cycle if we didnt stop now).
  if (c.partOfThisLoop()) {
    return;
  }

  // 3) We've checked this tile in this direction in the past (in another loop)
  // and so we can just return.
  if (c.alreadyDone()) {
    return;
  }

  c.markBusy();

  // Now, we need to check where to traverse to next after this point. That
  // very much depends on what is at this point.
  switch (map[c.y][c.x]) {
    // If this is a "." then we just continue the same trajectory.
    case ".":
      traverse(c.move(c.d));

    // If approaching from left/right then continue. Else split with new
    // left & right trajectories.
    case "-":
      if (c.d == direction.left || c.d == direction.right) {
        traverse(c.move(c.d));
      } else {
        traverse(c.move(direction.left));
        traverse(c.move(direction.right));
      }

    case "|":
      if (c.d == direction.up || c.d == direction.down) {
        traverse(c.move(c.d));
      } else {
        traverse(c.move(direction.up));
        traverse(c.move(direction.down));
      }

    case "\\":
      switch (c.d) {
        case direction.up:
          traverse(c.move(direction.left));

        case direction.down:
          traverse(c.move(direction.right));

        case direction.left:
          traverse(c.move(direction.up));

        case direction.right:
          traverse(c.move(direction.down));
      }

    case "/":
      switch (c.d) {
        case direction.up:
          traverse(c.move(direction.right));

        case direction.down:
          traverse(c.move(direction.left));

        case direction.left:
          traverse(c.move(direction.down));

        case direction.right:
          traverse(c.move(direction.up));
      }
  }

  c.markEnergised();

  return;
}

void lineOp1(String line) {
  map.add(line.split(""));
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
