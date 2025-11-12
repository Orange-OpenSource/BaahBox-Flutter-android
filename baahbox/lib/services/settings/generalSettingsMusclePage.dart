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
import 'package:baahbox/services/settings/settingsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:baahbox/services/settings/settingsController.dart';

import '../../model/AnalogicSensor.dart';

class MuscleSettingsView extends GetView<SettingsController> {
  final MuscleSettings muscleSettings;

  MuscleSettingsView({super.key, required this.muscleSettings});
  @override
  Widget build(BuildContext context) {
    Rx<bool> hasMuscle2 =
        (muscleSettings.sensor2.orientation != AnalogicSensorOrientation.none)
            .obs;

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
                          'Muscles utilisés',
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
          const Text(
            'Muscle 1',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          MuscleOrientationSelectionView(muscleSettings: muscleSettings),
          const SizedBox(
            height: 5,
          ),
          Obx(() => SwitchListTile.adaptive(
              title: const Text("Muscle1 centré sur 0"),
              value: muscleSettings.sensor1.isCenteredToZero,
              onChanged: (bool newValue) {
                muscleSettings.sensor1.isCenteredToZero = newValue;
              })),
          const SizedBox(
            height: 5,
          ),
          Obx(() => SwitchListTile.adaptive(
              title: const Text("Utiliser un deuxième muscle"),
              value: hasMuscle2.value,
              onChanged: (bool newValue) {
                hasMuscle2.value = newValue;
                if(!newValue)
                  {
                    muscleSettings.sensor2.orientation = AnalogicSensorOrientation.none;
                  }
              })),
          const SizedBox(
            height: 5,
          ),
          Obx(
            () {
              if (hasMuscle2.value) {
                return Text(
                  'Muscle 2',
                  style: TextStyle(
                      fontSize: 12,
                      color: hasMuscle2.value
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.outline),
                );
              } else {
                return SizedBox(
                  height: 0,
                );
              }
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Obx(() {
            if (hasMuscle2.value) {
              return Muscle2OrientationSelectionView(
                  muscleSettings: muscleSettings);
            } else {
              return const SizedBox(
                height: 5,
              );
            }
          }),
          const SizedBox(
            height: 5,
          ),
          Obx(() {
            if (hasMuscle2.value) {
              return SwitchListTile.adaptive(
                  title: const Text("Muscle2 centré sur 0"),
                  value: muscleSettings.sensor2.isCenteredToZero,
                  onChanged: (bool newValue) {
                    muscleSettings.sensor2.isCenteredToZero = newValue;
                  });
            } else {
              return const SizedBox(
                height: 5,
              );
            }
          })
        ]));
  }
}

class MuscleOrientationSelectionView extends StatefulWidget {
  const MuscleOrientationSelectionView(
      {super.key, required this.muscleSettings});
  final MuscleSettings muscleSettings;
  @override
  State<MuscleOrientationSelectionView> createState() =>
      _MuscleOrientationSelectionViewState();
}

class _MuscleOrientationSelectionViewState
    extends State<MuscleOrientationSelectionView> {
  late AnalogicSensorOrientation? _selection;
  void onSelectionChanged(AnalogicSensorOrientation? value) {
    setState(() {
      _selection = value;
      if (value != null) {
        widget.muscleSettings.sensor1.orientation = value;
        if (widget.muscleSettings.sensor2.orientation !=
            AnalogicSensorOrientation.none) {
          widget.muscleSettings.sensor1.isCenteredToZero = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _selection = widget.muscleSettings.sensor1.orientation;

    return Column(
      children: <Widget>[
        RadioListTile.adaptive(
            title: const Text('Vertical'),
            value: AnalogicSensorOrientation.vertical,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('Horizontal'),
            value: AnalogicSensorOrientation.horizontal,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('Vertical inversé'),
            value: AnalogicSensorOrientation.verticalReversed,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('Horizontal inversé'),
            value: AnalogicSensorOrientation.horizontalReversed,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged),
        RadioListTile.adaptive(
            title: const Text('Non sélectionné'),
            value: AnalogicSensorOrientation.none,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged)
      ],
    );
  }
}

class Muscle2OrientationSelectionView extends StatefulWidget {
  const Muscle2OrientationSelectionView(
      {super.key, required this.muscleSettings});
  final MuscleSettings muscleSettings;
  @override
  State<Muscle2OrientationSelectionView> createState() =>
      _Muscle2OrientationSelectionViewState();
}

class _Muscle2OrientationSelectionViewState
    extends State<Muscle2OrientationSelectionView> {
  late AnalogicSensorOrientation? _selection;
  void onSelectionChanged(AnalogicSensorOrientation? value) {
    setState(() {
      _selection = value;
      if (value != null) {
        widget.muscleSettings.sensor2.orientation = value;
        if (widget.muscleSettings.sensor1.orientation !=
            AnalogicSensorOrientation.none) {
          widget.muscleSettings.sensor2.isCenteredToZero = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _selection = widget.muscleSettings.sensor2.orientation;
    return Column(
      children: <Widget>[
        Obx(() => RadioListTile.adaptive(
            title: const Text('Vertical'),
            value: AnalogicSensorOrientation.vertical,
            groupValue: _selection,
            toggleable: true,
            onChanged: widget.muscleSettings.sensor1.orientation ==
                        AnalogicSensorOrientation.vertical ||
                    widget.muscleSettings.sensor1.orientation ==
                        AnalogicSensorOrientation.verticalReversed
                ? null
                : onSelectionChanged)),
        Obx(() => RadioListTile.adaptive(
            title: const Text('Horizontal'),
            value: AnalogicSensorOrientation.horizontal,
            groupValue: _selection,
            toggleable: true,
            onChanged: widget.muscleSettings.sensor1.orientation ==
                        AnalogicSensorOrientation.horizontal ||
                    widget.muscleSettings.sensor1.orientation ==
                        AnalogicSensorOrientation.horizontalReversed
                ? null
                : onSelectionChanged)),
        Obx(() => RadioListTile.adaptive(
            title: const Text('Vertical inversé'),
            value: AnalogicSensorOrientation.verticalReversed,
            groupValue: _selection,
            toggleable: true,
            onChanged: widget.muscleSettings.sensor1.orientation ==
                        AnalogicSensorOrientation.vertical ||
                    widget.muscleSettings.sensor1.orientation ==
                        AnalogicSensorOrientation.verticalReversed
                ? null
                : onSelectionChanged)),
        Obx(() => RadioListTile.adaptive(
            title: const Text('Horizontal inversé'),
            value: AnalogicSensorOrientation.horizontalReversed,
            groupValue: _selection,
            toggleable: true,
            onChanged: widget.muscleSettings.sensor1.orientation ==
                        AnalogicSensorOrientation.horizontal ||
                    widget.muscleSettings.sensor1.orientation ==
                        AnalogicSensorOrientation.horizontalReversed
                ? null
                : onSelectionChanged)),
        RadioListTile.adaptive(
            title: const Text('Non sélectionné'),
            value: AnalogicSensorOrientation.none,
            groupValue: _selection,
            toggleable: true,
            onChanged: onSelectionChanged)
      ],
    );
  }
}
