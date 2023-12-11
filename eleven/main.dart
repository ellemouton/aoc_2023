import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/eleven/input.txt";

void main() {
  partOne();
}

class Coord {
  int x;
  int y;

  Coord(this.x, this.y);

  display() {
    print("($x, $y)");
  }
}

List<Coord> galaxies = [];

List<int> ysWithNone = [];
List<int> xsWithNone = [];
bool init = true;

void partOne() {
  // Collect the galaxies along with where to expand.
  forEachLine(input, (line) => lineOp1(line));

  // Now, expand the galaxy set.
  for (int i = 0; i < galaxies.length; i++) {
    int yIncr = 0;
    for (int y in ysWithNone) {
      if (y > galaxies[i].y) {
        break;
      }
      yIncr++;
    }

    int xIncr = 0;
    for (int x in xsWithNone) {
      if (x > galaxies[i].x) {
        break;
      }
      xIncr++;
    }

    galaxies[i].x += xIncr;
    galaxies[i].y += yIncr;
  }

  // Now, calc the shortast path between each and
  // sum them.
  int sum = 0;
  for (int i = 0; i < galaxies.length - 1; i++) {
    for (int j = i + 1; j < galaxies.length; j++) {
      Coord one = galaxies[i];
      Coord two = galaxies[j];

      int sp = (one.x - two.x).abs() + (one.y - two.y).abs();
      sum += sp;
    }
  }

  print(sum);
}

int yIndex = 0;
void lineOp1(String line) {
  if (init) {
    for (int i = 0; i < line.length; i++) {
      xsWithNone.add(i);
    }

    init = false;
  }

  if (!line.contains("#")) {
    ysWithNone.add(yIndex);
  } else {
    for (int i = 0; i < line.length; i++) {
      if (line[i] == "#") {
        galaxies.add(Coord(i, yIndex));
        xsWithNone.removeWhere((element) => element == i);
      }
    }
  }

  yIndex++;
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
