import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/four/input.txt";

void main() {
  // partOne();
  partTwo();
}

List<int> multiply = [];

void partTwo() {
  forEachLine(input, (line) => multiply.add(1));

  forEachLine(input, (line) => lineOp2(line));

  int total = 0;
  for (int m in multiply) {
    total += m;
  }

  print(total);
}

int index = 0;
void lineOp2(String line) {
  String set = line.substring(line.indexOf(':') + 1, line.indexOf('|')).trim();
  String mine = line.substring(line.indexOf('|') + 1).trim();

  List<String> winning = set.split(" ");
  winning.forEach((element) {
    element = element.trim();
  });

  int matchCount = 0;
  List<String> myCards = mine.split(" ");
  myCards.forEach((element) {
    element = element.trim();
    if (element == "") {
      return;
    }

    if (winning.contains(element)) {
      matchCount++;
    }
  });

  for (int j = 0; j < multiply[index]; j++) {
    for (int i = 1; i <= matchCount; i++) {
      multiply[index + i] += 1;
    }
  }

  index++;
}

int totalScore = 0;
void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  print(totalScore);
}

void lineOp1(String line) {
  String set = line.substring(line.indexOf(':') + 1, line.indexOf('|')).trim();
  String mine = line.substring(line.indexOf('|') + 1).trim();

  List<String> winning = set.split(" ");
  winning.forEach((element) {
    element = element.trim();
  });

  int score = 0;
  List<String> myCards = mine.split(" ");
  myCards.forEach((element) {
    element = element.trim();
    if (element == "") {
      return;
    }

    if (winning.contains(element)) {
      if (score == 0) {
        score = 1;
      } else {
        score *= 2;
      }
    }
  });

  totalScore += score;
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
