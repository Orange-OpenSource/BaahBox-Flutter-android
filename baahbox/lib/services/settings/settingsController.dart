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
import 'package:shared_preferences/shared_preferences.dart';

import '../../games/maze/mazeSettings.dart';
import '../../games/maze3d/maze3dSettings.dart';
import '../../games/sheep/sheepSettings.dart';
import '../../games/toad/toadSettings.dart';
import '../../model/AnalogicSensor.dart';

class GeneralSettings {
  late final SharedPreferences prefs;

  late RxInt _numberOfSensors;
  late Rx<Sensitivity> _sensitivity;
  late Rx<Sensor> _sensor;
  late RxDouble _threshold;
  late RxBool _demoMode;

  GeneralSettings({required this.prefs}) {
    _numberOfSensors = (prefs.getInt('_numberOfSensors') ?? 1).obs;
    _sensitivity = (Sensitivity.values
            .byName(prefs.getString('_sensitivity') ?? Sensitivity.medium.name))
        .obs;
    _sensor = (Sensor.values
            .byName(prefs.getString('_sensor') ?? Sensor.analogJoystick.name))
        .obs;
    _threshold = (prefs.getDouble('_threshold') ?? 0.2).obs;
    _demoMode = (prefs.getBool('_demoMode') ?? false).obs;
  }

  int get numberOfSensors => _numberOfSensors.value;
  set numberOfSensor(int val) {
    if (val >= 0) {
      _numberOfSensors.value = val;
      prefs.setInt('_numberOfSensors', val);
    }
  }

  Sensitivity get sensitivity => _sensitivity.value;
  set sensitivity(Sensitivity val) {
    _sensitivity.value = val;
    prefs.setString('_sensitivity', val.name);
  }

  Sensor get sensor => _sensor.value;
  set sensor(Sensor val) {
    _sensor.value = val;
    prefs.setString('_sensor', val.name);
  }

  double get threshold => _threshold.value;
  set threshold(double val) {
    if (val >= 0) {
      _threshold.value = val;
      prefs.setDouble('_threshold', val);
    }
  }

  bool get demoMode => _demoMode.value;
  set demoMode(bool val) {
    _demoMode.value = val;
    prefs.setBool('_demoMode', val);
  }
}

class HandleSettings extends AnalogicSensorSettings {

  late RxInt _analogInputRangeForHandleLower ;
  late RxInt _analogInputRangeForHandleUpper;

  HandleSettings({required super.prefs, required super.prefsPrefix}) {
    _analogInputRangeForHandleLower = (prefs.getInt('${prefsPrefix}_analogInputRangeForHandleLower') ?? 10).obs;
    _analogInputRangeForHandleUpper = (prefs.getInt('${prefsPrefix}_analogInputRangeForHandleUpper') ?? 100).obs;
  }

  int get rangeForHandleLower => _analogInputRangeForHandleLower.value;
  set rangeForHandleLower(int val) {
    if (val >= 0 && val <= _analogInputRangeForHandleUpper.value) {
      _analogInputRangeForHandleLower.value = val;
      prefs.setInt('${prefsPrefix}_analogInputRangeForHandleLower', val);
    }
  }

  int get rangeForHandleUpper => _analogInputRangeForHandleUpper.value;
  set rangeForHandleUpper(int val) {
    if (val > _analogInputRangeForHandleLower.value && val <= 180) {
      _analogInputRangeForHandleUpper.value = val;
      prefs.setInt('${prefsPrefix}_analogInputRangeForHandleUpper', val);
    }
  }
}

class MuscleSettings extends AnalogicChannelsSettings {


  late RxBool _hasBothAction;

  MuscleSettings({required super.prefs, required super.prefsPrefix}) {
    _hasBothAction = (prefs.getBool('${prefsPrefix}_hasBothAction') ?? false).obs;
  }

  bool get hasBothAction => _hasBothAction.value;
  set hasBothAction(bool bothAction) {
    _hasBothAction.value = bothAction;
  }
}

class SettingsController extends GetxController {
  // TODO: use classes instead of maps
  late GeneralSettings genericSettings;
  late MuscleSettings musclesSettings;
  late HandleSettings handleSettings;
  late AnalogicChannelsSettings analogJoystickSettings;

  late SheepSettings sheepSettings;
  late SpaceShipSettings spaceShipSettings;
  late ToadSettings toadSettings;
  late MazeSettings mazeSettings;
  late Maze3dSettings maze3dSettings;

  late final SharedPreferences prefs;
  static const prefsPrefix = "GenericSettings::";

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    genericSettings = GeneralSettings(prefs: prefs);
    musclesSettings = MuscleSettings(prefs: prefs, prefsPrefix:prefsPrefix);
    handleSettings = HandleSettings(prefs: prefs, prefsPrefix:prefsPrefix);
    analogJoystickSettings = AnalogicChannelsSettings(prefs: prefs, prefsPrefix:prefsPrefix);
    sheepSettings = SheepSettings(prefs: prefs);
    spaceShipSettings = SpaceShipSettings(prefs: prefs);
    toadSettings = ToadSettings(prefs: prefs);
    mazeSettings = MazeSettings(prefs: prefs);
    maze3dSettings = Maze3dSettings(prefs: prefs);

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
