import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/fifteen/input.txt";

void main() {
  partOne();
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
