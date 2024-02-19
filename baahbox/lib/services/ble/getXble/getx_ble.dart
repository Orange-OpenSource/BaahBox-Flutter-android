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
