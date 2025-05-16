
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


// Frame format:
// C1|a1|C2|a2|JBin|90 = <analog1, analog2, digitals=JBin, EndOfFrame>
// Where:
// analog1 = C1x32+a1
// analog2 = C2x32+a2
// digitals = right|left|down|up
// EndOfFrame = 90 -> '\n'
import 'dart:math';

List<(AnalogInputs, DigitalInputs)> computeData(List<int> numberlist) {
  //final numbers = <int>[13, 5, 11, 16, 0, 90, 13, 7, 11, 22, 0, 90];
  List<(AnalogInputs, DigitalInputs)> res = [];

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

(AnalogInputs, DigitalInputs) computeInputList(List<int> liste) {

  final m1 = bytesToValue(coeff: liste[0], add: liste[1]);
  final m2 = bytesToValue(coeff: liste[2], add: liste[3]);
  final analogs = AnalogInputs(m1, m2);
  final digitals = DigitalInputs(liste[4]);
  return (analogs, digitals);
}

String describeInputs(List<int> liste) {
  if (liste.length != 5) {
    return 'not valid!';
  }
  final m1 = bytesToValue(coeff: liste[0], add: liste[1]);
  final m2 = bytesToValue(coeff: liste[2], add: liste[3]);
  final analogs = AnalogInputs(m1, m2);
  final digitals = DigitalInputs(liste[4]);
  final overall = analogs.describe() + '\n' + digitals.describe();
  return overall;
}

int bytesToValue({int coeff = 0, int add = 0}) {
  var res = coeff * 32 + add;
  return res;
}

class AnalogInputs {
  int analog1 = 0;
  int analog2 = 0;

  AnalogInputs(this.analog1, this.analog2);

  String describe() {
    return 'Analog1: $analog1, Analog2: $analog2';
  }
}

class DigitalInputs {
  late bool right;
  late bool left;
  late bool down;
  late bool up;

  DigitalInputs(int input) {
    this.right = input & 0x08 == 0x08;
    this.left = input & 0x04 == 0x04;
    this.down = input & 0x02 == 0x02;
    this.up = input & 0x01 == 0x01;
  }
  String describe() {
    return 'right: $right, left: $left, down: $down, up: $up';
  }
}

int rangeMap(int value, int min1, int max1, int min2, int max2) {
  double slope = (max2 - min2).toDouble() / (max1 - min1).toDouble();
  return min2 + (slope * (value - min1).toDouble()).round();
}

int calibrateForAmplitude(int value, int min1, int max1) {
  double slope = 100.0 / (max1 - min1).toDouble();
  return (slope * (value - min1).toDouble()).round();
}

int convertAngleToAnalog(int angle) {
  return rangeMap(angle, 0, 180, 0, 1000);
}

int calibrateAnalogInput(int value, int lower, int upper) {
  int lowerConvertedAngle = convertAngleToAnalog(lower);
  int higherConvertedAngle = convertAngleToAnalog(upper);
  double slope =
      1000.0 / (higherConvertedAngle - lowerConvertedAngle).toDouble();
  if (value >= lowerConvertedAngle) {
    return min(1000.0, (value - lowerConvertedAngle).toDouble() * slope)
        .round();
  } else {
    return 0;
  }
}
