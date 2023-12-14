import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/fourteen/input.txt";

void main() {
  partOne();
}

List<List<String>> flipped = [];

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  // I flipped the input, so rolling north is now just rolling left
  // which can just be solved line by line.
  int totalLoad = 0;
  flipped.forEach((line) {
    totalLoad += calcLoad(line);
  });

  print(totalLoad);
}

int calcLoad(List<String> line) {
  int barrier = -1;
  int load = 0;
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
      load += line.length - (finalPos);
    }
  }

  return load;
}

void lineOp1(String line) {
  for (int i = 0; i < line.length; i++) {
    if (i == flipped.length) {
      flipped.add([]);
    }

    flipped[i].add(line[i]);
  }
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
