
/*
 * Baah Box
 * Copyright (c) 2024. Orange SA
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

List<(MusclesInput, JoystickInput)> computeData(List<int> numberlist) {
  //final numbers = <int>[13, 5, 11, 16, 0, 90, 13, 7, 11, 22, 0, 90];
  List<(MusclesInput, JoystickInput)> res = [];

  for (List<int> input in splitInput(numberlist)) {
    res.add(computeInputList(input));
  }
  return res;
}

List splitInput(List<int> numberlist) {
  var res = [];
  var numbers = numberlist.toList();

  while (numbers.contains(90)) {
    var pos = numbers.indexOf(90);
    var set = numbers.takeWhile((x) => x != 90); // (1, 2)
    if (set.length == 5) {
      res.add(set.toList());
    }
    numbers.removeRange(0, pos + 1);
  }
  return res;
}

(MusclesInput, JoystickInput) computeInputList(List<int> liste) {

  final m1 = bytesToValue(coeff: liste[0], add: liste[1]);
  final m2 = bytesToValue(coeff: liste[2], add: liste[3]);
  final muscles = MusclesInput(m1, m2);
  final joystick = JoystickInput(liste[4]);
  return (muscles, joystick);
}

String describeInputs(List<int> liste) {
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
    this.left = input & 0x04 == 0x04;
    this.down = input & 0x02 == 0x02;
    this.up = input & 0x01 == 0x01;
  }
  String describe() {
    return 'right: $right, left: $left, down: $down, up: $up';
  }
}
