import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/ten/input.txt";

void main() {
  partOne();
}

class Coord {
  int x;
  int y;

  Coord(this.x, this.y) {}

  display() {
    print("($x, $y)");
  }

  bool equal(Coord other) {
    return this.x == other.x && this.y == other.y;
  }
}

class Pipe {
  String symbol;

  Pipe(this.symbol);

  bool isS() {
    return symbol == "S";
  }

  zero() {
    symbol = ".";
  }

  bool canLookLeft() {
    return isS() || lookingLeft.contains(symbol);
  }

  bool canLookRight() {
    return isS() || lookingRight.contains(symbol);
  }

  bool canLookUp() {
    return isS() || lookingUp.contains(symbol);
  }

  bool canLookDown() {
    return isS() || lookingDown.contains(symbol);
  }
}

const List<String> lookingDown = ["|", "7", "F"];
const List<String> lookingUp = ["|", "L", "J"];
const List<String> lookingLeft = ["-", "J", "7"];
const List<String> lookingRight = ["-", "F", "L"];

List<List<Pipe>> maze = [];
late Coord start;

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  // Find one exit from S (there should be exactly 2 according to the problem).
  List<Coord> out = loopS(start);
  if (out.length != 2) {
    throw "more than two exits from S";
  }

  // Choose 1 and follow its various paths until we get back to S.
  Coord prev = start;
  Coord current = out[0];
  bool found = false;
  int steps = 0;
  while (!found) {
    steps++;

    // First find all the next coords that can lead from this coord.
    List<Coord> nextCoords = loop(current, prev);
    if (nextCoords.length != 1) {
      throw "bad";
    }

    // Now, mark that we have looked at this point so that we dont ever revisit
    // it again.
    maze[current.y][current.x].zero();

    prev = current;
    current = nextCoords[0];

    if (current.x == start.x && current.y == start.y) {
      found = true;
    }
  }

  print((steps + 1) / 2);
}

List<Coord> loop(Coord c, Coord prev) {
  List<Coord> res = [];
  Pipe pipe = maze[c.y][c.x];

  // Up.
  if (pipe.canLookUp() && c.y - 1 >= 0) {
    Pipe upPipe = maze[c.y - 1][c.x];
    if (upPipe.canLookDown()) {
      res.add(Coord(c.x, c.y - 1));
    }
  }

  // Down.
  if (pipe.canLookDown() && c.y + 1 < maze.length) {
    Pipe downPipe = maze[c.y + 1][c.x];
    if (downPipe.canLookUp()) {
      res.add(Coord(c.x, c.y + 1));
    }
  }

  // Left.
  if (pipe.canLookLeft() && c.x - 1 >= 0) {
    Pipe leftPipe = maze[c.y][c.x - 1];
    if (leftPipe.canLookRight()) {
      res.add(Coord(c.x - 1, c.y));
    }
  }

  // Right.
  if (pipe.canLookRight() && c.x + 1 < maze[c.y].length) {
    Pipe rightPipe = maze[c.y][c.x + 1];
    if (rightPipe.canLookLeft()) {
      res.add(Coord(c.x + 1, c.y));
    }
  }

  // Dont go back to the previous coordinate.
  res.removeWhere((element) => element.equal(prev));

  return res;
}

// loopS loops around the S point and finds the 2 pipes that lead out from it.
// Using these 2 pipes, we also set the pipe symbol for S.
List<Coord> loopS(Coord c) {
  int y = c.y;
  int x = c.x;

  List<Coord> res = [];

  bool up = false;
  bool down = false;
  bool left = false;
  bool right = false;

  // Up.
  if (y - 1 >= 0) {
    if (lookingDown.contains(maze[y - 1][x].symbol)) {
      res.add(Coord(x, y - 1));
      up = true;
    }
  }

  // Down.
  if (y + 1 < maze.length) {
    if (lookingUp.contains(maze[y + 1][x].symbol)) {
      res.add(Coord(x, y + 1));
      down = true;
    }
  }

  // Left.
  if (x - 1 >= 0) {
    if (lookingRight.contains(maze[y][x - 1].symbol)) {
      res.add(Coord(x - 1, y));
      left = true;
    }
  }

  // Right.
  if (x + 1 < maze[y].length) {
    if (lookingLeft.contains(maze[y][x + 1].symbol)) {
      res.add(Coord(x + 1, y));
      right = true;
    }
  }

  String symbol;

  if (up && down) {
    symbol = "|";
  } else if (left && right) {
    symbol = "-";
  } else if (up && left) {
    symbol = "J";
  } else if (up && right) {
    symbol = "L";
  } else if (down && left) {
    symbol = "7";
  } else if (down && right) {
    symbol = "F";
  } else {
    throw "should not happen";
  }

  maze[y][x].symbol = symbol;

  return res;
}

void lineOp1(String line) {
  List<String> parts = line.split('');

  List<Pipe> pipes = [];
  parts.forEach((p) {
    pipes.add(Pipe(p));
  });

  maze.add(pipes);

  if (line.contains("S")) {
    start = Coord(line.indexOf("S"), maze.length - 1);
  }
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
