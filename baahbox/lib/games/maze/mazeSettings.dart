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

class MazeSettings  {

  late final SharedPreferences prefs;

  late RxInt _mazeSize;
  late RxBool _hasChrono;
  late RxDouble _chronoMaxTime;
  late RxBool _hasMaxTouch;
  late RxInt _maxTouches;
  late RxBool _isFineDirection;
  late RxDouble _speedMovement;

  late MuscleSettings musclesSettings;

  MazeSettings({required this.prefs}) {
    _mazeSize = (prefs.getInt('_mazeSize') ?? 5).obs;
    _hasChrono = (prefs.getBool('_hasChrono') ?? false).obs;
    _chronoMaxTime = (prefs.getDouble('_chronoMaxTime') ?? 40.0).obs;
    _hasMaxTouch = (prefs.getBool('_hasMaxTouch') ?? false).obs;
    _maxTouches = (prefs.getInt('_maxTouches') ?? 5).obs;
    _isFineDirection = (prefs.getBool('_isFineDirection') ?? false).obs;
    _speedMovement = (prefs.getDouble('_speedMovement') ?? 40.0).obs;

    musclesSettings = MuscleSettings(prefs : prefs);

  }


  int get mazeSize => _mazeSize.value;
  set mazeSize(int val)
  {
    if(val > 0) {
      _mazeSize.value = val;
      prefs.setInt('_mazeSize', val);
    }
  }

  bool get hasChrono => _hasChrono.value;
  set hasChrono(bool val)
  {
    _hasChrono.value = val;
    prefs.setBool('_hasChrono', val);
  }

  double get chronoMaxTime => _chronoMaxTime.value;
  set chronoMaxTime(double val)
  {
    if(val > 0) {
      _chronoMaxTime.value = val;
      prefs.setDouble('_chronoMaxTime', val);
    }
  }

  bool get hasMaxTouch => _hasMaxTouch.value;
  set hasMaxTouch(bool val)
  {
    _hasMaxTouch.value = val;
    prefs.setBool('_hasMaxTouch', val);
  }

  int get maxTouches => _maxTouches.value;
  set maxTouches(int val)
  {
    if(val > 0) {
      _maxTouches.value = val;
      prefs.setInt('_maxTouches', val);
    }
  }

  bool get isFineDirection => _isFineDirection.value;
  set isFineDirection(bool val)
  {
    _isFineDirection.value = val;
    prefs.setBool('_isFineDirection', val);
  }

  double get speedMovement => _speedMovement.value;
  set speedMovement(double val)
  {
    if(val > 0) {
      _speedMovement.value = val;
      prefs.setDouble('_speedMovement', val);
    }
  }
}