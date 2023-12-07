import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/five/input.txt";

void main() {
  // partOne();
  partTwo();
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
    print("doing seed $i");
    int current = seeds[i];
    int range = seeds[i + 1];

    for (int j = 0; j < range; j++) {
      int loc = getSeedLocation(current + j);
      if (minLoc == -1 || loc < minLoc) {
        minLoc = loc;
      }
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
