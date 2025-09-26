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

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'BleController.dart';

class BleDevicesView extends GetView<BleController> {
  const BleDevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: controller.availableDevices.map((device) {
                return ListTile(
                    leading: controller.connectedDevice.value?.deviceID ==
                            device.deviceID
                        ? const Icon(Icons.link, color: Colors.blue)
                        : const Icon(Icons.link_off_outlined),
                    trailing: device.isWorking.value == true
                        ? SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).colorScheme.onSurface),
                          strokeWidth: 3,
                          color:
                          Theme.of(context).colorScheme.onSurface),
                    )
                        : null,
                    dense: false,
                    enabled: true,
                    onTap: () async {
                      if (controller.connectedDevice.value?.deviceID ==
                          device.deviceID) {
                        controller.disconnectDevice();
                      } else if (controller.adapterState.value ==
                          BleAdapterState.enable) {
                        controller.connectOnDeviceId(device.deviceID);
                      }
                    },
                    title: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        device.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      controller.connectedDevice.value?.deviceID ==
                              device.deviceID
                          ? Text(
                              "connectée",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )
                          : SizedBox(width: 0),
                    ]),
                    subtitle: Text(
                      device.deviceID,
                    ));
              }).toList()));
    });
  }
}
