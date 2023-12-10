import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/ten/input.txt";

void main() {
  // partOne();
  partTwo();
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

class Quad {
  // "true" for any of these means: inside.
  bool topLeft;
  bool topRight;
  bool bottomLeft;
  bool bottomRight;

  Quad(this.topLeft, this.bottomLeft, this.topRight, this.bottomRight);
}

class Pipe {
  String symbol;
  bool isLoopTile = false;
  Quad? quad;

  Pipe(this.symbol);

  bool isS() {
    return symbol == "S";
  }

  setQuad(bool tl, bool tr, bool bl, bool br) {
    quad = Quad(tl, tr, bl, br);
  }

  setIsLoop() {
    isLoopTile = true;
  }

  bool canLookLeft() {
    return !isLoopTile && (isS() || lookingLeft.contains(symbol));
  }

  bool canLookRight() {
    return !isLoopTile && (isS() || lookingRight.contains(symbol));
  }

  bool canLookUp() {
    return !isLoopTile && (isS() || lookingUp.contains(symbol));
  }

  bool canLookDown() {
    return !isLoopTile && (isS() || lookingDown.contains(symbol));
  }
}

const List<String> lookingDown = ["|", "7", "F"];
const List<String> lookingUp = ["|", "L", "J"];
const List<String> lookingLeft = ["-", "J", "7"];
const List<String> lookingRight = ["-", "F", "L"];

List<List<Pipe>> maze = [];
late Coord start;

void partTwo() {
  // Read in the input into maze & start.
  forEachLine(input, (line) => lineOp1(line));

  // Now, follow the loop path and make note of each coordinate that is part of
  // the loop.
  trackLoop((p) => {});

  // Also set the start symbol to "x".
  // Make sure that the start pipe is also seen as part of the loop.
  maze[start.y][start.x].isLoopTile = true;

  // Now, we go go from the top to bottom of the map in order to figure out
  // which tiles are _in_ the loop. Since there is no way that the edge tiles
  // can be in the loop, those are set to "outside". Then the first time we hit
  // a loop tile, we switch to inside & start counting any non loop tiles for
  // that column. When we then hit another loop tile, we switch to outside
  // again and so on and so on.
  int insideCount = 0;
  for (int j = 0; j < maze.length; j++) {
    Quad prevQuad = Quad(false, false, false, false);

    for (int i = 0; i < maze[j].length; i++) {
      Pipe p = maze[j][i];

      // If this is not a loop tile, then we should be able to derive the
      // inside/outside value by looking at the previous tile's top right or
      // bottom right quads.
      if (!p.isLoopTile) {
        if (prevQuad.topRight != prevQuad.bottomRight) {
          throw "unexpected";
        }

        bool inside = prevQuad.topRight;

        Quad newQuad = Quad(inside, inside, inside, inside);

        if (inside) {
          insideCount++;
        }

        prevQuad = newQuad;
        continue;
      }

      // This is a loop pipe. So now we set quads based on the previous tile's
      // quads and the structure of this pipe.

      if (p.symbol == "|") {
        if (prevQuad.topRight != prevQuad.bottomRight) {
          throw "unexpected";
        }

        bool o = prevQuad.topRight;

        Quad newQuad = Quad(o, o, !o, !o);

        prevQuad = newQuad;
        continue;
      }

      if (p.symbol == "-") {
        if (prevQuad.topRight != !prevQuad.bottomRight) {
          throw "unexpected";
        }

        bool o = prevQuad.topRight;

        Quad newQuad = Quad(o, !o, o, !o);

        prevQuad = newQuad;
        continue;
      }

      if (p.symbol == "F") {
        if (prevQuad.topRight != prevQuad.bottomRight) {
          throw "unexpected";
        }

        bool o = prevQuad.topRight;

        Quad newQuad = Quad(o, o, o, !o);
        prevQuad = newQuad;
        continue;
      }

      if (p.symbol == "J") {
        if (prevQuad.topRight != !prevQuad.bottomRight) {
          throw "unexpected";
        }

        bool o = prevQuad.topRight;

        Quad newQuad = Quad(o, !o, !o, !o);
        prevQuad = newQuad;
        continue;
      }

      if (p.symbol == "7") {
        if (prevQuad.topRight != !prevQuad.bottomRight) {
          throw "unexpected";
        }

        bool o = prevQuad.topRight;

        Quad newQuad = Quad(o, !o, o, o);
        prevQuad = newQuad;
        continue;
      }

      if (p.symbol == "L") {
        if (prevQuad.topRight != prevQuad.bottomRight) {
          throw "unexpected";
        }

        bool o = prevQuad.topRight;

        Quad newQuad = Quad(o, o, !o, o);
        prevQuad = newQuad;
        continue;
      }
    }
  }

  print(insideCount);
}

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  int steps = 1;
  trackLoop((p0) => steps++);

  print((steps) / 2);
}

void trackLoop(Function(Coord) fn) {
  // Find one exit from S (there should be exactly 2 according to the problem).
  List<Coord> out = loopS(start);
  if (out.length != 2) {
    throw "more than two exits from S";
  }

  Coord prev = start;
  Coord current = out[0];
  bool found = false;

  while (!found) {
    // First find all the next coords that can lead from this coord.
    List<Coord> nextCoords = loop(current, prev);
    if (nextCoords.length != 1) {
      throw "bad";
    }

    // Now, mark that this point is in the path so that we dont ever visit it
    // again.
    maze[current.y][current.x].isLoopTile = true;
    fn(current);

    prev = current;
    current = nextCoords[0];

    if (current.x == start.x && current.y == start.y) {
      found = true;
    }
  }
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
