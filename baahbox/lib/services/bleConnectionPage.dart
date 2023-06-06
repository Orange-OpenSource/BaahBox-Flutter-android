import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:baahbox/model/sensorInput.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';


class BleConnectionPage extends StatefulWidget {
  const BleConnectionPage({Key? key}) : super(key: key);

  @override
  _BleConnectionPageState createState() => _BleConnectionPageState();
}

class _BleConnectionPageState extends State<BleConnectionPage> {
  // Some state management stuff
  bool _foundDeviceWaitingToConnect = false;
  bool _scanStarted = false;
  bool _connected = false;
// Bluetooth related variables
  late DiscoveredDevice _ubiqueDevice;
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late QualifiedCharacteristic _rxCharacteristic;
  final Controller c = Get.put(Controller());

// These are the UUIDs of your device
  final Uuid serviceUuid = Uuid.parse('6E400001-B5A3-F393-E0A9-E50E24DCCA9E');
  final Uuid characteristicUuid =
  Uuid.parse('6E400003-B5A3-F393-E0A9-E50E24DCCA9E');
  Stream<List<int>>? subscriptionStream;
  void _startScan() async {
    bool permGranted = false;
    PermissionStatus permission;

    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) permGranted = true;
    } else if (Platform.isIOS) {
      permGranted = true;
    }
    if (permGranted) {
      setState(() {
        _scanStarted = true;
        print("starting to Scan");
      });
      _scanStream = flutterReactiveBle
          .scanForDevices(withServices: [serviceUuid]).listen((device) {
        if (device.name.contains(RegExp('Baah Box'))) {
          print("found !");
          print(device.name);
          print(device.id);
          setState(() {
            _ubiqueDevice = device;
            _foundDeviceWaitingToConnect = true;
          });
        }
      });
    }
  }

  void _connectToDevice() {
    print("connecting to device");
    _scanStream.cancel();
    Stream<ConnectionStateUpdate> _currentConnectionStream =
    flutterReactiveBle.connectToAdvertisingDevice(
        id: _ubiqueDevice.id,
        withServices: [serviceUuid, characteristicUuid],
        prescanDuration: const Duration(seconds: 1));
    _currentConnectionStream.listen((event) {
      switch (event.connectionState) {
        case DeviceConnectionState.connected:
          {
            _rxCharacteristic = QualifiedCharacteristic(
                characteristicId: characteristicUuid,
                serviceId: serviceUuid,
                deviceId: event.deviceId);
            setState(() {
              _foundDeviceWaitingToConnect = false;
              _connected = true;
              //flutterReactiveBle.subscribeToCharacteristic(_rxCharacteristic);
            });
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            break;
          }
        default:
      }
    });
  }


  void subscribeToStream() async  {
    setState(() {
      subscriptionStream = flutterReactiveBle
          .subscribeToCharacteristic(_rxCharacteristic);
      subscriptionStream?.forEach((element) => updateControllerWith(element));
    });
  }

  void updateControllerWith(List<int> data) {
    var tuples = computeData(data);
    for ((MusclesInput, JoystickInput) tuple in tuples) {
      print("${tuple.$1.describe()}, ${tuple.$2.describe()}");
      c.setJoystickTo(tuple.$2);
      c.setMusclesTo(tuple.$1);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
          fontSize: 25),
      centerTitle: true,
      title: Text("Bluetooth Connexion"),
      leading: IconButton(
          icon: Icon( Icons.arrow_back,color: Colors.lightBlueAccent,),
          onPressed: () => Get.toNamed(BBRoutes.welcome)
      ),
    ),
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Baah Box connexion'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // persistentFooterButtons: [
                    _scanStarted
                        ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey, // foreground
                      ),
                      onPressed: () {},
                      child: const Icon(Icons.search),
                    )
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // background
                        foregroundColor: Colors.white, // foreground
                      ),
                      onPressed: _startScan,
                      child: const Icon(Icons.search),
                    ),
                    _foundDeviceWaitingToConnect
                        ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue, // foreground
                      ),
                      onPressed: _connectToDevice,
                      child: const Icon(Icons.bluetooth),
                    )
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // background
                        foregroundColor: Colors.white, // foreground
                      ),
                      onPressed: () {},
                      child: const Icon(Icons.bluetooth),
                    ),
                    _connected
                        ? ElevatedButton(
                      onPressed: subscriptionStream != null
                          ? null
                          : () {
                        subscribeToStream();
                      },
                      child: const Text('subscribe'),
                    )
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey, // foreground
                      ),
                      onPressed: () {},
                      child: const Text('subscribe'),
                    ),
                    _connected
                        ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue, // foreground
                      ),
                      onPressed: () {
                        flutterReactiveBle.deinitialize();
                      }
                      // flutterReactiveBle.scannerState.scanIsInProgress
                      //    ? flutterReactiveBle.stopScan
                      //    : null;}
                      ,
                      child: const Text('disconnect'),
                    )
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey, // foreground
                      ),
                      onPressed: () {},
                      child: const Text('disconnect'),
                    ),
                  ],
                ),
                subscriptionStream != null
                    ?
                Obx(() => Container(
                    width: 150,
                    height: (c.musclesInput.muscle1).toDouble() / 5,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(),
                    ),

                    child: Text(c.musclesInput.describe())
                ))
                    : const Text('Stream not initialized'),
                SizedBox(height: 80,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey, // foreground
                  ),
                  onPressed: () => Get.toNamed(BBRoutes.welcome),
                  child: const Text('back to the games !'),
                )
              ]),
        )
    );
  }
}

