import 'dart:io';

const input = "/Users/elle/projects/AOC_2023/seven/input.txt";

void main() {
  partOne();
}

List<Pair> pairs = [];

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  pairs.sort((a, b) {
    // First, just look at hand type.
    if (handTypeToInt(a.type) < handTypeToInt(b.type)) {
      return -1;
    }

    if (handTypeToInt(a.type) > handTypeToInt(b.type)) {
      return 1;
    }

    // Now look at individual items.
    for (int i = 0; i < a.hand.length; i++) {
      if (ranks.indexOf(a.hand[i]) < ranks.indexOf(b.hand[i])) {
        return -1;
      }

      if (ranks.indexOf(a.hand[i]) > ranks.indexOf(b.hand[i])) {
        return 1;
      }
    }

    return 0;
  });

  int total = 0;
  for (int i = 1; i <= pairs.length; i++) {
    pairs[i - 1].display();
    total += (i * pairs[i - 1].bid);
  }

  print(total);
}

const String ranks = "23456789TJQKA";

enum HandType {
  fiveOfAKind,
  fourOfAKind,
  fullHouse,
  threeOfAKind,
  twoPair,
  onePair,
  highCard
}

int handTypeToInt(HandType h) {
  switch (h) {
    case HandType.fiveOfAKind:
      return 6;
    case HandType.fourOfAKind:
      return 5;
    case HandType.fullHouse:
      return 4;
    case HandType.threeOfAKind:
      return 3;
    case HandType.twoPair:
      return 2;
    case HandType.onePair:
      return 1;
    case HandType.highCard:
      return 0;
  }
}

class Pair {
  late String hand;
  late int bid;
  late HandType type;

  Pair(this.hand, this.bid) {
    type = classify(hand);
  }

  display() {
    print("$hand is type: $type");
  }
}

void lineOp1(String line) {
  List<String> parts = line.split(" ");
  String hand = parts[0];
  int bid = int.parse(parts[1]);

  Pair p = Pair(hand, bid);
  pairs.add(p);
}

HandType classify(String hand) {
  Map<String, int> counts = {};

  for (int i = 0; i < hand.length; i++) {
    if (counts[hand[i]] == null) {
      counts[hand[i]] = 1;

      continue;
    }

    counts[hand[i]] = counts[hand[i]]! + 1;
  }

  Map<int, int> groupCount = {};
  counts.forEach((thing, count) {
    if (groupCount[count] == null) {
      groupCount[count] = 1;
      return;
    }

    groupCount[count] = groupCount[count]! + 1;
  });

  if (groupCount[5] == 1) {
    return HandType.fiveOfAKind;
  }

  if (groupCount[4] == 1) {
    return HandType.fourOfAKind;
  }

  if (groupCount[3] == 1 && groupCount[2] == 1) {
    return HandType.fullHouse;
  }

  if (groupCount[3] == 1) {
    return HandType.threeOfAKind;
  }

  if (groupCount[2] == 2) {
    return HandType.twoPair;
  }

  if (groupCount[2] == 1) {
    return HandType.onePair;
  }

  return HandType.highCard;
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
