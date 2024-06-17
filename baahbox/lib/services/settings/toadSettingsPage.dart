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
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/services/settings/settingsController.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

class ToadSettingsPage extends GetView<SettingsController> {
  final mainColor = BBGameList.toad.baseColor.color;
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Réglages du crapaud", maxLines: 1),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 32, top: 8),
          ),
          Card(
              shape: ContinuousRectangleBorder(),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              'Nombre de mouches: ' +
                                  controller.toadSettings["numberOfFlies"]
                                      .toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                      ]))),
          const SizedBox(
            height: 15,
          ),
          FlyNumberSlider(),
          const SizedBox(
            height: 24,
          ),
          Card(
              shape: ContinuousRectangleBorder(),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                          'Temps pendant lequel les mouches ne bougent pas (en s): ' +
                              controller.toadSettings["flySteadyTime"].round().toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          FlyDurationSlider(),
          const SizedBox(
            height: 24,
          ),
          Card(
              shape: ContinuousRectangleBorder(),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          'Mode de tirs: ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          ListTile(
              title: Text("Tirs automatiques"),
              trailing: Obx(() => Switch(
                value: controller.toadSettings["iShootingModeAutomatic"],
                activeColor: Colors.red,
                onChanged: (bool val) {
                  controller.setToadShootingModeToAutomatic(val);
                },
              ))),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}


class FlyDurationSlider extends StatefulWidget {
  const FlyDurationSlider({super.key});

  @override
  State<FlyDurationSlider> createState() => _FlyDurationSliderState();
}

class _FlyDurationSliderState extends State<FlyDurationSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final double _flyDuration = controller.toadSettings["flySteadyTime"];
    double _value = _flyDuration;
    return Slider(
      value: _value,
      min: 1,
      max: 5,
      divisions: 5,
      label: _value.floor().toString(),
      onChanged: (double value) {
        setState(() {
          _value = value.floorToDouble();
          controller.setFlyDurationTo(_value);
        });
      },
    );
  }
}


class FlyNumberSlider extends StatefulWidget {
  const FlyNumberSlider({super.key});

  @override
  State<FlyNumberSlider> createState() => _FlyNumberSliderState();
}

class _FlyNumberSliderState extends State<FlyNumberSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final int _nbF = controller.toadSettings["numberOfFlies"];
    double _value = _nbF.toDouble();
    return Slider(
      value: _value,
      min: 1.0,
      max: 10.0,
      divisions: 10,
      label: _value.round().toString(),
      onChanged: (double value) {
        setState(() {
          _value = value;
          controller.setNumberOfFliesTo(value.toInt());
        });
      },
    );
  }
}
