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

class SheepSettings  {
    late final SharedPreferences prefs;

    late Rx<ObjectVelocity> _gateVelocity;
    late RxInt _numberOfGates;
    late MuscleSettings muscleSettings;

    SheepSettings({required this.prefs}) {
        _gateVelocity = (ObjectVelocity.values
            .byName(prefs.getString('_gateVelocity') ?? ObjectVelocity.medium.name))
            .obs;
        _numberOfGates = (prefs.getInt('_numberOfGates') ?? 3).obs;

        muscleSettings = MuscleSettings(prefs: prefs);
    }

    ObjectVelocity get gateVelocity => _gateVelocity.value;
    set gateVelocity(ObjectVelocity val)
    {
      _gateVelocity.value = val;
      prefs.setString('_gateVelocity', val.name);
    }

    int get numberOfGates => _numberOfGates.value;
    set numberOfGates(int val)
    {
        if(val>0) {
            _numberOfGates.value = val;
            prefs.setInt('_numberOfGates', val);
        }
    }
}