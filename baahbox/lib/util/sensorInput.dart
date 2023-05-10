String computeData(List<int>? numberlist) {
  //final numbers = <int>[13, 5, 11, 16, 0, 90, 13, 7, 11, 22, 0, 90];
  var res = '';
  if (numberlist != null) {
    var numbers = numberlist;
  while (numbers.contains(90)) {
    var pos = numbers.indexOf(90);
    var result = numbers.takeWhile((x) => x != 90); // (1, 2)
    var input = computeInputs(result.toList());
    print(result);
    print(input);
    res += input;
    res += '\n';
    numbers.removeRange(0, pos + 1);
  };
}
  return res;
}

String computeInputs(List<int> liste) {
  if (liste.length != 5) {
    return 'not valid!';
  }
  final m1 = bytesToValue(coeff: liste[0], add: liste[1]);
  final m2 = bytesToValue(coeff: liste[2], add: liste[3]);
  final muscles = MusclesInput(m1, m2);
  final joystick = JoystickInput(liste[4]);
  final overall = muscles.describe() + '\n' + joystick.describe();
  return overall;
}

int bytesToValue({int coeff = 0, int add = 0}) {
  var res = coeff * 32 + add;
  return res;
}

class MusclesInput {
  int muscle1 = 0;
  int muscle2 = 0;

  MusclesInput(this.muscle1, this.muscle2);

  String describe() {
    return 'Muscle1: $muscle1, Muscle2: $muscle2';
  }
}

class JoystickInput {
  late bool right;
  late bool left;
  late bool down;
  late bool up;

  JoystickInput(int input) {
    this.right = input & 0x08 == 0x08;
    this.left = input & 0x08 == 0x04;
    this.down = input & 0x08 == 0x02;
    this.up = input & 0x08 == 0x01;
  }
  String describe() {
    return 'right: $right, left: $left, down: $down, up: $up';
  }
}
