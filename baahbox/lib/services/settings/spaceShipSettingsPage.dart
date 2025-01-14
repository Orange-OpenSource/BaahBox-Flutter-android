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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/services/settings/settingsController.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

class SpaceShipSettingsPage extends GetView<SettingsController> {
  final mainColor = BBColor.blueGreen.color;
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Réglages de l'espace", maxLines: 1),
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
                          'Nombre de vaisseaux: '+  controller.spaceShipSettings["numberOfShips"].toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                      ]))),
          const SizedBox(
            height: 15,
          ),
          GateNumberSlider(),
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
                        const Text(
                          'Vitesse des astéroïdes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          Align(
              alignment: Alignment.center, child: SpeedSegmentedSegment()),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

class SpeedSegmentedSegment extends StatefulWidget {
  const SpeedSegmentedSegment({super.key});

  @override
  State<SpeedSegmentedSegment> createState() =>
      _SpeedSegmentedSegmentState();
}

class _SpeedSegmentedSegmentState extends State<SpeedSegmentedSegment> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {

    return CustomSlidingSegmentedControl<ObjectVelocity>(
      initialValue: controller.spaceShipSettings["asteroidVelocity"],
      children: {
        ObjectVelocity.low: Text('Faible'),
        ObjectVelocity.medium: Text('Moyenne'),
        ObjectVelocity.high: Text('Elevée'),
      },
      decoration: BoxDecoration(
        color: CupertinoColors.lightBackgroundGray,
        borderRadius: BorderRadius.circular(8),
      ),
      thumbDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(
              0.0,
              2.0,
            ),
          ),
        ],
      ),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInToLinear,
      onValueChanged: (ObjectVelocity v) {
        controller.setAsteroidSpeedTo(v);
      },
    );
  }
}

class GateNumberSlider extends StatefulWidget {
  const GateNumberSlider({super.key});

  @override
  State<GateNumberSlider> createState() => _GateNumberSliderState();
}

class _GateNumberSliderState extends State<GateNumberSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final int _nbG = controller.spaceShipSettings["numberOfShips"];
    double _value = _nbG.toDouble();
    return Slider(
      value: _value,
      min: 1.0,
      max: 10.0,
      divisions: 10,
      label: _value.round().toString(),
      onChanged: (double value) {
        setState(() {
          _value = value;
          controller.setNumberOfShipsTo(value.toInt());
        });
      },
    );
  }
}
