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

import '../../model/AnalogicSensor.dart';

class ToadSettings  {
  var _iShootingModeAutomatic = false.obs;
  var _numberOfFlies = 5.obs;
  var _flySteadyTime = 3.0.obs;

  var muscleSettings = MuscleSettings()
    ..sensor1.orientation=AnalogicSensorOrientation.horizontal
    ..sensor2.orientation=AnalogicSensorOrientation.none;

  bool get iShootingModeAutomatic => _iShootingModeAutomatic.value;
  set iShootingModeAutomatic(bool val)
  {
    _iShootingModeAutomatic.value = val;
  }

  int get numberOfFlies => _numberOfFlies.value;
  set numberOfFlies(int val)
  {
    if(val>0) {
      _numberOfFlies.value = val;
    }
  }

  double get flySteadyTime => _flySteadyTime.value;
  set flySteadyTime(double val)
  {
    if(val>0) {
      _flySteadyTime.value = val;
    }
  }
}