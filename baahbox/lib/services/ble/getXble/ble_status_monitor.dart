import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

class BleStatusMonitor extends GetxController {
  BleStatusMonitor(this._ble) {
    rxBleStatus.bindStream(_ble.statusStream);
  }

  final FlutterReactiveBle _ble;

  final Rx<BleStatus> rxBleStatus = BleStatus.unknown.obs;
}
