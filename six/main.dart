import 'dart:io';

//const input = "/Users/elle/projects/AOC_2023/six/example.txt";

void main() {
  partOne();
}

class Pair {
  late int t;
  late int d;

  Pair(this.t, this.d);

  display() {
    print("$t, $d");
  }
}

// List<Pair> example = [
//   Pair(7, 9),
//   Pair(15, 40),
//   Pair(30, 200),
// ];

List<Pair> input = [
  Pair(58, 434),
  Pair(81, 1041),
  Pair(96, 2219),
  Pair(76, 1218),
];

void partOne() {
  int margin = 1;
  for (Pair p in input) {
    int count = evalPair(p);
    margin *= count;
  }

  print(margin);
}

int evalPair(Pair p) {
  int count = 0;
  for (int i = 1; i < p.t; i++) {
    if (i * (p.t - i) > p.d) {
      count++;
    }
  }

  return count;
}
