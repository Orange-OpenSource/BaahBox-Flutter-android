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

import '../../constants/enums.dart';

class SheepSettings  {
    var _gateVelocity = ObjectVelocity.medium.obs;
    var _numberOfGates = 3.obs;
    var muscleSettings = MuscleSettings();

    ObjectVelocity get gateVelocity => _gateVelocity.value;
    set gateVelocity(ObjectVelocity val)
    {
      _gateVelocity.value = val;
    }

    int get numberOfGates => _numberOfGates.value;
    set numberOfGates(int val)
    {
        if(val>0) {
            _numberOfGates.value = val;
        }
    }
}