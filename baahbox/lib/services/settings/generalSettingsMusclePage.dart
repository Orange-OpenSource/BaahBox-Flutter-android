import 'package:baahbox/services/settings/settingsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:baahbox/services/settings/settingsController.dart';

class MuscleSettingsView extends GetView<SettingsController> {
  final MuscleSettings muscleSettings;

  MuscleSettingsView({super.key, required this.muscleSettings});
  @override
  Widget build(BuildContext context) {
    Rx<bool> hasMuscle2 =
        (muscleSettings.sensor2Orientation != AnalogicSensorOrientation.none)
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
              value: muscleSettings.isMuscle1CenteredToZero,
              onChanged: (bool newValue) {
                muscleSettings.isMuscle1CenteredToZero = newValue;
              })),
          const SizedBox(
            height: 5,
          ),
          Obx(() => SwitchListTile.adaptive(
              title: const Text("Utiliser un deuxième muscle"),
              value: hasMuscle2.value,
              onChanged: (bool newValue) {
                hasMuscle2.value = newValue;
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
                  value: muscleSettings.isMuscle2CenteredToZero,
                  onChanged: (bool newValue) {
                    muscleSettings.isMuscle2CenteredToZero = newValue;
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
        widget.muscleSettings.sensor1Orientation = value;
        if (widget.muscleSettings.sensor2Orientation !=
            AnalogicSensorOrientation.none) {
          widget.muscleSettings.isMuscle1CenteredToZero = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _selection = widget.muscleSettings.sensor1Orientation;

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
        widget.muscleSettings.sensor2Orientation = value;
        if (widget.muscleSettings.sensor1Orientation !=
            AnalogicSensorOrientation.none) {
          widget.muscleSettings.isMuscle2CenteredToZero = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _selection = widget.muscleSettings.sensor2Orientation;
    return Column(
      children: <Widget>[
        Obx(() => RadioListTile.adaptive(
            title: const Text('Vertical'),
            value: AnalogicSensorOrientation.vertical,
            groupValue: _selection,
            toggleable: true,
            onChanged: widget.muscleSettings.sensor1Orientation ==
                        AnalogicSensorOrientation.vertical ||
                    widget.muscleSettings.sensor1Orientation ==
                        AnalogicSensorOrientation.verticalReversed
                ? null
                : onSelectionChanged)),
        Obx(() => RadioListTile.adaptive(
            title: const Text('Horizontal'),
            value: AnalogicSensorOrientation.horizontal,
            groupValue: _selection,
            toggleable: true,
            onChanged: widget.muscleSettings.sensor1Orientation ==
                        AnalogicSensorOrientation.horizontal ||
                    widget.muscleSettings.sensor1Orientation ==
                        AnalogicSensorOrientation.horizontalReversed
                ? null
                : onSelectionChanged)),
        Obx(() => RadioListTile.adaptive(
            title: const Text('Vertical inversé'),
            value: AnalogicSensorOrientation.verticalReversed,
            groupValue: _selection,
            toggleable: true,
            onChanged: widget.muscleSettings.sensor1Orientation ==
                        AnalogicSensorOrientation.vertical ||
                    widget.muscleSettings.sensor1Orientation ==
                        AnalogicSensorOrientation.verticalReversed
                ? null
                : onSelectionChanged)),
        Obx(() => RadioListTile.adaptive(
            title: const Text('Horizontal inversé'),
            value: AnalogicSensorOrientation.horizontalReversed,
            groupValue: _selection,
            toggleable: true,
            onChanged: widget.muscleSettings.sensor1Orientation ==
                        AnalogicSensorOrientation.horizontal ||
                    widget.muscleSettings.sensor1Orientation ==
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
