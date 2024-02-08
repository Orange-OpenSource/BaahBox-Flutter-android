import 'dart:ffi';
import 'dart:ui';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/model/sensorInput.dart';
import 'package:get/get.dart';

class Controller extends FullLifeCycleController with FullLifeCycleMixin {
  static Controller get to => Get.find();

  var _musclesInput = MusclesInput(0, 0).obs;
  var _joystickInput = JoystickInput(0).obs;
  var _isConnectedToBox = false.obs;

  var _isActive = false.obs;

  var sheepParameters = (
  gateVelocity: Velocity.quick,
  numberOfGates: 5,
  );

   get sheepP => sheepParameters;
   get sheepVel => sheepParameters.gateVelocity.value;

  var parameters = {
    "generic": {
      "sensitivity": Sensitivity.average,
      "sensor": SensorType.muscle,
      "numberOfSensors": 1,
      "threshold": 0.2,
      "demoMode": false,
      "isSensor1On": true,
      "isSensor2On": false,
    },
    "starShip": {
      "asteroidVelocity": Velocity.slow,
      "NumberOfLives": 5,
  },
    "sheep": {
      "gateVelocity": Velocity.average,
      "numberOfGates": 3,
      },
    "toad": {
      "flySteadyTime": 3,
      "numberOfFlies": 5,
      "shootingType": ShootingType.automatic,
  },
  };


  // getters
  MusclesInput get musclesInput => _musclesInput.value;
  JoystickInput get joystickInput => _joystickInput.value;

  Map get params => parameters;
  Map get sheepParams => params["sheep"];
  Map get starShipParams => params["starShip"];
  Map get toadShipParams => params["toad"];
  Map get genericParams => params["generic"];

  // functions
  bool get isConnectedToBox => _isConnectedToBox.value;
  bool get isActive => _isActive.value;

  void setConnectionStateTo(bool isConnected) {
    _isConnectedToBox.value = isConnected;
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

  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _isActive.value = true;
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
    print('appController - onInative called');
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
    print('appController - onhidden called');
    _isActive.value = false;
  }

// Mandatory
  @override
  void onResumed() {
    print('appController - onResumed called');
    _isActive.value = true;
  }
}
