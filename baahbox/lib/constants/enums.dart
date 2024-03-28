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

import 'dart:ui';

enum ObjectVelocity {
  low(value: 1),
  medium(value: 2),
  high(value: 3);

  const ObjectVelocity({required this.value});
  final int value;
}

enum Sensitivity {
  low(value: 1),
  medium(value: 2),
  high(value: 3);

  const Sensitivity({required this.value});
  final int value;
}

enum ShootingType {
  automatic,
  manual;
}

enum SensorType {
  none,
  muscle,
  arcadeJoystick,
  button,
  digitalJoystick,
  wheelChairJoystick;
}

enum BBColor implements Comparable<BBColor> {
  beurkGreen(sRGB: 0xFFCEAF17),
  blueGreen(sRGB: 0xFF085559),
  greenDash(sRGB: 0xFF3A9B8D),
  greyGreen(sRGB: 0xFF86A2A3),
  lightGreen(sRGB: 0xFFA2CC81),
  orange(sRGB: 0xFFE26F3B),
  pinky(sRGB: 0xFFF98885),
  violet(sRGB: 0xFF70576E);

  const BBColor({required this.sRGB});
  final int sRGB;
  Color get color => Color(this.sRGB) as Color;

  @override
  int compareTo(BBColor other) => sRGB - other.sRGB;
}

enum GameState {
  // notStarted,
  // onGoing,
  // halted,
  // ended;
  initializing,
  ready,
  running,
  paused,
  won,
  lost;
}

enum BBGameList {
  star(
      title: "Fais briller le ciel !",
      mainAsset: 'assets/images/Dashboard/menu_etoile@2x.png',
      baseColor: BBColor.violet,
      numberOfSensors: 1),
  balloon(
      title: 'Fais exploser le ballon !',
      mainAsset: 'assets/images/Dashboard/menu_ballon@2x.png',
      baseColor: BBColor.orange,
      numberOfSensors: 1),
  sheep(
    title: 'Saute, mouton, saute !',
    mainAsset: 'assets/images/Dashboard/menu_mouton@2x.png',
    baseColor: BBColor.pinky,
    numberOfSensors: 1,
  ),
  starship(
    title: "La bataille de l'espace",
    mainAsset: 'assets/images/Dashboard/menu_espace@2x.png',
    baseColor: BBColor.blueGreen,
    numberOfSensors: 2,
  ),
  toad(
    title: 'Slurp',
    mainAsset: 'assets/images/Dashboard/menu_gobe@2x.png',
    baseColor: BBColor.greyGreen,
    numberOfSensors: 2,
  );

  const BBGameList({
    required this.title,
    required this.mainAsset,
    required this.baseColor,
    required this.numberOfSensors,
  });

  final String title;
  final String mainAsset;
  final BBColor baseColor;
  final int numberOfSensors;
}
