
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';
import 'dart:io' show Platform;
import '../model/sensorInput.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  static Controller get to => Get.find();

  var _musclesInput = MusclesInput(0, 0).obs;
  var _joystickInput = JoystickInput(0).obs;

  MusclesInput get musclesInput => _musclesInput.value;
  JoystickInput get joystickInput => _joystickInput.value;


  void setMusclesTo(MusclesInput mi) {
    _musclesInput.value = mi;
  }
  void setJoystickTo(JoystickInput ji) {
    _joystickInput.value = ji;
  }
}