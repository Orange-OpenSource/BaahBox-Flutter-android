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

import 'package:baahbox/games/spaceShip/spaceShipSettings.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';

import '../../games/maze/mazeSettings.dart';
import '../../games/sheep/sheepSettings.dart';
import '../../games/toad/toadSettings.dart';
import '../../model/AnalogicSensor.dart';


class GeneralSettings {
  var _numberOfSensors = 1.obs;
  var _sensitivity = Sensitivity.medium.obs;
  var _sensor = Sensor.digitalJoystick.obs;
  var _threshold = 0.2.obs;
  var _demoMode = false.obs;

  int get numberOfSensors => _numberOfSensors.value;
  set numberOfSensor(int val) {
    if (val >= 0) {
      _numberOfSensors.value = val;
    }
  }

  Sensitivity get sensitivity => _sensitivity.value;
  set sensitivity(Sensitivity val) {
    _sensitivity.value = val;
  }

  Sensor get sensor => _sensor.value;
  set sensor(Sensor val) {
    _sensor.value = val;
  }

  double get threshold => _threshold.value;
  set threshold(double val) {
    if (val >= 0) {
      _threshold.value = val;
    }
  }

  bool get demoMode => _demoMode.value;
  set demoMode(bool val) {
    _demoMode.value = val;
  }
}



class HandleSettings extends AnalogicSensorSettings {
  var _analogInputRangeForHandleLower = 10.obs;
  var _analogInputRangeForHandleUpper = 100.obs;


  int get rangeForHandleLower => _analogInputRangeForHandleLower.value;
  set rangeForHandleLower(int val) {
    if (val >= 0 && val <= _analogInputRangeForHandleUpper.value) {
      _analogInputRangeForHandleLower.value = val;
    }
  }

  int get rangeForHandleUpper => _analogInputRangeForHandleUpper.value;
  set rangeForHandleUpper(int val) {
    if (val > _analogInputRangeForHandleLower.value && val <= 180) {
      _analogInputRangeForHandleUpper.value = val;
    }
  }
}

class MuscleSettings extends AnalogicChannelsSettings {

  var _hasBothAction = false.obs;

  bool get hasBothAction => _hasBothAction.value;
  set hasBothAction(bool bothAction) {
    _hasBothAction.value = bothAction;
  }
}

class SettingsController extends GetxController {
  // TODO: use classes instead of maps
  var genericSettings = GeneralSettings();
  var musclesSettings = MuscleSettings();
  var handleSettings = HandleSettings();

  var sheepSettings = SheepSettings();
  var spaceShipSettings = SpaceShipSettings();
  var toadSettings = ToadSettings();
  var mazeSettings = MazeSettings();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
