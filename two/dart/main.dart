import 'dart:io';

// const input = "/Users/elle/projects/AOC_2023/two/example.txt";
const input = "/Users/elle/projects/AOC_2023/two/input.txt";

void main() {
  // partOne();
  partTwo();
}

int totalPower = 0;

void partTwo() {
  forEachLine(input, (line) => lineOp2(line));

  print(totalPower);
}

void lineOp2(String line) {
  // Chop off the ID section.
  int n2 = line.indexOf(":");
  line = line.substring(n2 + 2);

  // Replace all ; with ,.
  line = line.replaceAll(';', ',');

  List<String> groups = line.split(",");

  Map<String, int> minCount = {
    "red": 0,
    "blue": 0,
    "green": 0,
  };

  for (String g in groups) {
    g = g.trim();

    int n = g.indexOf(" ");
    String countStr = g.substring(0, n);
    int count = int.parse(countStr);

    String word = g.substring(n + 1);

    int? max = minCount[word];

    if (max == null) {
      throw "colour ${word} not found in $minCount";
    }

    if (count > max) {
      minCount[word] = count;
    }
  }

  int power = 1;
  minCount.forEach((_, value) {
    power *= value;
  });

  totalPower += power;
}

Map<String, int> contents = {
  "red": 12,
  "blue": 14,
  "green": 13,
};

int idTotal = 0;

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  print(idTotal);
}

void lineOp1(String line) {
  // Find the game ID.
  int n1 = line.indexOf(" ");
  int n2 = line.indexOf(":");
  String numStr = line.substring(n1, n2);
  int id = int.parse(numStr);

  // Chop off the ID sectino.
  line = line.substring(n2 + 2);

  // Replace all ; with ,.
  line = line.replaceAll(';', ',');

  List<String> groups = line.split(",");

  for (String g in groups) {
    g = g.trim();

    int n = g.indexOf(" ");
    String countStr = g.substring(0, n);
    int count = int.parse(countStr);

    String word = g.substring(n + 1);

    int? max = contents[word];

    if (max == null) {
      throw "colour ${word} not found in $contents";
    }

    if (count > max) {
      return;
    }
  }

  idTotal += id;
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
