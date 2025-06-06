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
import 'package:baahbox/services/settings/settingsController.dart';

class HandleSettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Card(
              shape: ContinuousRectangleBorder(),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Amplitude de mouvement',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Sélectionnez l\'amplitude de mouvement à détecter (en degrés de rotation).',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Obx(() => Text(
                    "Limite basse (entre 0° et 90°) : ${controller.handleSettings.rangeForHandleLower}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ))),
          const SizedBox(
            height: 5,
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: RotationSlider(isLower: true, min: 0, max: 90)),
          const SizedBox(
            height: 12,
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Obx(() => Text(
                    "Limite haute (entre 90° et 180°) : ${controller.handleSettings.rangeForHandleUpper}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ))),
          const SizedBox(
            height: 5,
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: RotationSlider(isLower: false, min: 90, max: 180)),
        ]));
  }
}

class RotationSlider extends StatefulWidget {
  const RotationSlider(
      {super.key, required this.isLower, required this.min, required this.max});
  final bool isLower;
  final int min;
  final int max;

  @override
  State<RotationSlider> createState() => _RotationSliderState();
}

class _RotationSliderState extends State<RotationSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    double _value = widget.min.toDouble();
    if (widget.isLower) {
      _value = controller.handleSettings.rangeForHandleLower.toDouble();
    } else {
      _value = controller.handleSettings.rangeForHandleUpper.toDouble();
    }

    return Slider.adaptive(
        value: _value,
        min: widget.min.toDouble(),
        max: widget.max.toDouble(),
        divisions: widget.max - widget.min,
        label: _value.round().toString(),
        semanticFormatterCallback: (double newValue) {
          return '${newValue.round()}';
        },
        onChanged: (double value) {
          setState(() {
            _value = value;
            if (widget.isLower) {
              controller.handleSettings.rangeForHandleLower = value.toInt();
            } else {
              controller.handleSettings.rangeForHandleUpper = value.toInt();
            }
          });
        });
  }
}
