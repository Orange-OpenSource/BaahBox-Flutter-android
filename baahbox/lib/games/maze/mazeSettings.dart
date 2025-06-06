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

class MazeSettings  {

  var _mazeSize = 5.obs;
  var _hasChrono = false.obs;
  var _chronoMaxTime = 40.0.obs;
  var _hasMaxTouch = false.obs;
  var _maxTouches = 5.obs;
  var _isFineDirection = false.obs;
  var _speedMovement = 40.0.obs;

  var musclesSettings = MuscleSettings();


  int get mazeSize => _mazeSize.value;
  set mazeSize(int val)
  {
    if(val > 0) {
      _mazeSize.value = val;
    }
  }

  bool get hasChrono => _hasChrono.value;
  set hasChrono(bool val)
  {
    _hasChrono.value = val;
  }

  double get chronoMaxTime => _chronoMaxTime.value;
  set chronoMaxTime(double val)
  {
    if(val > 0) {
      _chronoMaxTime.value = val;
    }
  }

  bool get hasMaxTouch => _hasMaxTouch.value;
  set hasMaxTouch(bool val)
  {
    _hasMaxTouch.value = val;
  }

  int get maxTouches => _maxTouches.value;
  set maxTouches(int val)
  {
    if(val > 0) {
      _maxTouches.value = val;
    }
  }

  bool get isFineDirection => _isFineDirection.value;
  set isFineDirection(bool val)
  {
    _isFineDirection.value = val;
  }

  double get speedMovement => _speedMovement.value;
  set speedMovement(double val)
  {
    if(val > 0) {
      _speedMovement.value = val;
    }
  }
}