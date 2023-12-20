import 'dart:io';
import 'dart:math';

const input = "/Users/elle/projects/AOC_2023/nineteen/input.txt";

Map<String, List<Check>> workflows = {};
List<PartSet> parts = [];

class Check {
  Letter? letter;
  bool? greaterThan;
  int? number;
  late String dest;

  Check(String dest, {this.letter, this.greaterThan, this.number}) {
    this.dest = dest;
  }

  bool isJustDest() {
    return letter == null;
  }

  bool passes(PartSet p) {
    // Get relevant part.
    Part part = p.a;
    if (letter == Letter.m) {
      part = p.m;
    } else if (letter == Letter.s) {
      part = p.s;
    } else if (letter == Letter.x) {
      part = p.x;
    }

    if (greaterThan!) {
      return part.rating > this.number!;
    }
    return part.rating < this.number!;
  }

  display() {
    if (letter != null) {
      print("$letter $greaterThan $number: $dest");
    } else {
      print("$dest");
    }
  }
}

class PartSet {
  Part x;
  Part m;
  Part a;
  Part s;

  PartSet(this.x, this.m, this.a, this.s);
}

class Part {
  Letter letter;
  int rating;

  Part(this.letter, this.rating);
}

enum Letter {
  x,
  m,
  a,
  s,
}

Letter strToLetter(String s) {
  switch (s) {
    case "x":
      return Letter.x;
    case "m":
      return Letter.m;
    case "a":
      return Letter.a;
    case "s":
      return Letter.s;
  }

  throw ("bad");
}

void main() {
  partOne();
}

void partOne() {
  forEachLine(input, (line) => lineOp1(line));

  int total = 0;
  parts.forEach((set) {
    String dest = "in";
    while (dest != "A" && dest != "R") {
      dest = nextDest(dest, set);
    }

    if (dest == "A") {
      total += set.a.rating + set.m.rating + set.s.rating + set.x.rating;
    }
  });

  print(total);
}

String nextDest(String workflowName, PartSet set) {
  // Get workflow:
  List<Check> checks = workflows[workflowName]!;

  // Go through each check to see if it applies and
  // until we get a new destination.
  for (int i = 0; i < checks.length; i++) {
    if (checks[i].isJustDest()) {
      return checks[i].dest;
    }

    if (checks[i].passes(set)) {
      return checks[i].dest;
    }
  }

  throw ("should not get here I think");
}

bool readRatings = false;
void lineOp1(String line) {
  if (line.trim() == "") {
    readRatings = true;
    return;
  }

  List<Check> cs = [];

  if (!readRatings) {
    String name = line.substring(0, line.indexOf("{"));

    List<String> checks =
        line.substring(line.indexOf("{") + 1, line.indexOf("}")).split(",");

    for (int i = 0; i < checks.length; i++) {
      String c = checks[i];

      // If the check doesnt have a ":", then it is just a desination.
      if (!c.contains(":")) {
        cs.add(Check(c));
        continue;
      }

      // Else, it does. So parse: <letter><gt/lt><dest>
      int colonIndex = c.indexOf(":");
      String dest = c.substring(colonIndex + 1);

      String letter = "";
      bool greaterThan = false;
      String number = "";
      if (c.contains(">")) {
        letter = c.substring(0, c.indexOf(">"));
        number = c.substring(c.indexOf(">") + 1, colonIndex);
        greaterThan = true;
      } else {
        letter = c.substring(0, c.indexOf("<"));
        number = c.substring(c.indexOf("<") + 1, colonIndex);
      }

      cs.add(Check(dest,
          letter: strToLetter(letter),
          number: int.parse(number),
          greaterThan: greaterThan));
    }

    workflows[name] = cs;

    return;
  }

  List<String> values =
      line.substring(line.indexOf("{") + 1, line.indexOf("}")).split(",");

  Part? x;
  Part? m;
  Part? a;
  Part? s;

  values.forEach((element) {
    int eq = element.indexOf("=");

    String letStr = element.substring(0, eq);
    Letter let = strToLetter(letStr);

    int number = int.parse(element.substring(eq + 1));

    switch (let) {
      case Letter.x:
        x = Part(Letter.x, number);
      case Letter.m:
        m = Part(Letter.m, number);
      case Letter.a:
        a = Part(Letter.a, number);
      case Letter.s:
        s = Part(Letter.s, number);
    }
  });

  parts.add(PartSet(x!, m!, a!, s!));
}

void forEachLine(String input, Function(String) f) {
  File file = File(input);
  List<String> lines = file.readAsLinesSync();

  lines.forEach((line) => f(line));
}
