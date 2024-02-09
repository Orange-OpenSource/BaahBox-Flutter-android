import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

class BleDeviceConnector extends GetxController {
  BleDeviceConnector({
    required FlutterReactiveBle ble,
    required void Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage {
    rxBleConnectionState.bindStream(_deviceConnectionController.stream);
  }

  late StreamSubscription<ConnectionStateUpdate> _connection;
  final _deviceConnectionController = StreamController<ConnectionStateUpdate>();
  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;
  final rxBleConnectionState = Rx<ConnectionStateUpdate>(
      const ConnectionStateUpdate(
          deviceId: "",
          connectionState: DeviceConnectionState.disconnected,
          failure: null));


  Future<void> connect(String deviceMAC) async {
    _logMessage('Start connecting to $deviceMAC');
    _connection = _ble.connectToDevice(id: deviceMAC).listen(
      (update) {
        _logMessage(
            'ConnectionState for device $deviceMAC : ${update.connectionState}');
        _deviceConnectionController.add(update);
      },
      onError: (Object e) =>
          _logMessage('Connecting to device $deviceMAC resulted in error $e'),
    );
  }

  Future<void> disconnect(String deviceMAC) async {
    try {
      _logMessage('disconnecting to device: $deviceMAC');
      await _connection.cancel();
    } on Exception catch (e, _) {
      _logMessage("Error disconnecting from a device: $e");
    } finally {
      // Since [_connection] subscription is terminated, the "disconnected" state cannot be received and propagated
      _deviceConnectionController.add(
        ConnectionStateUpdate(
          deviceId: deviceMAC,
          connectionState: DeviceConnectionState.disconnected,
          failure: null,
        ),
      );
    }
  }

  @override
  Future<void> onClose() async {
    rxBleConnectionState.close();
    await _deviceConnectionController.close();
    super.onClose();
  }
}
