import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/eight/input.txt";

void main() {
  // partOne();
  partTwo();
}

class Pair {
  String left;
  String right;

  Pair(this.left, this.right);

  display() {
    print("(${this.left}, ${this.right})");
  }
}

Map<String, Pair> map = {};
String instructions = "";
List<String> starts = [];

void partTwo() {
  forEachLine(input, (line) => lineOp2(line));

  print(starts);

  bool found = false;
  int count = 0;
  while (!found) {
    for (int i = 0; i < instructions.length; i++) {
      count++;

      bool left = false;
      if (instructions[i] == "L") {
        left = true;
      }

      int numFound = 0;
      for (int i = 0; i < starts.length; i++) {
        if (map[starts[i]] == null) {
          throw "bad";
        }

        Pair p = map[starts[i]]!;

        if (left) {
          starts[i] = p.left;
        } else {
          starts[i] = p.right;
        }

        if (starts[i].endsWith("Z")) {
          numFound++;
        }
      }

      if (numFound > 2) {
        print(numFound);
      }

      if (numFound == starts.length) {
        found = true;
        break;
      }
    }
  }

  print("count $count");
}

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  String current = "AAA";
  int count = 0;
  bool found = false;
  while (!found) {
    for (int i = 0; i < instructions.length; i++) {
      count++;
      bool left = false;
      if (instructions[i] == "L") {
        left = true;
      }

      if (map[current] == null) {
        throw "bad";
      }

      Pair p = map[current]!;
      if (left) {
        current = p.left;
      } else {
        current = p.right;
      }

      if (current == "ZZZ") {
        found = true;
        break;
      }
    }
  }

  print("count is $count");
}

void lineOp2(String line) {
  if (line.contains("=")) {
    String a = line.substring(0, line.indexOf("="));
    String b = line.substring(line.indexOf("(") + 1, line.indexOf(","));
    String c = line.substring(line.indexOf(",") + 2, line.indexOf(")"));
    map[a.trim()] = Pair(b.trim(), c.trim());

    if (a.trim().endsWith("A")) {
      starts.add(a.trim());
    }

    return;
  }

  if (line.trim() == "") {
    return;
  }

  instructions = line;
}

void lineOp1(String line) {
  if (line.contains("=")) {
    String a = line.substring(0, line.indexOf("="));
    String b = line.substring(line.indexOf("(") + 1, line.indexOf(","));
    String c = line.substring(line.indexOf(",") + 2, line.indexOf(")"));
    map[a.trim()] = Pair(b.trim(), c.trim());

    return;
  }

  if (line.trim() == "") {
    return;
  }

  instructions = line;
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
