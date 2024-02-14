import 'package:baahbox/model/sensorInput.dart';
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
