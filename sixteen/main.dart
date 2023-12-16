import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/sixteen/input.txt";

void main() {
  partOne();
}

List<List<String>> map = [];

Map<String, bool> energised = {};

Map<String, bool> visited = {};

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

  mark() {
    String key = "$x-$y";
    energised[key] = true;

    String keyWithDirection = "$x-$y-$d";
    visited[keyWithDirection] = true;
  }

  bool alreadyDone() {
    String keyWithDirection = "$x-$y-$d";

    return visited[keyWithDirection] == true;
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
  // Stopping conditions:
  // 1) the coordinate is off the map.
  if (c.x < 0 || c.y < 0 || c.x >= map[0].length || c.y >= map.length) {
    return;
  }

  // 2) This coordinate hase been visited already with the
  // same trajectory.
  if (c.alreadyDone()) {
    return;
  }

  c.mark();

  // Make a copy of what is at the tile currently.
  String tile = map[c.y][c.x];

  // Now, we need to check where to traverse to next after this point. That
  // very much depends on what is at this point.
  switch (tile) {
    // If this is a "." then we just continue the same trajectory.
    case ".":
      return traverse(c.move(c.d));

    // If approaching from left/right then continue. Else split with new
    // left & right trajectories.
    case "-":
      if (c.d == direction.left || c.d == direction.right) {
        return traverse(c.move(c.d));
      }

      traverse(c.move(direction.left));

      return traverse(c.move(direction.right));

    case "|":
      if (c.d == direction.up || c.d == direction.down) {
        return traverse(c.move(c.d));
      }

      traverse(c.move(direction.up));

      return traverse(c.move(direction.down));

    case "\\":
      switch (c.d) {
        case direction.up:
          return traverse(c.move(direction.left));

        case direction.down:
          return traverse(c.move(direction.right));

        case direction.left:
          return traverse(c.move(direction.up));

        case direction.right:
          return traverse(c.move(direction.down));
      }

    case "/":
      switch (c.d) {
        case direction.up:
          return traverse(c.move(direction.right));

        case direction.down:
          return traverse(c.move(direction.left));

        case direction.left:
          return traverse(c.move(direction.down));

        case direction.right:
          return traverse(c.move(direction.up));
      }
  }
}

void lineOp1(String line) {
  map.add(line.split(""));
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
