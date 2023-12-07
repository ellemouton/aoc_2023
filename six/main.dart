void main() {
  // partOne();
  partTwo(p2Input);
}

Pair p2Example = Pair(71530, 940200);
Pair p2Input = Pair(58819676, 434104122191218);

void partTwo(Pair p) {
  // Find the lower bound.

  int lower = 0;
  for (int i = 1; i < p.t; i++) {
    if (i * (p.t - i) > p.d) {
      lower = i;
      break;
    }
  }

  int upper = p.t;
  for (int i = p.t; i > 0; i--) {
    if (i * (p.t - i) > p.d) {
      upper = i;
      break;
    }
  }

  print("lower is $lower");
  print("upper is $upper");

  print("num ways: ${upper - lower + 1}");
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
