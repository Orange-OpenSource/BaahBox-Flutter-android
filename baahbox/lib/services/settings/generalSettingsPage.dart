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
        body: SafeArea(
            child: appController.isConnectedToBox
                ? ListView(
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
                        if (controller.genericSettings.sensor ==
                            Sensor.muscle) {
                          return MuscleSettingsView(
                              muscleSettings: controller.musclesSettings);
                        } else if (controller.genericSettings.sensor ==
                            Sensor.handle) {
                          return HandleSettingsView();
                        } else {
                          return const SizedBox(height: 0);
                        }
                      })
                    ],
                  )
                : ListView(
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
                  )));
  }
}

class SensitivitySelectionView extends StatefulWidget {
  const SensitivitySelectionView({super.key});

  @override
  State<SensitivitySelectionView> createState() =>
      _SensitivitySelectionViewState();
}

class _SensitivitySelectionViewState extends State<SensitivitySelectionView> {
  final SettingsController controller = Get.find();
  late Sensitivity? _selection;
  void onSelectionChanged(Sensitivity? value) {
    setState(() {
      _selection = value;
      if (value != null) {
        controller.genericSettings.sensitivity = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _selection = Sensitivity.medium;
    return Column(
      children: <Widget>[
        RadioListTile.adaptive(
            title: const Text('Faible'),
            value: Sensitivity.low,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('Moyenne'),
            value: Sensitivity.medium,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('Elevée'),
            value: Sensitivity.high,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
      ],
    );
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
        controller.genericSettings.sensor = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _selection = controller.genericSettings.sensor;
    return Column(
      children: [
        ListTile(
          title: Text("button"),
          leading: Radio.adaptive(
            groupValue: _selection,
            value: Sensor.button,
            onChanged: onSelectionChanged,
          ),
        ),
        ListTile(
          title: Text("joystick digital"),
          leading: Radio.adaptive(
            groupValue: _selection,
            value: Sensor.digitalJoystick,
            onChanged: onSelectionChanged,
          ),
        ),
        ListTile(
          title: Text("joystick analogique"),
          leading: Radio.adaptive(
            groupValue: _selection,
            value: Sensor.analogJoystick,
            onChanged: onSelectionChanged,
          ),
        ),
        ListTile(
          title: Text("muscle"),
          leading: Radio.adaptive(
            groupValue: _selection,
            value: Sensor.muscle,
            onChanged: onSelectionChanged,
          ),
        ),
        ListTile(
          title: Text("poignée"),
          leading: Radio.adaptive(
            groupValue: _selection,
            value: Sensor.handle,
            onChanged: onSelectionChanged,
          ),
        ),
      ],
    );
  }
}

class SliderExample extends StatefulWidget {
  const SliderExample({super.key});

  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Slider.adaptive(
      value: _currentSliderValue,
      max: 100,
      divisions: 5,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key, required this.title});
  final String title;

  @override
  State<SwitchExample> createState() => _SwitchExampleState(title: title);
}

class _SwitchExampleState extends State<SwitchExample> {
  _SwitchExampleState({required this.title});
  bool light = true;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        trailing: Switch.adaptive(
          // This bool value toggles the switch.
          value: light,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (bool value) {
            // This is called when the user toggles the switch.
            setState(() {
              light = value;
            });
          },
        ));
  }
}
