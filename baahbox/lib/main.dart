import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:location_permissions/location_permissions.dart';

void main() {
  return runApp(
    const MaterialApp(home: HomePage()),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  // Some state management stuff
  bool _foundDeviceWaitingToConnect = false;
  bool _scanStarted = false;
  bool _connected = false;
// Bluetooth related variables
  late DiscoveredDevice _ubiqueDevice;
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late QualifiedCharacteristic _rxCharacteristic;
// These are the UUIDs of your device
  final Uuid serviceUuid = Uuid.parse('6E400001-B5A3-F393-E0A9-E50E24DCCA9E');
  final Uuid characteristicUuid = Uuid.parse('6E400003-B5A3-F393-E0A9-E50E24DCCA9E');

  void _startScan() async {
    bool permGranted = false;
    setState((){
      _scanStarted = true;
      print("starting to Scan");
  });

    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) permGranted = true;
    } else if (Platform.isIOS) {
      permGranted = true;
    }

    if (permGranted) {
      _scanStream = flutterReactiveBle.scanForDevices(withServices: [serviceUuid])
          .listen((device) {

           if (device.name == 'My Baah Box 2') {
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

void _connectToDevice(){
    print("connecting to device");
 _scanStream.cancel();
 Stream<ConnectionStateUpdate> _currentConnectionStream =
 flutterReactiveBle.connectToAdvertisingDevice(id: _ubiqueDevice.id,
     withServices: [serviceUuid, characteristicUuid],
     prescanDuration: const Duration(seconds: 1));
 _currentConnectionStream.listen((event) {
   switch (event.connectionState) {
     case DeviceConnectionState.connected:
       {
         _rxCharacteristic = QualifiedCharacteristic(characteristicId: characteristicUuid,
             serviceId: serviceUuid, deviceId: event.deviceId);
         setState(() {
           _foundDeviceWaitingToConnect = false;
           _connected = true;
           //flutterReactiveBle.subscribeToCharacteristic(_rxCharacteristic);
         });
         break;
       }
     case DeviceConnectionState.disconnected: {
       break;
     }
     default:
   }
 });
}
  Stream<List<int>>? subscriptionStream;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child:
        Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        const Text('connected'),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     // persistentFooterButtons: [
        _scanStarted ?
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.grey, // foreground
          ),
          onPressed: () {},
          child: const Icon(Icons.search),
        ) : ElevatedButton(
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // background
          foregroundColor: Colors.white, // foreground
          ),
    onPressed: _startScan,
    child: const Icon(Icons.search),
    ),
        _foundDeviceWaitingToConnect ?
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue, // foreground
          ),
          onPressed: _connectToDevice,
          child: const Icon(Icons.bluetooth),
        ) :
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey, // background
            foregroundColor: Colors.white, // foreground
          ),
          onPressed: () {},
          child: const Icon(Icons.bluetooth),
        ),
        _connected ?
        ElevatedButton(
          onPressed: subscriptionStream != null
              ? null
              : () async {
            setState(() {
              subscriptionStream =
                  flutterReactiveBle.subscribeToCharacteristic(_rxCharacteristic);
            });
          },
          child: const Text('subscribe'),
        ) :ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.grey, // foreground
          ),
          onPressed: () {},
          child: const Icon(Icons.celebration_rounded),
        ),
      ElevatedButton(
        onPressed: () {
          flutterReactiveBle.deinitialize();
          // flutterReactiveBle.scannerState.scanIsInProgress
          //     ? flutterReactiveBle.stopScan
          //     : null;
        },
        child: const Text('disconnect'),
      ),
      ],
    ),
            subscriptionStream != null
                ? StreamBuilder<List<int>>(
                stream: subscriptionStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    return Text(snapshot.data.toString());
                  }
                  return const Text('No data yet');
                })
                : const Text('Stream not initalized')
          ]
      ),
    )
    );
  }
  }
