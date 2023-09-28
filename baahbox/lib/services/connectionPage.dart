import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:location_permissions/location_permissions.dart';
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:baahbox/model/sensorInput.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/routes/routes.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);
  final String title = "BaahBle";
  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> _foundBleUARTDevices = [];

  final Controller appController = Get.put(Controller());
  //final GetxBle bleController = Get.put(GetxBle());

  late StreamSubscription<DiscoveredDevice> _scanStream;
  late Stream<ConnectionStateUpdate> _currentConnectionStream;
  late StreamSubscription<ConnectionStateUpdate> _connection;
  late QualifiedCharacteristic _txCharacteristic;
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
  }

  void _disconnect() async {
    await _connection.cancel();
    _connected = false;
    _logTexts = "";
    refreshScreen();
  }

  void waitBluetoothReady() async {
    flutterReactiveBle.statusStream.listen((event) {
      switch (event) {
      // Connected
        case BleStatus.ready:
          {
            _startScan();
            break;
          }
        default:
      }
    });
  }

  void _stopScan() async {
    await _scanStream.cancel();
    _scanning = false;
    refreshScreen();
  }

  Future<void> showNoPermissionDialog() async => showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) => AlertDialog(
      title: const Text('No location permission '),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text('No location permission granted.'),
            const Text('Location permission is required for BLE to function.'),
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

  void _startScan() async {
    bool goForIt=false;
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted)
        goForIt=true;
    } else if (Platform.isIOS) {
      goForIt=true;
    }
    if (goForIt) { //TODO replace True with permission == PermissionStatus.granted is for IOS test
      _foundBleUARTDevices = [];
      _scanning = true;
      _logTexts = "";
      refreshScreen();

      _scanStream =
          flutterReactiveBle.scanForDevices(withServices: [serviceUuid]).listen((
              device) {
            if (_foundBleUARTDevices.every((element) =>
            element.id != device.id)) {
              _foundBleUARTDevices.add(device);
              refreshScreen();
            }
          }, onError: (Object error) {
            _logTexts =
            "${_logTexts}ERROR while scanning:$error \n";
            refreshScreen();
          }
          );
    }
    else {
      await showNoPermissionDialog();
    }
  }

  void onConnectDevice(index) {
    _logTexts = "";
    refreshScreen();
    _connection =
            flutterReactiveBle.connectToDevice(id: _foundBleUARTDevices[index].id).listen(
            (event) {
      var id = event.deviceId.toString();

      switch(event.connectionState) {
        case DeviceConnectionState.connecting:
          {
            _logTexts = "${_logTexts}Connecting to $id\n";
            break;
          }
        case DeviceConnectionState.connected:
          {
            _connected = true;
            _logTexts = "${_logTexts}Connected to $id\n";
            _rxCharacteristic = QualifiedCharacteristic(
                characteristicId: characteristicUuid,
                serviceId: serviceUuid,
                deviceId: event.deviceId);
            subscribeToStream();
            break;
          }
        case DeviceConnectionState.disconnecting:
          {
            _connected = false;
            _logTexts = "${_logTexts}Disconnecting from $id\n";
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            _logTexts = "${_logTexts}Disconnected from $id\n";
            break;
          }
      }
      refreshScreen();
    });
  }

  void subscribeToStream() async {
    setState(() {
      _receivedDataStream =
          flutterReactiveBle.subscribeToCharacteristic(_rxCharacteristic);
      appController.setConnectionStateTo(_receivedDataStream != null);
      _receivedDataStream?.forEach((element) => updateControllerWith(element));
    });
  }

  void updateControllerWith(List<int> data) {
    var tuples = computeData(data);
    for ((MusclesInput, JoystickInput) tuple in tuples) {
       print("${tuple.$1.describe()}, ${tuple.$2.describe()}");
      appController.setJoystickTo(tuple.$2);
      appController.setMusclesTo(tuple.$1);
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
          color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 25),
      centerTitle: true,
      title: Text("Bluetooth Connexion"),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.lightBlueAccent,
          ),
          onPressed: () {
            _scanStream.cancel();
            print("stop scanning");
            Get.toNamed(BBRoute.welcome.path);
          }),
    ),
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          const Text("Liste des Baah Box"),
          Container(
              margin: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.blue,
                      width:2
                  )
              ),
              height: 100,
              child: ListView.builder(
                  itemCount: _foundBleUARTDevices.length,
                  itemBuilder: (context, index) => Card(
                      child: ListTile(
                        dense: true,
                        enabled: ((!_connected && _scanning) || (!_scanning && _connected)),
                        trailing: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            (!_connected && _scanning) ?  onConnectDevice(index): () {};
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            alignment: Alignment.center,
                            child: const Icon(Icons.add_link),
                          ),
                        ),
                        subtitle: Text(_foundBleUARTDevices[index].id),
                        title: Text("$index: ${_foundBleUARTDevices[index].name} "),
                      ))
              )
          ),
          SizedBox(
            height: 15,
          ),
          const Text("Status messages:"),
          Container(
              margin: const EdgeInsets.all(3.0),
              width:1400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.blue,
                      width:2
                  )
              ),
              height: 90,
              child: Scrollbar(

                  child: SingleChildScrollView(
                      child: Text(_logTexts)
                  )
              )
          ),
          SizedBox(
            height: 15,
          ),
          const Text("Received data:"),
          Container(
              margin: const EdgeInsets.all(3.0),
              width:1400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.blue,
                      width:2
                  )
              ),
              height: 90,
              child:  _connected ? Obx(() => Text(appController.musclesInput.describe().obs())) : const Text(""),
          ),
              ],
      ),
    ),
    persistentFooterButtons: [
      Container(
        height: 35,
        child: Column(
          children: [
            if (_scanning) const Text("Scanning: Scanning") else const Text("Scanning: Idle"),
            if (_connected) const Text("Connected") else const Text("disconnected."),
          ],
        ) ,
      ),
      ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.brown.shade50, // foreground
                ),
        onPressed: !_scanning && !_connected ? _startScan : (){},
        child: Icon(
          Icons.play_arrow,
          color: !_scanning && !_connected ? Colors.blue: Colors.grey,
        ),
      ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.brown.shade50, // foreground
          ),
          onPressed: _scanning ? _stopScan: (){},
          child: Icon(
            Icons.stop,
            color:_scanning ? Colors.blue: Colors.grey,
          )
      ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.brown.shade50, // foreground
          ),
          onPressed: _connected ? _disconnect: (){},
          child: Icon(
            Icons.cancel,
            color:_connected ? Colors.blue: Colors.grey,
          )
      )
    ],
  );
}
