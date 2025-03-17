import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'getXble/getx_ble.dart';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

class BleMonitorView extends GetView<GetxBle> {
  final Uuid serviceUuid = Uuid.parse('6E400001-B5A3-F393-E0A9-E50E24DCCA9E');

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("État du bluetooth :",
              style: Theme.of(context).textTheme.bodyLarge),
          Obx(() => Text(
              switch (controller.bleStatusMonitor.rxBleStatus.value) {
                BleStatus.unsupported =>
                  "Votre téléphone n'est pas compatible avec le bluetooth Low Energy ",
                BleStatus.poweredOff =>
                  "Le bluetooth n'est pas activé sur votre téléphone",
                BleStatus.locationServicesDisabled =>
                  "La localisation doit être activée pour utiliser le bluetooth",
                BleStatus.unauthorized =>
                  "L'application a besoin de permissions pour utiliser le bluetooth",
                BleStatus.ready => "Bluetooth actif",
                _ => "Bluetooth dans un état inconnu"
              },
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold))),
          Obx(() => controller.bleStatusMonitor.rxBleStatus.value ==
                  BleStatus.unauthorized
              ? FilledButton(
                  onPressed: () {
                    _askPermissions();
                  },
                  child: const Text("Permissions"))
              : SizedBox(height: 0)),
          SizedBox(
            height: 15,
          ),
          Text("Recherche de BaahBox :",
              style: Theme.of(context).textTheme.bodyLarge),
          Obx(() => FilledButton(
              onPressed: controller.bleStatusMonitor.rxBleStatus.value ==
                      BleStatus.ready
                  ? () {
                      _startOrStopScan();
                    }
                  : null,
              child: controller.scanner.rxBleScannerState.value.scanIsInProgress
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
                              valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.onPrimary),
                              strokeWidth: 3,
                            ),
                          )
                        ],
                      ),
                    )
                  : Text("Démarrer")))
        ]));
  }

  void _askPermissions() async {
    if (controller.bleStatusMonitor.rxBleStatus.value ==
        BleStatus.unauthorized) {
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
    if (controller.scanner.rxBleScannerState.value.scanIsInProgress)
      await controller.scanner.stopScan();
    else {
      bool canStart = false;
      if (controller.bleStatusMonitor.rxBleStatus.value == BleStatus.ready)
        canStart = true;
      //   if (permission == PermissionStatus.granted) goForIt = true;
      else if (Platform.isIOS) {
        canStart = true;
      }
      if (canStart)
        controller.scanner
            .startScan(BleScannerFilter(serviceId: [serviceUuid]));
    }
  }
}
