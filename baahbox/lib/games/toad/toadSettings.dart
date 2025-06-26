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

import '../../model/AnalogicSensor.dart';

class ToadSettings  {
  late final SharedPreferences prefs;
  static const prefsPrefix = "ToadSettings::";

  late RxBool _iShootingModeAutomatic;
  late RxInt _numberOfFlies;
  late RxDouble _flySteadyTime;

  late MuscleSettings muscleSettings;

  ToadSettings({required this.prefs}) {
    _iShootingModeAutomatic = (prefs.getBool('${prefsPrefix}_iShootingModeAutomatic') ?? false).obs;
    _numberOfFlies = (prefs.getInt('${prefsPrefix}_numberOfFlies') ?? 5).obs;
    _flySteadyTime = (prefs.getDouble('${prefsPrefix}_flySteadyTime') ?? 3.0).obs;
    muscleSettings = MuscleSettings(prefs: prefs, prefsPrefix:prefsPrefix)
      ..sensor1.orientation=AnalogicSensorOrientation.horizontal
      ..sensor2.orientation=AnalogicSensorOrientation.none;
  }
  bool get iShootingModeAutomatic => _iShootingModeAutomatic.value;
  set iShootingModeAutomatic(bool val)
  {
    _iShootingModeAutomatic.value = val;
    prefs.setBool('${prefsPrefix}_iShootingModeAutomatic', val);
  }

  int get numberOfFlies => _numberOfFlies.value;
  set numberOfFlies(int val)
  {
    if(val>0) {
      _numberOfFlies.value = val;
      prefs.setInt('${prefsPrefix}_numberOfFlies', val);
    }
  }

  double get flySteadyTime => _flySteadyTime.value;
  set flySteadyTime(double val)
  {
    if(val>0) {
      _flySteadyTime.value = val;
      prefs.setDouble('${prefsPrefix}_flySteadyTime', val);
    }
  }
}