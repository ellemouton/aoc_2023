import 'dart:io';
import 'dart:core';

const input1 = "/Users/elle/projects/AOC_2023/one/input.txt";
// const input2 = "/Users/elle/projects/AOC_2023/one/example2.txt";

void main() {
  // partOne();
  partTwo();
}

Map<String, List<String>> numStrs = {
  "o": ["one"],
  "t": ["two", "three"],
  "f": ["four", "five"],
  "s": ["six", "seven"],
  "e": ["eight"],
  "n": ["nine"],
};

Map<String, int> wordToInt = {
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9,
};

int total2 = 0;

void lineOp2(String line) {
  List<int> ints = [];

  int i = -1;
  while (i < line.length - 1) {
    i++;

    if (isInt(line[i])) {
      ints.add(int.parse(line[i]));
      continue;
    }

    List<String>? words = numStrs[line[i]];

    if (words == null) {
      continue;
    }

    int rem = line.length - i;

    String? numStr;
    for (String word in words) {
      // Are there even enough letters remaining for this word?
      if (rem < word.length) {
        continue;
      }

      // Check if those remaining letters match the word.
      if (line.substring(i, i + word.length) == word) {
        numStr = word;
        break;
      }
    }

    if (numStr != null) {
      int? i = wordToInt[numStr];
      if (i == null) {
        throw "not in word map";
      }

      ints.add(i);
    }
  }

  int n = (ints[0] * 10) + ints[ints.length - 1];
  total2 += n;
}

void partTwo() {
  forEachLine(input1, (line) => lineOp2(line));

  print(total2);
}

int total1 = 0;

void partOne() {
  forEachLine(input1, (line) => lineOp1(line));

  print(total1);
}

void lineOp1(String line) {
  // Find all non-numbers and remove.
  String str = line.replaceAll(new RegExp(r'[^0-9]'), '');

  // Concat the first and last number collected.
  str = str[0] + str[str.length - 1];

  // Convert to an int.
  int n = int.parse(str);

  // Increment the total.
  total1 += n;
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}

bool isInt(String s) {
  return int.tryParse(s) != null;
}
