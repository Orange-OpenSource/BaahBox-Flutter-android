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

import 'dart:math';

import 'package:baahbox/services/settings/settingsController.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Maze3dSettings  {

  late final SharedPreferences prefs;
  static const prefsPrefix = "Maze3dSettings::";
  late RxInt _mazeSize;
  late RxBool _hasChrono;
  late RxDouble _chronoMaxTime;
  late RxDouble _FOV;

  late RxDouble _speedMovement;

  late MuscleSettings musclesSettings;

  Maze3dSettings({required this.prefs}) {
    _mazeSize = (prefs.getInt('${prefsPrefix}_mazeSize') ?? 5).obs;
    _hasChrono = (prefs.getBool('${prefsPrefix}_hasChrono') ?? false).obs;
    _chronoMaxTime = (prefs.getDouble('${prefsPrefix}_chronoMaxTime') ?? 40.0).obs;
    _speedMovement = (prefs.getDouble('${prefsPrefix}_speedMovement') ?? 5).obs;
    _FOV = (prefs.getDouble('${prefsPrefix}_FOV') ?? (pi /3)).obs;

    musclesSettings = MuscleSettings(prefs : prefs, prefsPrefix:prefsPrefix);

  }


  int get mazeSize => _mazeSize.value;
  set mazeSize(int val)
  {
    if(val > 0) {
      _mazeSize.value = val;
      prefs.setInt('${prefsPrefix}_mazeSize', val);
    }
  }

  bool get hasChrono => _hasChrono.value;
  set hasChrono(bool val)
  {
    _hasChrono.value = val;
    prefs.setBool('${prefsPrefix}_hasChrono', val);
  }

  double get chronoMaxTime => _chronoMaxTime.value;
  set chronoMaxTime(double val)
  {
    if(val > 0) {
      _chronoMaxTime.value = val;
      prefs.setDouble('${prefsPrefix}_chronoMaxTime', val);
    }
  }

  double get speedMovement => _speedMovement.value;
  set speedMovement(double val)
  {
    if(val > 0) {
      _speedMovement.value = val;
      prefs.setDouble('${prefsPrefix}_speedMovement', val);
    }
  }
  double get FOV => _FOV.value;
  set FOV(double val)
  {
    if(val > 0) {
      _FOV.value = val;
      prefs.setDouble('${prefsPrefix}_FOV', val);
    }
  }
}