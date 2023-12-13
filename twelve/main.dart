import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/twelve/input.txt";

void main() {
  // partOne();
  partTwo();
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

class Cache {
  Map<String, int> _cache = {};

  void add(int remainingNums, int lineIndex, int count) {
    String key = _cacheKey(remainingNums, lineIndex);

    _cache[key] = count;
  }

  int? getCount(int remainingNums, int lineIndex) {
    String key = _cacheKey(remainingNums, lineIndex);

    return _cache[key];
  }

  String _cacheKey(int remainingNums, int lineIndex) {
    return "$remainingNums-$lineIndex";
  }
}

void partTwo() {
  forEachLine(input, (line) => lineOp1(line, 5));

  int total = 0;
  for (Line l in lines) {
    Cache cache = Cache();
    int n = countConfigurations(l.input, 0, l.nums, cache);
    total += n;
  }

  print(total);
}

void partOne() {
  forEachLine(input, (line) => lineOp1(line, 1));

  int total = 0;
  for (Line l in lines) {
    Cache cache = Cache();
    int n = countConfigurations(l.input, 0, l.nums, cache);
    total += n;
  }

  print(total);
}

int countConfigurations(
    String input, int inputIndex, List<int> nums, Cache cache) {
  String remainingInput = input.substring(inputIndex);

  // Check the cache to see if we have a stored value for this config. Return
  // it if we do.
  int? count = cache.getCount(nums.length, inputIndex);
  if (count != null) {
    return count;
  }

  // If there are no more numbers left to place, then this was either a valid
  // config or not.
  if (nums.length == 0) {
    // It was not a valid config if the remainder of the line still had a
    // manditory "#" that needed to be placed.
    if (remainingInput.contains("#")) {
      return 0;
    }

    // Otherwise, it was a single valid configuration.
    return 1;
  }

  // Determine how many possible starting points the very first placement will
  // have. Do this by determining the tightest possible space that all the parts
  // can fit into if squashed to the end.
  int sumVals = 0;
  nums.forEach((element) {
    sumVals += element;
  });

  int smallestSpace = sumVals + nums.length - 1;

  // final config should have this as the start value.
  int maxStart = remainingInput.length - smallestSpace;

  int configs = 0;
  for (int start = 0; start <= maxStart; start++) {
    // String conf = "";
    bool skipConf = false;
    int lineIndex = 0;

    // Increase te index for each prefix dot.
    for (int dot = 0; dot < start; dot++) {
      // Exit early if this clashes with a manditory #.
      if (remainingInput[lineIndex] == "#") {
        skipConf = true;
        break;
      }

      lineIndex++;
    }

    if (skipConf) {
      continue;
    }

    // Add the #s.
    for (int hashCount = 0; hashCount < nums[0]; hashCount++) {
      // Exit early if this clashes with a manditory ".".
      if (remainingInput[lineIndex] == ".") {
        skipConf = true;
        break;
      }

      lineIndex++;
    }

    if (skipConf) {
      continue;
    }

    // If there is space, add a postfix dot.
    if (lineIndex < remainingInput.length) {
      // Exit early if this clashes with a manditory #.
      if (remainingInput[lineIndex] == "#") {
        skipConf = true;
        continue;
      }

      lineIndex++;
    }

    if (skipConf) {
      continue;
    }

    configs += countConfigurations(
        input, inputIndex + lineIndex, nums.sublist(1), cache);
  }

  // Before returning, ensure to add this result to the cache.
  cache.add(nums.length, inputIndex, configs);

  return configs;
}

void lineOp1(String line, int mul) {
  String input = line.substring(0, line.indexOf(" "));

  String finalInput = "";
  for (int m = 0; m < mul; m++) {
    finalInput += input;

    if (m < mul - 1) {
      finalInput += "?";
    }
  }

  String numsStr = line.substring(line.indexOf(" ") + 1);
  List<String> nums = numsStr.split(",");

  List<int> ns = [];
  for (int m = 0; m < mul; m++) {
    for (int i = 0; i < nums.length; i++) {
      ns.add(int.parse(nums[i]));
    }
  }

  lines.add(Line(finalInput, ns));
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
