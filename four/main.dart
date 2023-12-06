import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/four/input.txt";

void main() {
  partOne();
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

  print(winning);

  print("--------");
  int score = 0;
  List<String> myCards = mine.split(" ");
  myCards.forEach((element) {
    element = element.trim();
    if (element == "") {
      return;
    }

    if (winning.contains(element)) {
      print("winning: $element");
      if (score == 0) {
        score = 1;
      } else {
        score *= 2;
      }
    }
  });

  print("$score");
  totalScore += score;
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
