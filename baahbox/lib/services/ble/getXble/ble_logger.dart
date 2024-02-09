import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

class BleLogger extends GetxController {
  BleLogger({
    required FlutterReactiveBle ble,
  }) : _ble = ble;

  final FlutterReactiveBle _ble;
  final Rx<List<String>> rxMessages = Rx<List<String>>([]);
  final RxBool rxVerboseLogging = false.obs;

  void addToLog(String message) {
    final now = DateTime.now();
    final formattedDate = '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';
    rxMessages.value.add('$formattedDate - $message');
  }

  void clearLogs() => rxMessages.value.clear();

  void verboseLoggingUpdate() {
    if (rxVerboseLogging.value) {
      _ble.logLevel = LogLevel.verbose;
    } else {
      _ble.logLevel = LogLevel.none;
    }
  }
}
