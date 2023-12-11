import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/five/input.txt";

void main() {
  // partOne();
  partTwo();
}

class Range {
  late int start;
  late int range;
  late int end;

  Range(this.start, this.range) {
    end = this.start + this.range - 1;

    if (this.start == 0) {
      print("created range with $start, $range");
    }
  }

  display() {
    print("$start - $end");
  }
}

void partTwo() {
  forEachLine(input, (line) => lineOp1(line));
  if (map.length > 0) {
    map.sort((a, b) {
      if (a.srcStart < b.srcStart) {
        return -1;
      }
      if (a.srcStart > b.srcStart) {
        return 1;
      }

      return 0;
    });
    mapSet.add(map);
    map = [];
  }

  for (int i = 0; i < seeds.length; i += 2) {
    print("doing seed ${seeds[i]}");
    Range seed = Range(seeds[i], seeds[i + 1]);
    int loc = getMinSeedLocFromRange(seed);
    if (minLoc == -1 || loc < minLoc) {
      minLoc = loc;
    }
  }

  print(minLoc);
}

class FromTo {
  late int srcStart;
  late int destStart;
  late int range;

  FromTo(this.srcStart, this.destStart, this.range);

  display() {
    print("$destStart, $srcStart, $range");
  }
}

List<FromTo> map = [];

List<List<FromTo>> mapSet = [];

List<int> seeds = [];
int minLoc = -1;
void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  // Start a new map.
  if (map.length > 0) {
    map.sort((a, b) {
      if (a.srcStart < b.srcStart) {
        return -1;
      }
      if (a.srcStart > b.srcStart) {
        return 1;
      }

      return 0;
    });
    mapSet.add(map);
    map = [];
  }

  for (int seed in seeds) {
    int loc = getSeedLocation(seed);
    if (minLoc == -1 || loc < minLoc) {
      minLoc = loc;
    }
  }

  print(minLoc);
}

int getMinSeedLocFromRange(Range input) {
  List<Range> inputs = [input];

  for (int i = 0; i < mapSet.length; i++) {
    List<Range> outputs = convertInputs(inputs, i);
    inputs = outputs;
  }

  int minLoc = -1;
  for (Range input in inputs) {
    if (minLoc == -1 || input.start < minLoc) {
      minLoc = input.start;
    }
  }

  return minLoc;
}

List<Range> convertInputs(List<Range> inputs, int mapIndex) {
  List<Range> outputs = [];
  for (Range input in inputs) {
    outputs.addAll(convert(input, mapIndex));
  }

  return outputs;
}

List<Range> convert(Range input, int mapIndex) {
  List<FromTo> map = mapSet[mapIndex];
  List<Range> outputs = [];

  Range current = input;
  bool done = false;

  for (FromTo range in map) {
    int end = range.srcStart + range.range - 1;

    // If the current range is completely below the range we are looking at, we
    // can just map it 1:1.
    if (current.end < range.srcStart) {
      outputs.add(Range(current.start, current.range));
      done = true;
      break;
    }

    // If there is a section of current that lies before this range, then it can
    // be mapped one-to-one and we can chop off the start of current.
    if (current.start < range.srcStart) {
      outputs.add(Range(current.start, range.srcStart - current.start));
      current = Range(range.srcStart, current.end - range.srcStart + 1);
    }

    // If the current range is completely within the range we are looking at,
    // then we can map the whole thing in one go and exit early.
    if (current.start >= range.srcStart && current.end <= end) {
      int diff = current.start - range.srcStart;
      outputs.add(Range(range.destStart + diff, current.range));
      done = true;
      break;
    }

    // If the current range is completely above the range we are looking at,
    // then we continue to the next range.
    if (current.start > end) {
      continue;
    }

    // The tail of current lies within the range. Map the tail and add that to
    // the output. Then update the current to just be the head.
    if (current.start < range.srcStart && current.end <= end) {
      int rangeCovered = current.end - range.srcStart + 1;

      outputs.add(Range(range.destStart, rangeCovered));
      current = Range(current.start, range.srcStart - current.start);
      continue;
    }

    // The head of current lies within the range. Map the head and add that to
    // the output. Then update the current to just be the tail.
    if (current.end > end && current.start >= range.srcStart) {
      int diff = current.start - range.srcStart;
      int rangeCovered = end - current.start + 1;

      outputs.add(Range(range.destStart + diff, rangeCovered));
      current = Range(end + 1, current.end - end);
      continue;
    }

    // The range is completely within current. That means we should:
    // Break off the head
  }

  if (!done) {
    outputs.add(current);
  }

  return outputs;
}

int getSeedLocation(int seed) {
  int input = seed;
  int output = 0;
  for (List<FromTo> map in mapSet) {
    output = getDest(input, map);
    input = output;
  }

  return output;
}

int getDest(int input, List<FromTo> map) {
  for (FromTo range in map) {
    int end = range.srcStart + range.range;
    if (input >= range.srcStart && input < end) {
      int diff = input - range.srcStart;

      return range.destStart + diff;
    }
  }

  return input;
}

bool busy = false;
void lineOp1(String line) {
  // Seeds.
  if (line.contains("seeds")) {
    List<String> seedsStrs =
        line.substring(line.indexOf(':') + 1).trim().split(" ");

    for (String s in seedsStrs) {
      seeds.add(int.parse(s));
    }

    return;
  }

  // Empty lines.
  if (line.trim().length == 0) {
    return;
  }

  if (line.contains("map")) {
    // Start a new map.
    if (map.length > 0) {
      map.sort((a, b) {
        if (a.srcStart < b.srcStart) {
          return -1;
        }
        if (a.srcStart > b.srcStart) {
          return 1;
        }

        return 0;
      });
      mapSet.add(map);
      map = [];
    }

    return;
  }

  // Else, it is a range line.
  List<String> ns = line.split(" ");
  if (ns.length != 3) {
    throw ("must have 3 numbers");
  }

  int dst = int.parse(ns[0]);
  int src = int.parse(ns[1]);
  int range = int.parse(ns[2]);

  map.add(FromTo(src, dst, range));
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
