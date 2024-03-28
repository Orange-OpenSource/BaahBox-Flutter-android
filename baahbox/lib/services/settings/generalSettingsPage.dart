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
import 'package:baahbox/routes/routes.dart';
import 'package:baahbox/services/settings/settingsController.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

class GeneralSettingsPage extends GetView<SettingsController> {
  final SettingsController controller = Get.find();
  final mainColor = BBColor.pinky.color;
  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Général'),
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
                        const Text(
                          'Mode',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Sélectionnez le mode d\'utilisation',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ]))),
          const SizedBox(
            height: 15,
          ),
          const SwitchExample(title: "Mode démo:"),
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
                  child: SensorSegmentedSegment())),
          const SizedBox(
            height: 36,
          ),
          Card(
              shape: ContinuousRectangleBorder(),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Muscle utilisé',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Sélectionnez le ou les muscles à travailler',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          ListTile(
              title: Text("Muscle1"),
              trailing: Obx(() => Switch(
                value: controller.genericSettings["isSensor1On"],
                activeColor: Colors.red,
                onChanged: (bool val) {
                  controller.setMuscle1To(val);
                },
              ))),
          const SizedBox(
            height: 5,
          ),
          ListTile(
          title: Text("Muscle2"),
          trailing: Obx(() => Switch(
          value: controller.genericSettings["isSensor2On"],
          activeColor: Colors.red,
          onChanged: (bool val) {
            controller.setMuscle2To(val);
          },
          ))),
          Card(
              shape: ContinuousRectangleBorder(),
    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sensibilité',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Paramétrez la sensibilité des capteurs',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ]))),
          const SizedBox(
            height: 8,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: const Text(
                'Sensibilité',
                style: TextStyle(
                  fontSize: 16,
                ),
              )),
          const Padding(
              padding: EdgeInsets.only(right: 16, top: 8),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: SensitivitySegmentedSegment())),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

class SensitivitySegmentedSegment extends StatefulWidget {
  const SensitivitySegmentedSegment({super.key});

  @override
  State<SensitivitySegmentedSegment> createState() =>
      _SensitivitySegmentedSegmentState();
}

class _SensitivitySegmentedSegmentState
    extends State<SensitivitySegmentedSegment> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomSlidingSegmentedControl<Sensitivity>(
      initialValue: Sensitivity.medium,
      children: {
        Sensitivity.low: Text('Faible'),
        Sensitivity.medium: Text('Moyenne'),
        Sensitivity.high: Text('Elevée'),
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
      onValueChanged: (sensitivity) {
        controller.updateSensitivityTo(sensitivity);
      },
    );
  }
}

class SensorSegmentedSegment extends StatefulWidget {
  const SensorSegmentedSegment({super.key});

  @override
  State<SensorSegmentedSegment> createState() => _SensorSegmentedSegmentState();
}

class _SensorSegmentedSegmentState extends State<SensorSegmentedSegment> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final sensorType = (controller.genericSettings["sensor"] as SensorType);
    var displayValue = sensorType;
    return CustomSlidingSegmentedControl<SensorType>(
      initialValue: sensorType,
      children: {
        SensorType.muscle: Text('Muscle'),
        SensorType.arcadeJoystick: Text('Joystick'),
        SensorType.button: Text('Button'),
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
      onValueChanged: (v) {
        print(v);
        controller.updateSensorTypeTo(v);
      },
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
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("button"),
          leading: Radio(
            groupValue: _value,
            value: 1,
            onChanged: (int? value) {
              setState(() {
                _value = value ?? 0;
                controller.setNumberOfGatesTo(value);
              });
            },
          ),
        ),
        ListTile(
          title: Text("joystick"),
          leading: Radio(
            groupValue: _value,
            value: 2,
            onChanged: (int? value) {
              setState(() {
                _value = value ?? 0;
                controller.setNumberOfGatesTo(value);
              });
            },
          ),
        ),
        ListTile(
          title: Text("muscle"),
          leading: Radio(
            groupValue: _value,
            value: 3,
            onChanged: (int? value) {
              setState(() {
                _value = value ?? 0;
                controller.setNumberOfGatesTo(value);
              });
            },
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
    return Slider(
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
        trailing: Switch(
          // This bool value toggles the switch.
          value: light,
          activeColor: Colors.red,
          onChanged: (bool value) {
            // This is called when the user toggles the switch.
            setState(() {
              light = value;
            });
          },
        ));
  }
}
