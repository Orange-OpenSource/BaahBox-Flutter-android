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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../../model/sensorInput.dart';

enum BleAdapterState {
  unavailable,
  unauthorized,
  enable,
  disabled,
  waiting;
}

class BleDevice {
  late final String name;
  late final String deviceID;
  Rx<bool> isConnected = false.obs;
  Rx<bool> isWorking = false.obs;
  BleDevice({required this.name, required this.deviceID});
}

final String serviceUuid = '6E400001-B5A3-F393-E0A9-E50E24DCCA9E';
final String characteristicUuid = '6E400003-B5A3-F393-E0A9-E50E24DCCA9E';

class BleController extends GetxController {
  var isActivated = false.obs;

  var adaptaterState = BleAdapterState.unavailable.obs;

  var isScanningDevices = false.obs;

  Rx<BleDevice?> connectedDevice = (null as BleDevice?).obs;
  var availableDevices = <BleDevice>[].obs;

  late StreamSubscription<BluetoothAdapterState> _stateSubscription;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];

  var _analogInputs = AnalogInputs(0, 0).obs;
  var _digitalInputs = DigitalInputs(0).obs;

  AnalogInputs get analogInputs => _analogInputs.value;
  DigitalInputs get digitalInputs => _digitalInputs.value;

  void init() async {
    if (await FlutterBluePlus.isSupported == false) {
      adaptaterState.value = BleAdapterState.unavailable;
    } else {
      checkStateSubscription();
      scanDevicesSubscription();
    }
  }

  void resetSubscriptions() {
    _stateSubscription.cancel();
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    isScanningDevices.value = false;
    resetDevices();
  }

  void resetDevices() {
    availableDevices.value = [];
    connectedDevice.value = null;
  }

  void enableBlueTooth() {
    FlutterBluePlus.turnOn(timeout: 60);
  }

  void checkStateSubscription() {
    _stateSubscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      switch (state) {
        case BluetoothAdapterState.unknown:
          adaptaterState.value = BleAdapterState.unavailable;
          resetDevices();
          isScanningDevices.value = false;
        case BluetoothAdapterState.unavailable:
          adaptaterState.value = BleAdapterState.unavailable;
          resetDevices();
          isScanningDevices.value = false;
        case BluetoothAdapterState.unauthorized:
          adaptaterState.value = BleAdapterState.unauthorized;
          resetDevices();
          isScanningDevices.value = false;
        case BluetoothAdapterState.turningOn:
          adaptaterState.value = BleAdapterState.waiting;
          isScanningDevices.value = false;
        case BluetoothAdapterState.on:
          adaptaterState.value = BleAdapterState.enable;
        case BluetoothAdapterState.turningOff:
          adaptaterState.value = BleAdapterState.waiting;
        case BluetoothAdapterState.off:
          adaptaterState.value = BleAdapterState.disabled;
          resetDevices();
          isScanningDevices.value = false;
      }
    });
  }

  void scanDevicesSubscription() {
    _scanResultsSubscription = FlutterBluePlus.onScanResults.listen((results) {
      _scanResults = results;
      var newList = results.map((ScanResult elt) {
        if (connectedDevice.value != null &&
            connectedDevice.value?.deviceID == elt.device.remoteId.toString()) {
          return connectedDevice.value!;
        } else {
          return BleDevice(
              name: elt.device.advName,
              deviceID: elt.device.remoteId.toString())
            ..isConnected.value = elt.device.isConnected
          ..isWorking.value = false;
        }
      }).toList();
      availableDevices.value = newList;
      availableDevices.refresh();
    }, onError: (e) {
      //isScanningDevices.value=false;
      print(e);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      isScanningDevices.value = state;
    });
  }

  void startScanDevices() async {
    // try {
    //   // withServices is required on iOS for privacy purposes, ignored on android.
    //   var withServices = [Guid(serviceUuid)];
    //   _systemDevices = await FlutterBluePlus.systemDevices(withServices);
    // } catch (e, backtrace) {
    //   print(e);
    //   print("backtrace: $backtrace");
    // }
    try {
      _scanResults = [];
      await FlutterBluePlus.startScan(
//        timeout: const Duration(seconds: 15),
          withServices: [
            // Guid("180f"), // battery
            Guid(serviceUuid)
          ],
          androidScanMode: AndroidScanMode.lowPower);
    } catch (e, backtrace) {
      print(e);
      print("backtrace: $backtrace");
    }
  }

  Future stopScanDevices() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e, backtrace) {
      print(e);
      print("backtrace: $backtrace");
    }
  }

  void connectOnDeviceId(String deviceID) {
    var device = _scanResults.firstWhereOrNull(
        (element) => element.device.remoteId.toString() == deviceID);
    if (device != null) {
      connectOnDevice(device.device);
    }
  }

  void connectOnDevice(BluetoothDevice device) async {
    stopScanDevices();

    var subscription =
        device.connectionState.listen((BluetoothConnectionState state) {
      switch (state) {
        case BluetoothConnectionState.disconnected:
          deviceDisconnected(device);
        case BluetoothConnectionState.connected:
          {
            deviceConnected(device);
            scanDeviceServices(device);
          }
        case BluetoothConnectionState.connecting:
        case BluetoothConnectionState.disconnecting:
      }
    }, onError: (e) {
      print(e);
    });
    var associatedAvailableDevice = availableDevices.firstWhereOrNull(
            (element) =>
        element.deviceID == device.remoteId.toString().toUpperCase());
    associatedAvailableDevice?.isWorking.value = true;

    await device.connect();
    /* if(device.isConnected) {
      deviceConnected(device);
      scanDeviceServices(device);
    }*/
// cleanup: cancel subscription when disconnected
//   - [delayed] This option is only meant for `connectionState` subscriptions.
//     When `true`, we cancel after a small delay. This ensures the `connectionState`
//     listener receives the `disconnected` event.
//   - [next] if true, the the stream will be canceled only on the *next* disconnection,
//     not the current disconnection. This is useful if you setup your subscriptions
//     before you connect.
    device.cancelWhenDisconnected(subscription, delayed: true, next: false);
  }

  void deviceConnected(BluetoothDevice device) {
    var associatedAvailableDevice = availableDevices.firstWhereOrNull(
        (element) =>
            element.deviceID == device.remoteId.toString().toUpperCase());
    associatedAvailableDevice?.isConnected.value = true;
    associatedAvailableDevice?.isWorking.value = false;
    connectedDevice.value = associatedAvailableDevice;
  }

  void disconnectDevice() {
    var device = _scanResults.firstWhereOrNull((element) =>
        element.device.remoteId.toString() == connectedDevice.value?.deviceID);
    if (device != null) {
      //deviceDisconnected(device.device);
      var associatedAvailableDevice = availableDevices.firstWhereOrNull(
              (element) =>
          element.deviceID == device.device.remoteId.toString().toUpperCase());
      associatedAvailableDevice?.isWorking.value = true;
    }

    device?.device.disconnect();
  }

  void deviceDisconnected(BluetoothDevice device) {
    var associatedAvailableDevice = availableDevices.firstWhereOrNull(
        (element) =>
            element.deviceID == device.remoteId.toString().toUpperCase());
    if(associatedAvailableDevice?.isConnected.value==true)
      {
        associatedAvailableDevice?.isWorking.value = false;
      }
    associatedAvailableDevice?.isConnected.value = false;



    if(connectedDevice.value!=null) {
      Get.snackbar(
        "BaahBox deconnectée",
        "${device.advName} est maintenant deconnectée",
        snackPosition: SnackPosition.TOP,
        colorText : Get.context!=null ? Theme.of(Get.context!).colorScheme.onSurface : Colors.black,
        backgroundColor: Get.context!=null ? Theme.of(Get.context!).colorScheme.surface : Colors.white,
        borderRadius: 10,
        icon: Image.asset(
          "assets/images/Dashboard/bluetooth.png",
          height: 40,
          width: 40,
        ),
      );
    }

    connectedDevice.value = null;
  }

  void scanDeviceServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();

    var baahboxService = services.firstWhereOrNull((element) =>
        element.serviceUuid.toString().toUpperCase() == serviceUuid);

    if (baahboxService != null) {
      List<BluetoothCharacteristic> characteristics =
          baahboxService.characteristics;
      var baahboxCharacteristics = characteristics.firstWhereOrNull((element) =>
          element.characteristicUuid.toString().toUpperCase() ==
          characteristicUuid);

      if (baahboxCharacteristics != null) {
        await baahboxCharacteristics.setNotifyValue(true);
        // cleanup: cancel subscription when disconnected

        var characteristicsSubscription =
            baahboxCharacteristics.onValueReceived.listen((value) {
          // Process the received data (value) here
          var tuples = computeData(value);
          for ((AnalogInputs, DigitalInputs) tuple in tuples) {
            _analogInputs.value = tuple.$1;
            _digitalInputs.value = tuple.$2;
          }
        });
        device.cancelWhenDisconnected(characteristicsSubscription);
      }
    }
  }

  @override
  void onClose() {
    resetSubscriptions();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
}
