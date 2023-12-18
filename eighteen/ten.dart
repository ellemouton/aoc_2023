import 'dart:io';

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
  int x;
  String symbol;
  Quad? quad;

  Pipe(this.x, this.symbol);

  setQuad(bool tl, bool tr, bool bl, bool br) {
    quad = Quad(tl, tr, bl, br);
  }

  bool canLookLeft() {
    return lookingLeft.contains(symbol);
  }

  bool canLookRight() {
    return lookingRight.contains(symbol);
  }

  bool canLookUp() {
    return lookingUp.contains(symbol);
  }

  bool canLookDown() {
    return lookingDown.contains(symbol);
  }
}

const List<String> lookingDown = ["|", "7", "F"];
const List<String> lookingUp = ["|", "L", "J"];
const List<String> lookingLeft = ["-", "J", "7"];
const List<String> lookingRight = ["-", "F", "L"];

List<List<Pipe>> maze = [];
late Coord start;

int countInside() {
  // Now, we go go from the top to bottom of the map in order to figure out
  // which tiles are _in_ the loop. Since there is no way that the edge tiles
  // can be in the loop, those are set to "outside". Then the first time we hit
  // a loop tile, we switch to inside & start counting any non loop tiles for
  // that column. When we then hit another loop tile, we switch to outside
  // again and so on and so on.
  int insideCount = 0;
  for (int j = 0; j < maze.length; j++) {
    Quad prevQuad = Quad(false, false, false, false);

    int nextX = 0;

    for (int i = 0; i < maze[j].length; i++) {
      Pipe p = maze[j][i];

      bool inside = prevQuad.topRight;

      // If the x coord is not our expected x coord, then we skipped some
      // non-border tiles that we should quickly account for.
      if (nextX != p.x) {
        if (inside) {
          insideCount += (p.x - nextX);
        }
      }
      nextX = p.x + 1;

      // // If this is not a loop tile, then we should be able to derive the
      // // inside/outside value by looking at the previous tile's top right or
      // // bottom right quads.
      // if (!p.isLoopTile) {
      //   if (prevQuad.topRight != prevQuad.bottomRight) {
      //     throw "unexpected";
      //   }

      //   bool inside = prevQuad.topRight;

      //   Quad newQuad = Quad(inside, inside, inside, inside);

      //   if (inside) {
      //     insideCount++;
      //   }

      //   prevQuad = newQuad;
      //   continue;
      // }

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

  return insideCount;
}
