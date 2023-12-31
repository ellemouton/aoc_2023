import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/thirteen/input.txt";

void main() {
  // partOne();
  partTwo();
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

void partTwo() {
  forEachLine(input, (line) => lineOp1(line));
  inputs.add(current);

  int total = 0;
  for (Grid g in inputs) {
    total += compute2(g);
  }

  print(total);
}

int compute2(Grid g) {
  // First, do the y-axis check.
  for (int i = 0; i < g.lines.length - 1; i++) {
    if (!isOffByOneMirror(g, i)) {
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
    if (!isOffByOneMirror(flipped, i)) {
      continue;
    }

    return i + 1;
  }

  throw "no mirror found";
}

bool isOffByOneMirror(Grid g, int index) {
  bool done = false;
  int pointer1 = index;
  int pointer2 = index + 1;
  int diffCount = 0;

  while (!done) {
    int diff = countDiff(g.lines[pointer1], g.lines[pointer2]);
    diffCount += diff;

    if (diffCount > 1) {
      return false;
    }

    pointer1--;
    pointer2++;

    if (pointer1 < 0 || pointer2 >= g.lines.length) {
      return diffCount == 1;
    }
  }
}

int countDiff(String one, String two) {
  if (one == two) {
    return 0;
  }

  if (one.length != two.length) {
    throw "bad";
  }

  int diffs = 0;
  for (int i = 0; i < one.length; i++) {
    if (one[i] != two[i]) {
      diffs++;
    }
  }

  return diffs;
}

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
