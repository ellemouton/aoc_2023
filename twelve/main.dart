import 'dart:io';
import 'dart:math';

const input = "/Users/elle/projects/AOC_2023/twelve/input.txt";

void main() {
  partOne();
}

class Line {
  String input;
  List<int> nums;

  Line(this.input, this.nums);
}

List<Line> lines = [];

class Group {
  String value;
  int numUnknown;
  int numBroken;

  Group(this.value, this.numUnknown, this.numBroken);
}

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  int total = 0;
  for (Line l in lines) {
    int n = countConfigurations(l, "");
    total += n;
  }

  print(total);
}

int countConfigurations(Line l, String inset) {
  if (l.nums.length == 0) {
    if (l.input.contains("#")) {
      return 0;
    }
    return 1;
  }

  // Determine how many possible starting points the very first placement will
  // have. Do this by determining the tightest possible space that all the parts
  // can fit into if squashed to the end.
  int sumVals = 0;
  l.nums.forEach((element) {
    sumVals += element;
  });

  int smallestSpace = sumVals + l.nums.length - 1;

  // final config should have this as the start value.
  int maxStart = l.input.length - smallestSpace;

  int configs = 0;
  for (int start = 0; start <= maxStart; start++) {
    String conf = "";
    bool skipConf = false;
    int lineIndex = 0;

    // Add prefix dots.
    for (int dot = 0; dot < start && lineIndex < l.input.length; dot++) {
      conf += ".";

      if (l.input[lineIndex] == "#") {
        skipConf = true;
        break;
      }

      lineIndex++;
    }

    if (skipConf) {
      continue;
    }

    // Add thing.
    for (int thing = 0;
        thing < l.nums[0] && lineIndex < l.input.length;
        thing++) {
      conf += "#";
      if (l.input[lineIndex] == ".") {
        skipConf = true;
        break;
      }

      lineIndex++;
    }

    if (skipConf) {
      continue;
    }

    // If there is space, add a postfix dot.
    if (conf.length < l.input.length && lineIndex < l.input.length) {
      conf += ".";
      if (l.input[lineIndex] == "#") {
        skipConf = true;
        continue;
      }

      lineIndex++;
    }

    if (skipConf) {
      continue;
    }

    String totalInset = inset + conf;

    configs += countConfigurations(
        Line(l.input.substring(lineIndex), l.nums.sublist(1)), totalInset);
  }

  return configs;
}

void lineOp1(String line) {
  String input = line.substring(0, line.indexOf(" "));

  String numsStr = line.substring(line.indexOf(" ") + 1);
  List<String> nums = numsStr.split(",");

  List<int> ns = [];
  for (int i = 0; i < nums.length; i++) {
    ns.add(int.parse(nums[i]));
  }

  lines.add(Line(input, ns));
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
