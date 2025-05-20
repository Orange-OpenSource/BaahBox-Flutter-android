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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/controllers/appController.dart';
import 'package:baahbox/services/settings/settingsController.dart';

import 'generalSettingsHandlePage.dart';
import 'generalSettingsMusclePage.dart';

class GeneralSettingsPage extends GetView<SettingsController> {
  final SettingsController controller = Get.find();
  final Controller appController = Get.find();

  final mainColor = BBColor.pinky.color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Général'),
        ),
        body: SafeArea(child: Obx(() {
          if (appController.isConnectedToBox == true) {
            return ListView(
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
                              const Text(
                                'Type de capteur',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Précisez le type de capteur utilisé',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ]))),
                const SizedBox(
                  height: 12,
                ),
                const Padding(
                    padding: EdgeInsets.only(left: 16, top: 8),
                    child: const Text(
                      'Capteur utilisé:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
                const Padding(
                    padding: EdgeInsets.only(right: 16, top: 8),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: RadioSensorChoice())),
                const SizedBox(
                  height: 36,
                ),
                Obx(() {
                  if (controller.currentSensor == Sensor.muscle) {
                    return MuscleSettingsView();
                  } else if (controller.currentSensor == Sensor.handle) {
                    return HandleSettingsView();
                  } else {
                    return const SizedBox(height: 0);
                  }
                })
              ],
            );
          } else {
            return ListView(
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
                              const Text(
                                'Mode sans connexion activé',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "S'il n'y a pas de boitier BaahBox connecté, \nvous pouvez quand même jouer!\nFaites glisser votre doigt vers le haut, la gauche ou la droite pour jouer.",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ]))),
                const SizedBox(
                  height: 12,
                ),
              ],
            );
          }
        })));
  }
}



class RadioSensorChoice extends StatefulWidget {
  const RadioSensorChoice({super.key});
  @override
  State<RadioSensorChoice> createState() => _RadioSensorChoiceState();
}

class _RadioSensorChoiceState extends State<RadioSensorChoice> {
  final SettingsController controller = Get.find();
  late Sensor? _selection;
  void onSelectionChanged(Sensor? value) {
    setState(() {
      _selection = value;
      if (value != null) {
        controller.updateSensorTo(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _selection = controller.genericSettings["sensor"];
    return Column(
      children: [
        RadioListTile.adaptive(
            title: const Text('bouton'),
            value: Sensor.button,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('joystick'),
            value: Sensor.digitalJoystick,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('joystick analogique'),
            value: Sensor.analogJoystick,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('muscle'),
            value: Sensor.muscle,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('poignée'),
            value: Sensor.handle,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged)
      ],
    );
  }
}

