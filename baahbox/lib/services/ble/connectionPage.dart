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
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:location_permissions/location_permissions.dart';
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:baahbox/model/sensorInput.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';
import 'package:baahbox/services/ble/getXble/getx_ble.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);
  final String title = "BaahBle";

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  List<DiscoveredDevice> _foundBleUARTDevices = [];

  final Controller appController = Get.find();
  final GetxBle bleController = Get.find();

  late StreamSubscription<ConnectionStateUpdate> _connection;
  late QualifiedCharacteristic _rxCharacteristic;
  late Stream<List<int>>? _receivedDataStream;

  final Uuid serviceUuid = Uuid.parse('6E400001-B5A3-F393-E0A9-E50E24DCCA9E');
  final Uuid characteristicUuid =
      Uuid.parse('6E400003-B5A3-F393-E0A9-E50E24DCCA9E');

  bool _scanning = false;
  bool _connected = false;
  String _logTexts = "";

  void initState() {
    super.initState();
    waitBluetoothReady();
  }

  void refreshScreen() {
    setState(() {});
    _connected =
        (bleController.connector.rxBleConnectionState.value.connectionState ==
            DeviceConnectionState.connected);
  }

  void _disconnect() async {
    if (bleController.connector.rxBleConnectionState.value.connectionState ==
        DeviceConnectionState.connected) {
      var deviceId =
          bleController.connector.rxBleConnectionState.value.deviceId;
      await bleController.connector.disconnect(deviceId);
    }
    //await _connection.cancel();
    // _connected = false;
    _logTexts = "";
    refreshScreen();
  }

  void waitBluetoothReady() async {
    bleController.bleLogger.addToLog("waiting for BLE ready");
    bleController.ble.statusStream.listen((event) {
      bleController.bleLogger.addToLog("bleStatus updated");
      switch (event) {
        // Connected
        case BleStatus.ready:
          {
            bleController.bleLogger.addToLog("starting Scanning");
            bleController.scanner.rxBleScannerState.listen((scannerState) {
              _scanning = scannerState.scanIsInProgress;
              _foundBleUARTDevices = scannerState.discoveredDevices;
              refreshScreen();
            });
            _startScan();
            break;
          }
        default:
          {
            bleController.bleLogger.addToLog("ble not ready");
          }
      }
    });
  }

  void _stopScan() async {
    await bleController.scanner.stopScan();
    refreshScreen();
  }

  void _startScan() async {
    bool goForIt = false;
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) goForIt = true;
    } else if (Platform.isIOS) {
      goForIt = true;
    }
    if (goForIt) {
      //TODO replace True with permission == PermissionStatus.granted is for IOS test
      //_foundBleUARTDevices = [];
      refreshScreen();

      bleController.scanner
          .startScan(BleScannerFilter(serviceId: [serviceUuid]));
    } else {
      await showNoPermissionDialog();
    }
  }

  bool isDeviceConnectedToApp(String id) {
    return (bleController
                .connector.rxBleConnectionState.value.connectionState ==
            DeviceConnectionState.connected) &&
        (id == bleController.connector.rxBleConnectionState.value.deviceId);
  }

  void onConnectDevice(index) {
    refreshScreen();
    var deviceId = bleController
        .scanner.rxBleScannerState.value.discoveredDevices[index].id;
    var deviceName = bleController
        .scanner.rxBleScannerState.value.discoveredDevices[index].name;

    if ((deviceId !=
            bleController.connector.rxBleConnectionState.value.deviceId) ||
        (bleController.connector.rxBleConnectionState.value.connectionState ==
            DeviceConnectionState.disconnected)) {
      bleController.connector.connect(deviceId);
      _logTexts = "Essai de connexion avec ${deviceName}\n";
      bleController.connector.rxBleConnectionState.listen((event) {
        var id = event.deviceId.toString();

        switch (event.connectionState) {
          case DeviceConnectionState.connecting:
            {
              _logTexts = "${_logTexts}Connexion en cours ${deviceName}\n";
              break;
            }
          case DeviceConnectionState.connected:
            {
              _logTexts = "${_logTexts}Connecté à $deviceName\n";
              _rxCharacteristic = QualifiedCharacteristic(
                  characteristicId: characteristicUuid,
                  serviceId: serviceUuid,
                  deviceId: event.deviceId);
              subscribeToStream();
              appController.setConnectedDeviceIdTo(id);
              appController.setConnectedDeviceNameTo(deviceName);
              bleController.scanner.stopScan();
              _startScan();
              break;
            }
          case DeviceConnectionState.disconnecting:
            {
              _logTexts = "${_logTexts}Déconnexion de ${deviceName}\n";
              break;
            }
          case DeviceConnectionState.disconnected:
            {
              _logTexts = "${_logTexts}Déconnecté de ${deviceName} \n";
              appController.setConnectedDeviceIdTo("");
              appController.setConnectedDeviceNameTo("");
              _startScan();
              break;
            }
        }
        refreshScreen();
      });
    } else {
      bleController.bleLogger.addToLog(
          "Appareil déjà connecté: ${bleController.connector.rxBleConnectionState.value.deviceId}");
    }
  }

  void subscribeToStream() async {
    setState(() {
      _receivedDataStream =
          bleController.interactor.subScribeToCharacteristic(_rxCharacteristic);
      appController.setConnectionStateTo(_receivedDataStream != null);
      _receivedDataStream?.forEach((element) => updateControllerWith(element));
    });
  }

  void updateControllerWith(List<int> data) {
    var tuples = computeData(data);
    for ((MusclesInput, JoystickInput) tuple in tuples) {
      //print("${tuple.$1.describe()}, ${tuple.$2.describe()}");
      appController.setJoystickTo(tuple.$2);
      appController.setMusclesTo(tuple.$1);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Theme.of(context).colorScheme.shadow,
          titleTextStyle: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 18),
          centerTitle: true,
          title: Text("Connexion Bluetooth"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back,),
              onPressed: () {
                bleController.scanner.stopScan();
                Get.toNamed(BBRoute.welcome.path);
              }),
          actions: [
            IconButton(
              icon: Image.asset('assets/images/Dashboard/bluetooth.png',
                  color: Colors.lightBlueAccent),
              onPressed: () {
                if (_scanning) {
                  bleController.scanner.stopScan();
                } else {
                  _startScan();
                }
              },
            ),
            SizedBox(
              width: 25,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left:20),
                      child: Text(_connected
                      ? "Vous êtes connecté:"
                      : "Sélectionnez votre Baah Box: ",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
              if (_connected)
                ListTile(
                  leading: Image.asset('assets/images/Dashboard/tick.png',
                      width: 20),
                  dense: false,
                  enabled: true,
                  onTap: () async {
                    _disconnect();
                  },
                  title: Text(appController.connectedDeviceName,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  subtitle: Text(appController.connectedDeviceId),
                ),
              SizedBox(
                height: 15,
              ),
              Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 150,
                  child: ListView.builder(
                    itemCount: _foundBleUARTDevices.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: isDeviceConnectedToApp(
                              _foundBleUARTDevices[index].id)
                          ? const Icon(Icons.link, color: Colors.blue)
                          : const Icon(Icons
                              .link_off_outlined),
                      dense: false,
                      enabled: true,
                      onTap: () async {
                        !_connected ? onConnectDevice(index) : _disconnect();
                      },
                      title: Text(_foundBleUARTDevices[index].name,
                          style: TextStyle(
                              color: _connected ? Colors.black : Colors.blue)),
                      subtitle: Text(
                        _foundBleUARTDevices[index].id,
                      ),
                    ),
                  )),
              SizedBox(
                height: 30,
              ),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: const Text("Données reçues:", textAlign:TextAlign.left )),
              Container(
                margin: const EdgeInsets.all(5.0),
                width: 1400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.blue, width: 2)),
                height: 90,
                child: _connected
                    ? Obx(() => Padding(
                        padding: EdgeInsets.all(10),
                        child:
                            Text(appController.musclesInput.describe() + "\n" + appController.joystickInput.describe())))
                    : const Text(""),
              ),
              SizedBox(
                height: 30,
              ),
              const Text(" Messages bluetooth:"),
              Container(
                  margin: const EdgeInsets.all(5.0),
                  width: 1400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue, width: 2)),
                  height: 150,
                  child: Scrollbar(
                      child: SingleChildScrollView(
                          child: Padding(padding: EdgeInsets.all(5), child: Text(
                              //"${bleController.bleLogger.rxMessages.value})//"
                              "$_logTexts"))))),
            ],
          ),
        ),
      );

  Future<void> showNoPermissionDialog() async => showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No location permission '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('No location permission granted.'),
                const Text(
                    'Location permission is required for BLE to function.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Acknowledge'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}
