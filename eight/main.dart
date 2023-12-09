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
List<int> counts = [];

void partTwo() {
  forEachLine(input, (line) => lineOp2(line));

  for (int i = 0; i < starts.length; i++) {
    if (map[starts[i]] == null) {
      throw "bad";
    }

    int count = 0;
    bool found = false;
    while (!found) {
      for (int j = 0; j < instructions.length; j++) {
        count++;

        bool left = false;
        if (instructions[j] == "L") {
          left = true;
        }

        Pair p = map[starts[i]]!;

        if (left) {
          starts[i] = p.left;
        } else {
          starts[i] = p.right;
        }

        if (starts[i].endsWith("Z")) {
          counts.add(count);
          found = true;
          break;
        }
      }
    }
  }

  int f = counts[0];
  for (int i = 1; i < counts.length; i++) {
    f = lcm(f, counts[i]);
  }

  print(f);
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

int lcm(int a, int b) => (a * b) ~/ gcd(a, b);

int gcd(int a, int b) {
  while (b != 0) {
    var t = b;
    b = a % t;
    a = t;
  }
  return a;
}
