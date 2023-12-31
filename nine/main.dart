import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/nine/input.txt";

void main() {
  // partOne();
  partTwo();
}

List<List<int>> inputs = [];

void partTwo() {
  forEachLine(input, (line) => lineOp1(line));

  int count = 0;
  for (List<int> set in inputs) {
    count += analyseBack(set);
  }

  print(count);
}

int analyseBack(List<int> set) {
  List<int> current = set;
  bool done = false;
  List<int> firstItemInEachSet = [];

  while (!done) {
    List<int> nextSet = [];
    firstItemInEachSet.add(current[0]);

    for (int i = 0; i < current.length - 1; i++) {
      nextSet.add(current[i + 1] - current[i]);
    }

    current = nextSet;

    int sum = 0;
    nextSet.forEach((element) {
      sum += element;
    });

    if (sum == 0) {
      done = true;
    }
  }

  int next = 0;
  for (int i = firstItemInEachSet.length - 1; i >= 0; i--) {
    next = firstItemInEachSet[i] - next;
  }

  return next;
}

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  int count = 0;
  for (List<int> set in inputs) {
    count += analyseFwd(set);
  }

  print(count);
}

int analyseFwd(List<int> set) {
  List<int> current = set;
  bool done = false;
  List<int> lastItemInEachSet = [];

  while (!done) {
    List<int> nextSet = [];
    lastItemInEachSet.add(current[current.length - 1]);

    for (int i = 0; i < current.length - 1; i++) {
      nextSet.add(current[i + 1] - current[i]);
    }

    current = nextSet;

    int sum = 0;
    nextSet.forEach((element) {
      sum += element;
    });

    if (sum == 0) {
      done = true;
    }
  }

  int next = 0;
  for (int i = lastItemInEachSet.length - 1; i >= 0; i--) {
    next += lastItemInEachSet[i];
  }

  return next;
}

void lineOp1(String line) {
  List<String> parts = line.split(" ");
  List<int> l = [];

  for (String p in parts) {
    l.add(int.parse(p));
  }

  inputs.add(l);
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
