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
  // partOne();
  partTwo();
}

class BoundSet {
  Bounds x = Bounds(1, 4000);
  Bounds m = Bounds(1, 4000);
  Bounds a = Bounds(1, 4000);
  Bounds s = Bounds(1, 4000);

  BoundSet() {}

  BoundSet.copy(this.s, this.m, this.a, this.x);

  BoundSet copy() {
    return BoundSet.copy(s.copy(), m.copy(), a.copy(), x.copy());
  }

  int combo() {
    return x.range() * m.range() * a.range() * s.range();
  }

  display() {
    print(
        "x(${x.display()}) m(${m.display()}) a(${a.display()}) s(${s.display()})");
  }

  chopPass(Check check) {
    if (check.isJustDest()) {
      return;
    }

    switch (check.letter!) {
      case Letter.x:
        if (check.greaterThan!) {
          if (x.min <= check.number!) {
            x.min = check.number! + 1;
          }
        } else {
          if (x.max >= check.number!) {
            x.max = check.number! - 1;
          }
        }
      case Letter.m:
        if (check.greaterThan!) {
          if (m.min <= check.number!) {
            m.min = check.number! + 1;
          }
        } else {
          if (m.max >= check.number!) {
            m.max = check.number! - 1;
          }
        }
      case Letter.a:
        if (check.greaterThan!) {
          if (a.min <= check.number!) {
            a.min = check.number! + 1;
          }
        } else {
          if (a.max >= check.number!) {
            a.max = check.number! - 1;
          }
        }
      case Letter.s:
        if (check.greaterThan!) {
          if (s.min <= check.number!) {
            s.min = check.number! + 1;
          }
        } else {
          if (s.max >= check.number!) {
            s.max = check.number! - 1;
          }
        }
    }
  }

  chopFail(Check check) {
    switch (check.letter!) {
      case Letter.x:
        if (check.greaterThan!) {
          if (x.max > check.number!) {
            x.max = check.number!;
          }
        } else {
          if (x.min < check.number!) {
            x.min = check.number!;
          }
        }
      case Letter.m:
        if (check.greaterThan!) {
          if (m.max > check.number!) {
            m.max = check.number!;
          }
        } else {
          if (m.min < check.number!) {
            m.min = check.number!;
          }
        }
      case Letter.a:
        if (check.greaterThan!) {
          if (a.max > check.number!) {
            a.max = check.number!;
          }
        } else {
          if (a.min < check.number!) {
            a.min = check.number!;
          }
        }
      case Letter.s:
        if (check.greaterThan!) {
          if (s.max > check.number!) {
            s.max = check.number!;
          }
        } else {
          if (s.min < check.number!) {
            s.min = check.number!;
          }
        }
    }
  }
}

class Bounds {
  int min = 1;
  int max = 4000;

  String display() {
    return "$min-$max";
  }

  int range() {
    if (max < min) {
      return 0;
    }

    return max - min + 1;
  }

  Bounds(this.min, this.max);

  Bounds copy() {
    return Bounds(min, max);
  }
}

void partTwo() {
  forEachLine(input, (line) => lineOp1(line));

  List<BoundSet> sets = doThings(BoundSet(), "A");

  int total = 0;
  sets.forEach((element) {
    total += element.combo();
  });

  print(total);
}

List<BoundSet> doThings(BoundSet startingSet, String targetDest) {
  List<BoundSet> res = [];
  workflows.forEach((key, checks) {
    // For each check with the target destination.
    for (int i = 0; i < checks.length; i++) {
      // If we find an "A" destination, then initiate a new bounds and
      // chop so that all previous checks in this set _fail_ but this one
      // should pass.
      if (checks[i].dest != targetDest) {
        continue;
      }

      // Construct new bounds.
      BoundSet bounds = startingSet.copy();
      for (int j = 0; j < i; j++) {
        // every check before should fail.
        bounds.chopFail(checks[j]);
      }

      // This check should pass.
      bounds.chopPass(checks[i]);

      // If this is the "in" workflow, then we are done here.
      if (key == "in") {
        res.add(bounds);
        return;
      }

      // Now, we need to do some recursion to find the bounds that would lead to
      // this workflow.
      res.addAll(doThings(bounds, key));
    }
  });

  return res;
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
