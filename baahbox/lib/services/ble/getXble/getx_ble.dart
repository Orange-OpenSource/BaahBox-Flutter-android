library getx_ble;

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'ble_device_connector.dart';
import 'ble_device_interactor.dart';
import 'ble_logger.dart';
import 'ble_scanner.dart';
import 'package:get/get.dart';
import 'ble_status_monitor.dart';

export 'ble_device_connector.dart';
export 'ble_device_interactor.dart';
export 'ble_logger.dart';
export 'ble_scanner.dart';
export 'ble_status_monitor.dart';

class GetxBle extends GetxController {
  final ble = FlutterReactiveBle();
  late final BleLogger bleLogger;
  late final BleStatusMonitor bleStatusMonitor;
  late final BleScanner scanner;
  late final BleDeviceConnector connector;
  late final BleDeviceInteractor interactor;

  GetxBle() {
    bleLogger = BleLogger(ble: ble);
    bleStatusMonitor = BleStatusMonitor(ble);
    scanner = BleScanner(ble: ble, logMessage: bleLogger.addToLog);
    connector = BleDeviceConnector(ble: ble, logMessage: bleLogger.addToLog);
    interactor = BleDeviceInteractor(ble: ble, logMessage: bleLogger.addToLog);
  }
}
