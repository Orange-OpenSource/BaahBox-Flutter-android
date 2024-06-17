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
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/controllers/appController.dart';

class SettingsController extends GetxController {
  final Controller appController = Get.find();

  var _currentSensor = Sensor.arcadeJoystick.obs;

  // TODO: use classes instead of maps
  var _genericSettings = <String, Object>{
    "sensitivity": Sensitivity.medium,
    "sensor": Sensor.arcadeJoystick,
    "numberOfSensors": 1,
    "threshold": 0.2,
    "demoMode": false,
    "isSensor1On": true,
    "isSensor2On": false,
  }.obs;

  var _sheepSettings = <String, Object>{
    "gateVelocity": ObjectVelocity.medium,
    "numberOfGates": 3,
  }.obs;

  var _spaceShipSettings = <String, Object>{
    "asteroidVelocity": ObjectVelocity.low,
    "numberOfShips": 3,
  }.obs;

  var _toadSettings = <String, Object>{
    "iShootingModeAutomatic": true,
    "numberOfFlies": 5,
    "flySteadyTime": 3.0,
  }.obs;

// getters
  Sensor get currentSensor => _currentSensor.value;

  Map get sheepSettings => _sheepSettings;
  Map get genericSettings => _genericSettings;
  Map get spaceShipSettings => _spaceShipSettings;
  Map get toadSettings => _toadSettings;

  @override
  void onInit() async {
    everAll(
        [_genericSettings, _spaceShipSettings, _toadSettings, _sheepSettings],
        (value) => {print("settings update:   $value !")});
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
  }

  // ===================
  // Generic settings
  // ===================

  void setSensorTo(Sensor sensor) {
    _currentSensor.value = sensor;
    appController.setSensorTo(sensor);
  }

  void setMuscle1To(bool mu1) {
    _genericSettings["isSensor1On"] = mu1;
  }

  void setMuscle2To(bool mu2) {
    _genericSettings["isSensor2On"] = mu2;
  }

  void updateSensorTo(Sensor? sensor) {
    if (sensor != null) {
      setSensorTo(sensor);
      _genericSettings["sensor"] = sensor;
    }
  }

  void updateSensitivityTo(Sensitivity? sensitivity) {
    if (sensitivity != null) {
      _genericSettings["sensitivity"] = sensitivity;
    }
  }

// ===================
// Sheep settings
// ===================

  void setNumberOfGatesTo(int? value) {
    if (value != null) {
      _sheepSettings["numberOfGates"] = value > 0 ? value : 1;
    } else {
      showMyToast("Null value !");
    }
  }

  void setGateSpeedTo(ObjectVelocity? velocity) {
    if (velocity != null) {
      _sheepSettings["gateVelocity"] = velocity;
    } else {
      print("Null value !");
    }
  }

  // ===================
  // SpaceShip settings
  // ===================

  void setNumberOfShipsTo(int? value) {
    if (value != null) {
      _spaceShipSettings["numberOfShips"] = value > 0 ? value : 1;
    } else {
      showMyToast("Null value !");
    }
    print("ships to set : $value");
    var ships = _spaceShipSettings["numberOfShips"];
    print("shipSettings: $ships");
  }

  void setAsteroidSpeedTo(ObjectVelocity? velocity) {
    if (velocity != null) {
      _spaceShipSettings["asteroidVelocity"] = velocity;
      var speed = spaceShipSettings["asteroidVelocity"];
      print("asteroids: $speed");
    } else {
      print("Null value !");
    }
  }

  // ===================
  // Toad Settings
  // ===================
  void setToadShootingModeToAutomatic(bool isShootingAuto) {
    _toadSettings["iShootingModeAutomatic"] = isShootingAuto;
    var shootType = toadSettings["iShootingModeAutomatic"];
    print("shooting Type: $shootType");
  }

  void setNumberOfFliesTo(int? value) {
    if (value != null) {
      _toadSettings["numberOfFlies"] = value > 0 ? value : 3;
      var nFlies = toadSettings["numberOfFlies"];
      print("number of flies : $nFlies");
    } else {
      _toadSettings["numberOfFlies"] = 3;
      showMyToast("Null value for number of flies !");
    }
  }

  void setFlyDurationTo(double? value) {
    if (value != null) {
      _toadSettings["flySteadyTime"] = value > 0.0 ? value : 5.0;
      var flyDuration = toadSettings["flySteadyTime"];
      print("Fly duration (in sec) : $flyDuration");
    } else {
      showMyToast("Null value for flies steady time !");
    }
  }

  // ===================
  // ===================
  void showMyToast(String message) {
    Get.snackbar(
      "Baaaaah !",
      message,
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
      borderRadius: 10,
      backgroundColor: BBGameList.sheep.baseColor.color,
      icon: Image.asset(
        "assets/images/icon/logo_baah_40.png",
        height: 40,
        width: 40,
        //color: Colors.white,
      ),
    );
  }
}
