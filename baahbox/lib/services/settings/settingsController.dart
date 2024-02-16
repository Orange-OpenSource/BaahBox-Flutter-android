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

  var _usedSensor = SensorType.none.obs;

  // var sheepParameters = (
  // gateVelocity: ObjectVelocity.high,
  // numberOfGates: 5,
  // );

 // get sheepP => sheepParameters;
 // get sheepVel => sheepParameters.gateVelocity.value;
//  final myMap = <String, int>{}.obs;

var _genericSettings = <String, Object>{
  "sensitivity": Sensitivity.medium,
  "sensor": SensorType.muscle,
  "numberOfSensors": 1,
  "threshold": 0.2,
  "demoMode": false,
  "isSensor1On": true,
  "isSensor2On": false,
  }.obs;

var _spaceShipSettings = <String, Object>{
  "asteroidVelocity": ObjectVelocity.low,
  "NumberOfLives": 5,
}.obs;

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
  SensorType get usedSensor => _usedSensor.value;

  Map get sheepSettings => _sheepSettings;
  Map get starShipSettings => _spaceShipSettings;
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
       print("update for $value !")
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
    _usedSensor.value = sensor;
  }

  void setMuscle1To(bool mu1) {
    _genericSettings["isSensor1On"] = mu1;
  }

  void setMuscle2To(bool mu2) {
    _genericSettings["isSensor2On"] = mu2;
  }

  void setNumberOfGatesTo(int? value) {
    if (value != null) {
    _sheepSettings["numberOfGates"] = value;
    } else {
      showMyToast("Null value !");
    }
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

  bool _isValid() {
    if (emailController.text.trim().isEmpty) {
      showMyToast("Enter email id Error");
     // M.showToast('Enter email id', status: SnackBarStatus.error);
      return false;
    }
    if (!emailController.text.trim().isEmail) {
      showMyToast("Enter valid email id");
     // M.showToast('Enter valid email id', status: SnackBarStatus.error);
      return false;
    }
    if (passwordController.text.trim().isEmpty) {
      showMyToast("Enter password");
     // M.showToast('Enter password', status: SnackBarStatus.error);
      return false;
    }
    return true;
  }

  Future<void> onLogin() async {
    if (_isValid()) {
      _status.value = RxStatus.loading();
      try {
        //Perform login logic here
        showMyToast("On login :: Login successful");

       // M.showToast('Login successful', status: SnackBarStatus.success);
        _status.value = RxStatus.success();
      } catch (e) {
        e.printError();
        showMyToast(e.toString());

       // M.showToast(e.toString(), status: SnackBarStatus.error);
        _status.value = RxStatus.error(e.toString());
      }
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
