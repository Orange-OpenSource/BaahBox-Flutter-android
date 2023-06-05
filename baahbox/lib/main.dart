import 'package:baahbox/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() {
  return runApp(
    const GetMaterialApp(home: WelcomePage()),
  );
}

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // Some state management stuff
//   bool _foundDeviceWaitingToConnect = false;
//   bool _scanStarted = false;
//   bool _connected = false;
// // Bluetooth related variables
//   late DiscoveredDevice _ubiqueDevice;
//   final flutterReactiveBle = FlutterReactiveBle();
//   late StreamSubscription<DiscoveredDevice> _scanStream;
//   late QualifiedCharacteristic _rxCharacteristic;
//   final Controller c = Get.put(Controller());
//
// // These are the UUIDs of your device
//   final Uuid serviceUuid = Uuid.parse('6E400001-B5A3-F393-E0A9-E50E24DCCA9E');
//   final Uuid characteristicUuid =
//       Uuid.parse('6E400003-B5A3-F393-E0A9-E50E24DCCA9E');
//   Stream<List<int>>? subscriptionStream;
//   void _startScan() async {
//     bool permGranted = false;
//     PermissionStatus permission;
//
//     if (Platform.isAndroid) {
//       permission = await LocationPermissions().requestPermissions();
//       if (permission == PermissionStatus.granted) permGranted = true;
//     } else if (Platform.isIOS) {
//       permGranted = true;
//     }
//     if (permGranted) {
//       setState(() {
//         _scanStarted = true;
//         print("starting to Scan");
//       });
//       _scanStream = flutterReactiveBle
//           .scanForDevices(withServices: [serviceUuid]).listen((device) {
//         if (device.name.contains(RegExp('Baah Box'))) {
//           print("found !");
//           print(device.name);
//           print(device.id);
//           setState(() {
//             _ubiqueDevice = device;
//             _foundDeviceWaitingToConnect = true;
//           });
//         }
//       });
//     }
//   }
//
//   void _connectToDevice() {
//     print("connecting to device");
//     _scanStream.cancel();
//     Stream<ConnectionStateUpdate> _currentConnectionStream =
//         flutterReactiveBle.connectToAdvertisingDevice(
//             id: _ubiqueDevice.id,
//             withServices: [serviceUuid, characteristicUuid],
//             prescanDuration: const Duration(seconds: 1));
//     _currentConnectionStream.listen((event) {
//       switch (event.connectionState) {
//         case DeviceConnectionState.connected:
//           {
//             _rxCharacteristic = QualifiedCharacteristic(
//                 characteristicId: characteristicUuid,
//                 serviceId: serviceUuid,
//                 deviceId: event.deviceId);
//             setState(() {
//               _foundDeviceWaitingToConnect = false;
//               _connected = true;
//               //flutterReactiveBle.subscribeToCharacteristic(_rxCharacteristic);
//             });
//             break;
//           }
//         case DeviceConnectionState.disconnected:
//           {
//             break;
//           }
//         default:
//       }
//     });
//   }
//
//
//   void subscribeToStream() async  {
//       setState(() {
//         subscriptionStream = flutterReactiveBle
//             .subscribeToCharacteristic(_rxCharacteristic);
//         subscriptionStream?.forEach((element) => updateControllerWith(element));
//       });
//   }
//
//  void updateControllerWith(List<int> data) {
//    var tuples = computeData(data);
//    for ((MusclesInput, JoystickInput) tuple in tuples) {
//      print("${tuple.$1.describe()}, ${tuple.$2.describe()}");
//      c.setJoystickTo(tuple.$2);
//      c.setMusclesTo(tuple.$1);
//    }
//  }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: Container(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Text('Baah Box connexion'),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // persistentFooterButtons: [
//                     _scanStarted
//                         ? ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               foregroundColor: Colors.white,
//                               backgroundColor: Colors.grey, // foreground
//                             ),
//                             onPressed: () {},
//                             child: const Icon(Icons.search),
//                           )
//                         : ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue, // background
//                               foregroundColor: Colors.white, // foreground
//                             ),
//                             onPressed: _startScan,
//                             child: const Icon(Icons.search),
//                           ),
//                     _foundDeviceWaitingToConnect
//                         ? ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               foregroundColor: Colors.white,
//                               backgroundColor: Colors.blue, // foreground
//                             ),
//                             onPressed: _connectToDevice,
//                             child: const Icon(Icons.bluetooth),
//                           )
//                         : ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.grey, // background
//                               foregroundColor: Colors.white, // foreground
//                             ),
//                             onPressed: () {},
//                             child: const Icon(Icons.bluetooth),
//                           ),
//                     _connected
//                         ? ElevatedButton(
//                             onPressed: subscriptionStream != null
//                                 ? null
//                                 : () {
//                               subscribeToStream();
//                             },
//                             child: const Text('subscribe'),
//                           )
//                         : ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               foregroundColor: Colors.white,
//                               backgroundColor: Colors.grey, // foreground
//                             ),
//                             onPressed: () {},
//                             child: const Text('subscribe'),
//                           ),
//                     _connected
//                         ? ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               foregroundColor: Colors.white,
//                               backgroundColor: Colors.blue, // foreground
//                             ),
//                             onPressed: () {
//                               flutterReactiveBle.deinitialize();
//                             }
//                             // flutterReactiveBle.scannerState.scanIsInProgress
//                             //    ? flutterReactiveBle.stopScan
//                             //    : null;}
//                             ,
//                             child: const Text('disconnect'),
//                           )
//                         : ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               foregroundColor: Colors.white,
//                               backgroundColor: Colors.grey, // foreground
//                             ),
//                             onPressed: () {},
//                             child: const Text('disconnect'),
//                           ),
//                   ],
//                 ),
//                 subscriptionStream != null
//                     ?
//              //   StreamBuilder<List<int>>(
//                //         stream: subscriptionStream,
//                 //        builder: (context, snapshot) {
//                    //       if (snapshot.hasData) {
//                     //        print('next: ${snapshot.data} \n');
//                      //       print("==================");
//                            // updateControllerWith(snapshot.data!.toList());
//
//                            // return
//                 Obx(() => Container(
//                                 width: 150,
//                                 height: (c.musclesInput.muscle1).toDouble() / 5,
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue,
//                                   border: Border.all(),
//                                 ),
//
//                                 child: Text(c.musclesInput.describe())
//                             ))
//     //;
//                         //  }
//                          // return const Text('No data yet');
//                      //   })
//                     : const Text('Stream not initialized'),
//
//                 _connected
//                     ? ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: Colors.blue, // foreground
//                         ),
//                         onPressed: () => Get.to(() => SheepGame()),
//                         child: const Text('sheep'),
//                       )
//                     : ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: Colors.grey, // foreground
//                         ),
//                         onPressed: () => Get.to(() => WelcomePage()),
//                         child: const Text('sheep'),
//                       )
//               ]),
//         )
//     );
//   }
// }

