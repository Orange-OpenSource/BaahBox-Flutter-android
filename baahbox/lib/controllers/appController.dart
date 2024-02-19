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

import 'package:baahbox/model/sensorInput.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:get/get.dart';

class Controller extends FullLifeCycleController with FullLifeCycleMixin {
  static Controller get to => Get.find();

  var _musclesInput = MusclesInput(0, 0).obs;
  var _joystickInput = JoystickInput(0).obs;
  var _isConnectedToBox = false.obs;
  var _connectedDeviceName = "".obs;
  var _connectedDeviceId = "".obs;

  var _isActive = false.obs;
  var _isDebugging = true.obs;


  // getters
  String get connectedDeviceName=> _connectedDeviceName.value;
  String get connectedDeviceId => _connectedDeviceId.value;
  MusclesInput get musclesInput => _musclesInput.value;
  JoystickInput get joystickInput => _joystickInput.value;
  bool get isConnectedToBox => _isConnectedToBox.value;
  bool get isActive => _isActive.value;
  bool get isDebugging => _isDebugging.value;

  // functions
  void setDebugModeTo(bool isDebug) {
    _isDebugging.value = isDebug;
  }


  void setConnectionStateTo(bool isConnected) {
    _isConnectedToBox.value = isConnected;
  }
  void setConnectedDeviceNameTo(String  deviceName) {
    _connectedDeviceName.value = deviceName;
  }
  void setConnectedDeviceIdTo(String  deviceId) {
    _connectedDeviceId.value = deviceId;
  }
  void setActivationStateTo(bool activate) {
    _isActive.value = activate;
  }

  void setMusclesTo(MusclesInput mi) {
    _musclesInput.value = mi;
  }

  void setJoystickTo(JoystickInput ji) {
    _joystickInput.value = ji;
  }

@override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _isActive.value = true;
    _isDebugging.value = true;
  }

// Mandatory
  @override
  void onDetached() {
    print('appController - onDetached called');
    _isActive.value = false;
  }

// Mandatory
  @override
  void onInactive() {
    print('appController - onInactive called');
    _isActive.value = false;
  }

// Mandatory
  @override
  void onPaused() {
    print('appController - onPaused called');
    _isActive.value = false;
  }
  // Mandatory

  @override
  void onHidden() {
    print('appController - onHidden called');
    _isActive.value = false;
  }

// Mandatory
  @override
  void onResumed() {
    print('appController - onResumed called');
    _isActive.value = true;
  }
}
