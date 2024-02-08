import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/model/sensorInput.dart';
import 'package:get/get.dart';

class Controller extends FullLifeCycleController with FullLifeCycleMixin {
  static Controller get to => Get.find();

  var _musclesInput = MusclesInput(0, 0).obs;
  var _joystickInput = JoystickInput(0).obs;
  var _isConnectedToBox = false.obs;

  var _isActive = false.obs;




  // getters
  MusclesInput get musclesInput => _musclesInput.value;
  JoystickInput get joystickInput => _joystickInput.value;

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
