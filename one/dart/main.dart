import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/one/input.txt";

int total = 0;

void main() {
  partOne();
}

void partOne() {
  forEachLine((line) => lineOp(line));

  print(total);
}

void lineOp(String line) {
  // Find all non-numbers and remove.
  String str = line.replaceAll(new RegExp(r'[^0-9]'), '');

  // Concat the first and last number collected.
  str = str[0] + str[str.length - 1];

  // Convert to an int.
  int n = int.parse(str);

  // Increment the total.
  total += n;
}

void forEachLine(Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
