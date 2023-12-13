import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/thirteen/input.txt";

void main() {
  partOne();
}

class Grid {
  late List<String> lines;

  Grid() {
    this.lines = [];
  }

  display() {
    for (String l in lines) {
      print(l);
    }
  }
}

List<Grid> inputs = [];
Grid current = Grid();

void partOne() {
  forEachLine(input, (line) => lineOp1(line));
  inputs.add(current);

  int total = 0;
  for (Grid g in inputs) {
    total += compute(g);
  }

  print(total);
}

int compute(Grid g) {
  // First, do the y-axis check.
  for (int i = 0; i < g.lines.length - 1; i++) {
    if (!isMirror(g, i)) {
      continue;
    }

    return 100 * (i + 1);
  }

  // Build a flipped grid.
  Grid flipped = Grid();
  for (String line in g.lines) {
    for (int i = 0; i < line.length; i++) {
      if (i == flipped.lines.length) {
        flipped.lines.add("");
      }

      flipped.lines[i] += line[i];
    }
  }

  // Do the x-axis check on the flipped grid.
  for (int i = 0; i < flipped.lines.length - 1; i++) {
    if (!isMirror(flipped, i)) {
      continue;
    }

    return i + 1;
  }

  throw "no mirror found";
}

bool isMirror(Grid g, int index) {
  bool done = false;
  int pointer1 = index;
  int pointer2 = index + 1;

  while (!done) {
    if (g.lines[pointer1] != g.lines[pointer2]) {
      return false;
    }

    pointer1--;
    pointer2++;

    if (pointer1 < 0 || pointer2 >= g.lines.length) {
      return true;
    }
  }
}

void lineOp1(String line) {
  if (line.trim().isEmpty) {
    inputs.add(current);
    current = Grid();
    return;
  }

  current.lines.add(line);
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
