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

class SheepSettingsPage extends GetView<SettingsController> {
  final mainColor = BBColor.pinky.color;
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText('Réglages du saute mouton', maxLines: 1),
        actions: [
          IconButton(
              icon: Image.asset(
                  'assets/images/Dashboard/settings_icon.png',
                  width: 25, height: 25,
                  color: mainColor),
              onPressed: () => Get.toNamed('/settings')),
        ],
      ),
      body: SafeArea(
    child:ListView(
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
                              'Nombre de barrières: ' +
                                  controller.sheepSettings["numberOfGates"]
                                      .toString(),
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
                          'Vitesse des barrières',
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
              alignment: Alignment.center, child: GateSpeedSelectionView()),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    ));
  }
}

class GateSpeedSelectionView extends StatefulWidget {
  const GateSpeedSelectionView({super.key});

  @override
  State<GateSpeedSelectionView> createState() => _GateSpeedSelectionViewState();
}

class _GateSpeedSelectionViewState extends State<GateSpeedSelectionView> {
  final SettingsController controller = Get.find();
  late ObjectVelocity? _selection;
  void onSelectionChanged (ObjectVelocity? value) {
    setState(() {
      _selection = value;
      if (value != null) {
        controller.setGateSpeedTo(value);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    _selection =
        (controller.sheepSettings["gateVelocity"]) ?? ObjectVelocity.low;
    return Column(
      children: <Widget>[
        RadioListTile.adaptive(
            title:const Text('Faible'),
            value: ObjectVelocity.low,
            groupValue: _selection,
            toggleable: true,
            onChanged:  onSelectionChanged),
        RadioListTile.adaptive(
            title:const Text('Moyenne'),
            value: ObjectVelocity.medium,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),

        RadioListTile.adaptive(
            title:const Text('Elevée'),
            value: ObjectVelocity.high,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),

      ],
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
    final int _nbG = (controller.sheepSettings["numberOfGates"]);
    double _value = _nbG.toDouble();
    return Slider.adaptive(
      value: _value,
      min: 1.0,
      max: 10.0,
      divisions: 10,
      label: _value.round().toString(),
      semanticFormatterCallback: (double newValue) {
        return '${newValue.round()} barrière';
      },
      onChanged: (double value) {
        setState(() {
          _value = value;
          controller.setNumberOfGatesTo(value.toInt());
        });
      },
    );
  }
}
