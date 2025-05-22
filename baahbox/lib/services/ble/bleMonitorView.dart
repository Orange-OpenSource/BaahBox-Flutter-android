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


import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'BleController.dart';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

class BleMonitorView extends GetView<BleController> {
  const BleMonitorView({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("État du bluetooth :",
              style: Theme.of(context).textTheme.bodyLarge),
          Obx(() => Text(
              switch (controller.adaptaterState.value) {
                BleAdapterState.unavailable =>
                  "Votre téléphone n'est pas compatible avec le bluetooth Low Energy ",
                BleAdapterState.unauthorized =>
                  "L'application a besoin de permissions pour utiliser le bluetooth",
                BleAdapterState.enable => "Bluetooth actif",
                BleAdapterState.disabled =>
                  "Le bluetooth n'est pas activé sur votre téléphone",
                BleAdapterState.waiting => "Initialisation en cours"
              },
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold))),
          Obx(() {
            switch (controller.adaptaterState.value) {
              case BleAdapterState.unavailable:
                return SizedBox(
                  height: 15,
                );
              case BleAdapterState.unauthorized:
                return  FilledButton(
                    onPressed: () {
                      _askPermissions();
                    },
                    child: const Text("Permissions"));
              case BleAdapterState.enable:
                return SizedBox(
                  height: 15,
                );
              case BleAdapterState.disabled:
                return FilledButton(
                    onPressed: controller.enableBlueTooth,
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("Activer")));
              case BleAdapterState.waiting:
                return SizedBox(
                  height: 15,
                );
            }
          }),
          Text("Recherche de BaahBox :",
              style: Theme.of(context).textTheme.bodyLarge),
          Obx(() => FilledButton(
              onPressed: controller.adaptaterState.value ==
                  BleAdapterState.enable
                  ? () {
                      _startOrStopScan();
                    }
                  : null,
              child: controller.isScanningDevices.value
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Arrêter"),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).colorScheme.onPrimary),
                                strokeWidth: 3,
                                color: Theme.of(context).colorScheme.onPrimary),
                          )
                        ],
                      ),
                    )
                  : Text("Démarrer")))
        ]));
  }

  void _askPermissions() async {
    if (controller.adaptaterState.value ==
        BleAdapterState.unauthorized) {
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        Map<Permission, PermissionStatus> statuses =
            (androidInfo.version.sdkInt <= 30)
                ? await [Permission.location].request()
                : await [Permission.bluetoothScan, Permission.bluetoothConnect]
                    .request();

        bool hasPermanentlyDenied = statuses.entries.any((entry) {
          return entry.value.isPermanentlyDenied;
        });
        if (hasPermanentlyDenied == true) {
          openAppSettings();
        }
      }
    }
  }

  void _startOrStopScan() async {
    if (controller.isScanningDevices.value) {
      await controller.stopScanDevices();
    } else {
      bool canStart = false;
      if (controller.adaptaterState.value == BleAdapterState.enable) {
        canStart = true;
      } else if (Platform.isIOS) {
        canStart = true;
      }
      if (canStart) {
        controller.startScanDevices();
      }
    }
  }
}
