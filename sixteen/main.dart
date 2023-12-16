import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/sixteen/input.txt";

void main() {
  // partOne();
  partTwo();
}

List<List<String>> map = [];

Map<String, bool> energised = {};

Map<String, int> visited = {};

void partTwo() {
  forEachLine(input, (line) => lineOp1(line));

  int count = traverse(Coord(0, 0, direction.right));

  print(energised.length);
  print(count);
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

    visited[keyWithDirection] = -1;
  }

  markEnergised(int num) {
    String keyWithDirection = "$x-$y-$d";

    visited[keyWithDirection] = num;
  }

  bool partOfThisLoop() {
    String keyWithDirection = "$x-$y-$d";

    return visited[keyWithDirection] == -1;
  }

  int getCount() {
    String keyWithDirection = "$x-$y-$d";

    return visited[keyWithDirection]!;
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

int traverse(Coord c) {
  // Stopping conditions:
  // 1) the coordinate is off the map.
  if (c.x < 0 || c.y < 0 || c.x >= map[0].length || c.y >= map.length) {
    return 0;
  }

  // 2) We've entered this tile in this direction in the current loop we are on
  // (in other words we would cycle if we didnt stop now).
  if (c.partOfThisLoop()) {
    return 0;
  }

  // 3) We've checked this tile in this direction in the past (in another loop)
  // and so we can just get the already calculated count from there.
  if (c.alreadyDone()) {
    return c.getCount();
  }

  int totalEnergised = 1;
  if (c.marked()) {
    totalEnergised = 0;
  }

  c.markBusy();

  // Now, we need to check where to traverse to next after this point. That
  // very much depends on what is at this point.
  switch (map[c.y][c.x]) {
    // If this is a "." then we just continue the same trajectory.
    case ".":
      totalEnergised += traverse(c.move(c.d));

    // If approaching from left/right then continue. Else split with new
    // left & right trajectories.
    case "-":
      if (c.d == direction.left || c.d == direction.right) {
        totalEnergised += traverse(c.move(c.d));
      } else {
        totalEnergised += traverse(c.move(direction.left));
        totalEnergised += traverse(c.move(direction.right));
      }

    case "|":
      if (c.d == direction.up || c.d == direction.down) {
        totalEnergised += traverse(c.move(c.d));
      } else {
        totalEnergised += traverse(c.move(direction.up));
        totalEnergised += traverse(c.move(direction.down));
      }

    case "\\":
      switch (c.d) {
        case direction.up:
          totalEnergised += traverse(c.move(direction.left));

        case direction.down:
          totalEnergised += traverse(c.move(direction.right));

        case direction.left:
          totalEnergised += traverse(c.move(direction.up));

        case direction.right:
          totalEnergised += traverse(c.move(direction.down));
      }

    case "/":
      switch (c.d) {
        case direction.up:
          totalEnergised += traverse(c.move(direction.right));

        case direction.down:
          totalEnergised += traverse(c.move(direction.left));

        case direction.left:
          totalEnergised += traverse(c.move(direction.down));

        case direction.right:
          totalEnergised += traverse(c.move(direction.up));
      }
  }

  if (!c.marked()) {
    c.markEnergised(totalEnergised);
  }

  return totalEnergised;
}

void lineOp1(String line) {
  map.add(line.split(""));
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
