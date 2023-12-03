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
  String str = line.replaceAll(new RegExp(r'[^0-9]'), '');

  if (str.length > 2) {
    str = str[0] + str[str.length - 1];
  } else if (str.length == 1) {
    str = str[0] + str[0];
  }

  int n = int.parse(str);

  total += n;
}

void forEachLine(Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  for (String line in lines) {
    f(line);
  }
}
