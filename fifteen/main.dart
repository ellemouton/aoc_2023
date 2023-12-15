import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/fifteen/input.txt";

void main() {
  // partOne();
  partTwo();
}

int hash(String input) {
  int current = 0;

  for (int unit in input.codeUnits) {
    current += unit;
    current *= 17;
    current = current % 256;
  }

  return current;
}

class Box {
  // map from label to focal length.
  Map<String, int> lenses = {};

  List<String> orderedLenses = [];

  void add(String label, int len) {
    if (lenses[label] != null) {
      lenses[label] = len;
      return;
    }

    lenses[label] = len;
    orderedLenses.add(label);
  }

  void remove(String label) {
    if (lenses[label] == null) {
      return;
    }

    lenses.remove(label);
    orderedLenses.remove(label);
  }
}

void partTwo() {
  String line = "";
  forEachLine(input, (l) => line = l);

  List<String> seq = line.split(",");

  // Box set. box num -> box.
  Map<int, Box> set = {};

  seq.forEach((line) {
    if (line.contains("-")) {
      String label = line.substring(0, line.indexOf("-"));
      int boxNum = hash(label);

      if (set[boxNum] == null) {
        set[boxNum] = Box();
      }

      set[boxNum]!.remove(label);

      return;
    }

    String label = line.substring(0, line.indexOf("="));
    int boxNum = hash(label);
    int focalLen = int.parse(line.substring(line.indexOf("=") + 1));

    if (set[boxNum] == null) {
      set[boxNum] = Box();
    }

    set[boxNum]!.add(label, focalLen);
  });

  int total = 0;
  set.forEach((boxNum, box) {
    for (int i = 0; i < box.orderedLenses.length; i++) {
      int focusPower =
          (1 + boxNum) * (i + 1) * box.lenses[box.orderedLenses[i]]!;

      total += focusPower;
    }
  });

  print(total);
}

void partOne() {
  forEachLine(input, (line) => lineOp1(line));
}

void lineOp1(String line) {
  List<String> seq = line.split(",");

  int total = 0;
  seq.forEach((element) {
    total += hash(element);
  });

  print(total);
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
