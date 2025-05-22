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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baahbox/model/sensorInput.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:get/get.dart';

import '../services/ble/BleController.dart';

class Controller extends FullLifeCycleController with FullLifeCycleMixin {
  static Controller get to => Get.find();

  final BleController bleController = Get.find();
  var _isActive = false.obs;
  var _isDebugging = true.obs;
  var _currentSensor = Sensor.digitalJoystick.obs;

  // getters
  String get connectedDeviceName=> bleController.connectedDevice.value?.name ?? "";
  String get connectedDeviceId => bleController.connectedDevice.value?.deviceID ?? "";
  AnalogInputs get analogInputs => bleController.analogInputs;
  DigitalInputs get digitalInputs => bleController.digitalInputs;
  bool get isConnectedToBox => bleController.connectedDevice.value!=null;
  bool get isActive => _isActive.value;
  bool get isDebugging => _isDebugging.value;
  Sensor get currentSensor => isConnectedToBox ? _currentSensor.value: Sensor.none;

  // functions
  void setDebugModeTo(bool isDebug) {
    _isDebugging.value = isDebug;
  }

  void setSensorTo(Sensor sensor) {
      _currentSensor.value = sensor;
  }
  void setActivationStateTo(bool activate) {
    _isActive.value = activate;
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


  void showMyToast(String message) {
    Get.snackbar(
      "Sélectionnez votre Baah Box pour commencer !",
      message,
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
      borderRadius: 10,
      backgroundColor: BBGameList.sheep.baseColor.color,
      icon: Image.asset(
        "assets/images/Dashboard/bluetooth.png",
        height: 40,
        width: 40,
        //color: Colors.white,
      ),
    );
  }
}
