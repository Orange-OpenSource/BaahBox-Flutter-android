import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _status = Rx<RxStatus>(RxStatus.empty());

  RxStatus get status => _status.value;

  @override
  void onInit() {}

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
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
        showMyToast("Login successful");

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
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
