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
