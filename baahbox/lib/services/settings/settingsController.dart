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

  var _currentSensor = Sensor.digitalJoystick.obs;

  // TODO: use classes instead of maps
  var _genericSettings = <String, Object>{
    "sensitivity": Sensitivity.medium,
    "sensor": Sensor.digitalJoystick,
    "numberOfSensors": 1,
    "threshold": 0.2,
    "demoMode": false,
    "isSensor1On": true,
    "isSensor2On": false,
    "analogInputRangeForHandleLower": 10,
    "analogInputRangeForHandleUpper":100
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

  var _mazeSettings = <String, Object>{
    "hasChrono": false,
    "chronoMaxTime": 20.0,
    "hasMaxTouch": false,
    "maxTouches": 5,
    "isFineDirection": false,
    "speedMovement":40.0,
    "mazeSize": 5,
  }.obs;

// getters
  Sensor get currentSensor => _currentSensor.value;

  Map get sheepSettings => _sheepSettings;
  Map get genericSettings => _genericSettings;
  Map get spaceShipSettings => _spaceShipSettings;
  Map get toadSettings => _toadSettings;
  Map get mazeSettings => _mazeSettings;

  @override
  void onInit() async {
    everAll(
        [_genericSettings, _spaceShipSettings, _toadSettings, _sheepSettings, _mazeSettings],
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

  void setHandleRangeLower(int val) {
    if(val>0 && val <=180)
      {
        _genericSettings["analogInputRangeForHandleLower"] = val;
      }

  }

  void setHandleRangeUpper(int val) {
    if(val>0 && val <=180)
    {
      _genericSettings["analogInputRangeForHandleUpper"] = val;
    }
  }
  int getHandleRangeLower() {
    return (_genericSettings["analogInputRangeForHandleLower"] ?? 0) as int;
  }

  int getHandleRangeUpper() {
    return (_genericSettings["analogInputRangeForHandleUpper"] ?? 0) as int;
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
  // Maze Settings
  // ===================
  void setMazeHasChrono(bool hasChrono) {
    _mazeSettings["hasChrono"] = hasChrono;
    var hasChronoSetting = _mazeSettings["hasChrono"];
    print("has chrono: $hasChronoSetting");
  }

  void setMazeFineDirection(bool isFine) {
    _mazeSettings["isFineDirection"] = isFine;
    var isFineSetting = _mazeSettings["isFineDirection"];
    print("is fine direction: $isFineSetting");
  }
  void setMazeHasMaxWallTouches(bool hasMaxTouch) {
    _mazeSettings["hasMaxTouch"] = hasMaxTouch;
    var hasMaxtouchesSetting = _mazeSettings["hasMaxTouch"];
    print("has max touches: $hasMaxtouchesSetting");
  }

  void setMazeChronoMaxTime(double? value) {
    if (value != null) {
      _mazeSettings["chronoMaxTime"] = value > 0 ? value : 20.0;
      var maxTime = _mazeSettings["chronoMaxTime"];
      print("number of flies : $maxTime");
    } else {
      _mazeSettings["chronoMaxTime"] = 20.0;
      showMyToast("Null value for chrono max time !");
    }
  }
  void setMazeWallMaxTouch(int? value) {
    if (value != null) {
      _mazeSettings["maxTouches"] = value > 0 ? value : 3;
      var maxTime = _mazeSettings["maxTouches"];
      print("max wall touches : $maxTime");
    } else {
      _mazeSettings["maxTouches"] = 3;
      showMyToast("Null value for max wall touches !");
    }
  }

  void setMazeSize(int? value) {
    if (value != null) {
      _mazeSettings["mazeSize"] = value > 0 ? value : 5;
      var maxTime = _mazeSettings["mazeSize"];
      print("maze size : $maxTime");
    } else {
      _mazeSettings["mazeSize"] = 5;
      showMyToast("Null value for maze size !");
    }
  }
  void setMazeSpeedMovement(double? value) {
    if (value != null) {
      _mazeSettings["speedMovement"] = value > 0 ? value : 40.0;
      var maxTime = _mazeSettings["speedMovement"];
      print("movement speed : $maxTime");
    } else {
      _mazeSettings["speedMovement"] = 40.0;
      showMyToast("Null value for movement speed !");
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
