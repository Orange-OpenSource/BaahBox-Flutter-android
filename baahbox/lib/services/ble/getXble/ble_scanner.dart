import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

class BleScanner extends GetxController {
  BleScanner({
    required FlutterReactiveBle ble,
    required void Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage {
    rxBleScannerState.bindStream(_stateStreamController.stream);
  }

  final FlutterReactiveBle _ble;
  final StreamController<BleScannerState> _stateStreamController =
  StreamController();
  StreamSubscription? _subscription;
  final rxBleScannerState = Rx<BleScannerState>(
      const BleScannerState(discoveredDevices: [], scanIsInProgress: false));
  final _devices = <DiscoveredDevice>[];


  final void Function(String message) _logMessage;

  void startScan(BleScannerFilter filter) {
    _logMessage('Recherche des équipements BLE');
    _devices.clear();
    _subscription?.cancel();
    _subscription = _ble
        .scanForDevices(withServices: filter.serviceId ?? [])
        .listen((device) {
      final knownDeviceIndex = _devices.indexWhere((d) => d.id == device.id);

      if (knownDeviceIndex >= 0) {
        _devices[knownDeviceIndex] = device;
      } else {
        if (device.name
            .toLowerCase()
            .contains((filter.name ?? "".toLowerCase()))) {
          if (device.id.contains((filter.mac ?? ""))) {
            if (device.rssi >= (filter.rssi ?? -100)) {
              _devices.add(device);
            }
          }
        }
      }
      _pushState();
    }, onError: (Object e) => _logMessage('Erreur lors de la recherche BLE: $e'));
    _pushState();
  }

  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> stopScan() async {
    _logMessage('Arrêt de la recherche BLE');

    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  @override
  Future<void> onClose() async {
    rxBleScannerState.close();
    await _stateStreamController.close();
    super.onClose();
  }
}

@immutable
class BleScannerState {
  const BleScannerState({
    required this.discoveredDevices,
    required this.scanIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;
}

class BleScannerFilter {
  String? name;
  String? mac;
  List<Uuid>? serviceId;
  int? rssi;

  BleScannerFilter({
    this.name,
    this.mac,
    this.serviceId,
    this.rssi,
  });
}
