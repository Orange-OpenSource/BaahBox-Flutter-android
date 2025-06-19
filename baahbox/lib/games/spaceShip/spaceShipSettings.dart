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

import 'package:baahbox/services/settings/settingsController.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/enums.dart';
import '../../model/AnalogicSensor.dart';

class SpaceShipSettings {
  late final SharedPreferences prefs;

  late Rx<ObjectVelocity> _asteroidVelocity ;
  late RxInt _numberOfShips;

  late MuscleSettings muscleSettings;

  SpaceShipSettings({required this.prefs}) {
    _asteroidVelocity = (ObjectVelocity.values.byName(
            prefs.getString('_asteroidVelocity') ?? ObjectVelocity.medium.name))
        .obs;
    _numberOfShips = (prefs.getInt('_numberOfShips') ?? 3).obs;

    muscleSettings = MuscleSettings(prefs: prefs)
      ..sensor1.orientation = AnalogicSensorOrientation.horizontal
      ..sensor2.orientation = AnalogicSensorOrientation.none;
  }

  ObjectVelocity get asteroidVelocity => _asteroidVelocity.value;
  set asteroidVelocity(ObjectVelocity val) {
    _asteroidVelocity.value = val;
    prefs.setString('_asteroidVelocity', val.name);
  }

  int get numberOfShips => _numberOfShips.value;
  set numberOfShips(int val) {
    if (val > 0) {
      _numberOfShips.value = val;
      prefs.setInt('_numberOfShips', val);
    }
  }
}
