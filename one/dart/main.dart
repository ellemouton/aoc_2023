import 'dart:io';

void main() {
  File file = File("/Users/elle/projects/AOC_2023/one/input.txt");
  List<String> lines = file.readAsLinesSync();

  int total = 0;
  for (String line in lines) {
    String str = line.replaceAll(new RegExp(r'[^0-9]'), '');

    if (str.length > 2) {
      str = str[0] + str[str.length - 1];
    } else if (str.length == 1) {
      str = str[0] + str[0];
    }

    int n = int.parse(str);

    total += n;
  }

  print(total);
}
