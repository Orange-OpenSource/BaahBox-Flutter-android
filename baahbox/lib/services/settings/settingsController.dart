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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _status = Rx<RxStatus>(RxStatus.empty());
  var _currentSensorType = SensorType.none.obs;

var _genericSettings = <String, Object>{
  "sensitivity": Sensitivity.medium,
  "sensor": SensorType.muscle,
  "numberOfSensors": 1,
  "threshold": 0.2,
  "demoMode": false,
  "isSensor1On": true,
  "isSensor2On": false,
  }.obs;

var _spaceShipSettings = SpaceShipSettings().obs;

  var _sheepSettings = <String, Object>{
    "gateVelocity": ObjectVelocity.medium,
    "numberOfGates": 3,
  }.obs;

  var _toadSettings = <String, Object>{
    "flySteadyTime": 3,
    "numberOfFlies": 5,
    "shootingType": ShootingType.automatic,
  }.obs;


// getters
  SensorType get usedSensor => _currentSensorType.value;

  Map get sheepSettings => _sheepSettings;
  SpaceShipSettings get spaceShipSettings => _spaceShipSettings.value;
  Map get toadShipSettings => _toadSettings;
  Map get genericSettings => _genericSettings;

  RxStatus get status => _status.value;

  @override
  void onInit() async {
     everAll([
       _genericSettings,
       _spaceShipSettings,
       _toadSettings,
       _sheepSettings], (value) =>  {
       print("settings update:   $value !")
     });
    super.onInit();

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
  }

  void setSensorTo(SensorType sensor) {
    _currentSensorType.value = sensor;
  }

  void setMuscle1To(bool mu1) {
    _genericSettings["isSensor1On"] = mu1;
  }

  void setMuscle2To(bool mu2) {
    _genericSettings["isSensor2On"] = mu2;
  }

  void setNumberOfGatesTo(int? value) {
    if (value != null) {
    _sheepSettings["numberOfGates"] = value > 0 ? value : 1;
    } else {
      showMyToast("Null value !");
    }
  }

  void setNumberOfShipsTo(int? value) {
    if (value != null) {
      _spaceShipSettings.value.numberOfShips = value > 0 ? value : 1;
    } else {
      showMyToast("Null value !");
    }
    print("ships to set : $value");
    var ships = spaceShipSettings.numberOfShips;
    print("shipSettings: $ships");
  }
  void updateSensorTypeTo(SensorType? type) {
    if (type != null) {
      setSensorTo(type);
      _genericSettings["sensor"] = type;
    }
  }

  void updateSensitivityTo(Sensitivity? sensitivity) {
    if (sensitivity != null) {
      _genericSettings["sensitivity"] = sensitivity;
    }
  }

  void setGateSpeedTo(ObjectVelocity? velocity) {
    if (velocity != null) {
        _sheepSettings["gateVelocity"] = velocity;
    } else {
      print("Null value !");
    }
  }
  void setAsteroidSpeedTo(ObjectVelocity? velocity) {
    if (velocity != null) {
      _spaceShipSettings.value.asteroidVelocity = velocity;
      var speed = spaceShipSettings.asteroidVelocity;
      print("asteroids: $speed");
    } else {
      print("Null value !");
    }
  }

  void showMyToast(String message) {
    Get.snackbar(
      "Baaaaah !",
      message,
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
      borderRadius: 10,
      backgroundColor:  BBGameList.sheep.baseColor.color,
      icon: Image.asset(
        "assets/images/icon/logo_baah_40.png",
        height: 40,
        width: 40,
        //color: Colors.white,
      ),
    );
  }
}

class SpaceShipSettings {
  ObjectVelocity asteroidVelocity =  ObjectVelocity.low;
  int numberOfShips = 5;
}