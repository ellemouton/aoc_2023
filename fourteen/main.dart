import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/fourteen/input.txt";

void main() {
  // partOne();
  partTwo(); // 90176
}

MapCache mapCache = MapCache();

void partTwo() {
  forEachLine(input, (line) => lineOp1(line));

  // Rotate anti clockwise once to get North to be left.
  rotateMapAntiClockWise();

  int cycles = 1000000000;

  for (int i = 0; i < cycles; i++) {
    String mapKey = mapCache.serialiseMap();

    // Check the cache to see if we have the result of this entire cycle.
    String? resMap = mapCache.getSerialisedRes(mapKey);
    if (resMap != null) {
      mapCache.populateMapFrom(resMap);

      // If resMap is _also_ in the cache - then we found the cycle.
      String? cycle = mapCache.getSerialisedRes(resMap);
      if (cycle != null) {
        // Cycle detected!! No reason to continue looping.
        break;
      }

      continue;
    }

    for (int j = 0; j < map.length; j++) {
      tilt(map[j], j);
    }

    // Rotate clockwise to get West left.
    rotateMapClockWise();

    for (int j = 0; j < map.length; j++) {
      tilt(map[j], j);
    }

    // Rotate clockwise to get South left.
    rotateMapClockWise();

    for (int j = 0; j < map.length; j++) {
      tilt(map[j], j);
    }

    // Rotate clockwise to get East left.
    rotateMapClockWise();

    for (int j = 0; j < map.length; j++) {
      tilt(map[j], j);
    }

    // Rotate clockwise to get North left.
    rotateMapClockWise();

    String to = mapCache.serialiseMap();
    mapCache.add(mapKey, to);
  }

  String start = mapCache.indexToFrom[0]!;
  bool busy = true;
  int index = 0;
  int cycleStart = 0;
  while (busy) {
    int newIndex = mapCache.fromToIndex[start]!;

    start = mapCache.getSerialisedRes(start)!;

    if (newIndex < index) {
      cycleStart = newIndex;
      break;
    }
    index = newIndex;
  }

  print("cycle starts at: $cycleStart");

  int resIndex =
      ((cycles - cycleStart) % (mapCache.fromToIndex.length - cycleStart)) +
          cycleStart -
          1;

  String finalFrom = mapCache.indexToFrom[resIndex]!;
  String finalTo = mapCache.getSerialisedRes(finalFrom)!;
  mapCache.populateMapFrom(finalTo);

  // rotate once more to get North at the top.
  rotateMapClockWise();

  print(calcLoad());
}

void rotateMapClockWise() {
  List<List<String>> newMap = [];
  int xLen = map[0].length;

  for (int i = 0; i < xLen; i++) {
    newMap.add([]);

    for (int j = map.length - 1; j >= 0; j--) {
      String itemToMove = map[j][i];

      newMap[i].add(itemToMove);
    }
  }
  map = newMap;
}

void rotateMapAntiClockWise() {
  List<List<String>> newMap = [];
  for (int i = 0; i < map.length; i++) {
    for (int j = map[i].length - 1; j >= 0; j--) {
      String itemToMove = map[i][j];

      int newY = map[i].length - j;

      while (newMap.length <= newY) {
        newMap.add([]);
      }

      newMap[newY].add(itemToMove);
    }
  }
  map = newMap.sublist(1);
}

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  // Rotate anti clockwise.
  rotateMapAntiClockWise();

  int i = 0;
  map.forEach((line) {
    tilt(
      line,
      i,
    );
    i++;
  });

  // Rotate it back.
  rotateMapClockWise();

  print(calcLoad());
}

int calcLoad() {
  int load = 0;
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      if (map[i][j] != "O") {
        continue;
      }

      load += map.length - i;
    }
  }

  return load;
}

class MapCache {
  // map from [serialised map -> resulting map after 1 cycle.]
  Map<String, String> _cache = {};

  Map<int, String> indexToFrom = {};
  Map<String, int> fromToIndex = {};

  int index = 0;

  void add(String from, String to) {
    _cache[from] = to;

    indexToFrom[index] = from;
    fromToIndex[from] = index;

    index++;
  }

  String? getSerialisedRes(String from) {
    return _cache[from];
  }

  void populateMapFrom(String s) {
    map = [];
    List<String> lines = s.split(" ");
    lines.forEach((line) {
      map.add(line.split(""));
    });
  }

  String serialiseMap() {
    List<String> lines = [];
    map.forEach((line) {
      lines.add(line.join(""));
    });

    return lines.join(" ");
  }
}

void tilt(List<String> line, int lineIndex) {
  String startingLine = line.join("");

  int barrier = -1;
  for (int i = 0; i < line.length; i++) {
    if (line[i] == "#") {
      barrier = i;
      continue;
    }

    if (line[i] == ".") {
      continue;
    }

    if (line[i] == "O") {
      // Between the barrier and current position, is there somewhere
      // we can move this rock?.
      int finalPos = i;
      for (int s = barrier + 1; s < i; s++) {
        if (line[s] != ".") {
          continue;
        }

        // Found a free space. Put the rock there and remove
        // it from here.
        line[s] = "O";
        line[i] = ".";

        finalPos = s;

        break;
      }

      barrier = finalPos;
    }
  }
}

List<List<String>> map = [];

void lineOp1(String line) {
  map.add(line.split(""));
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
