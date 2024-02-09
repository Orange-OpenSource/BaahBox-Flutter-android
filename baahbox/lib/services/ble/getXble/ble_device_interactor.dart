import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

class BleDeviceInteractor extends GetxController {
  BleDeviceInteractor({
    required FlutterReactiveBle ble,
    required void Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;

  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    try {
      _logMessage('Start discovering services for: $deviceId');
      final result = await _ble.discoverServices(deviceId);
      _logMessage('Discovering services finished');
      return result;
    } on Exception catch (e) {
      _logMessage('Error occurred when discovering services: $e');
      rethrow;
    }
  }

  Future<List<int>> readCharacteristic(
      QualifiedCharacteristic characteristic) async {
    try {
      final result = await _ble.readCharacteristic(characteristic);
      _logMessage('Read ${characteristic.characteristicId}: value = $result');
      return result;
    } on Exception catch (e, s) {
      _logMessage(
        'Error occurred when reading ${characteristic.characteristicId} : $e',
      );
      // ignore: avoid_print
      print(s);
      rethrow;
    }
  }

  Future<void> writeCharacteristicWithResponse(
      QualifiedCharacteristic characteristic, List<int> value) async {
    try {
      _logMessage(
          'Write with response value : $value to ${characteristic.characteristicId}');
      await _ble.writeCharacteristicWithResponse(characteristic, value: value);
    } on Exception catch (e, s) {
      _logMessage(
        'Error occurred when writing ${characteristic.characteristicId} : $e',
      );
      // ignore: avoid_print
      print(s);
      rethrow;
    }
  }

  Future<void> writeCharacteristicWithoutResponse(
      QualifiedCharacteristic characteristic, List<int> value) async {
    try {
      await _ble.writeCharacteristicWithoutResponse(characteristic,
          value: value);
      _logMessage(
          'Write without response value: $value to ${characteristic.characteristicId}');
    } on Exception catch (e, s) {
      _logMessage(
        'Error occurred when writing ${characteristic.characteristicId} : $e',
      );
      // ignore: avoid_print
      print(s);
      rethrow;
    }
  }

  Stream<List<int>> subScribeToCharacteristic(
      QualifiedCharacteristic characteristic) {
    _logMessage('Subscribing to: ${characteristic.characteristicId} ');
    return _ble.subscribeToCharacteristic(characteristic);
  }
}
