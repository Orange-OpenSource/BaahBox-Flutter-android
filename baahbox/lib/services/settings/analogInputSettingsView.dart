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
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../model/AnalogicSensor.dart';

class AnalogInputSettingsView extends StatefulWidget {
  const AnalogInputSettingsView(
      {super.key, required this.analogSensorSettings});
  final AnalogicSensorSettings analogSensorSettings;
  @override
  State<AnalogInputSettingsView> createState() =>
      _AnalogInputSettingsViewState();
}

class _AnalogInputSettingsViewState extends State<AnalogInputSettingsView> {
  late AnalogicSensorOrientation? _selection;
  void onSelectionChanged(AnalogicSensorOrientation? value) {
    setState(() {
      _selection = value;
      if (value != null) {
        widget.analogSensorSettings.orientation = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _selection = widget.analogSensorSettings.orientation;

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
        const SizedBox(
          height: 5,
        ),
        Obx(() => SwitchListTile.adaptive(
            title: const Text("Axe centré sur 0"),
            value: widget.analogSensorSettings.isCenteredToZero,
            onChanged: (bool newValue) {
              widget.analogSensorSettings.isCenteredToZero = newValue;
            })),
        Obx(() => Text(
              "Seuil de sensibilité: ${widget.analogSensorSettings.threshold.toString()}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          height: 12,
        ),
        AnalogInputThresholdSlider(
            analogSensorSettings: widget.analogSensorSettings)
      ],
    );
  }
}

class AnalogInputSettingsSlaveView extends StatefulWidget {
  const AnalogInputSettingsSlaveView(
      {super.key,
      required this.analogSensorSettings,
      required this.primaryAnalogSensorSettings});
  final AnalogicSensorSettings analogSensorSettings;
  final AnalogicSensorSettings primaryAnalogSensorSettings;
  @override
  State<AnalogInputSettingsSlaveView> createState() =>
      _AnalogInputSettingsViewSlaveState();
}

class _AnalogInputSettingsViewSlaveState
    extends State<AnalogInputSettingsSlaveView> {
  late AnalogicSensorOrientation? _selection;
  void onSelectionChanged(AnalogicSensorOrientation? value) {
    setState(() {
      _selection = value;
      if (value != null) {
        widget.analogSensorSettings.orientation = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _selection = widget.analogSensorSettings.orientation;
    Rx<bool> isPrimarySensorIsVertical =
        (widget.primaryAnalogSensorSettings.orientation ==
                    AnalogicSensorOrientation.vertical ||
                widget.primaryAnalogSensorSettings.orientation ==
                    AnalogicSensorOrientation.verticalReversed)
            .obs;
    return Column(
      children: <Widget>[
        Obx(() => RadioListTile.adaptive(
            title: const Text('Vertical'),
            value: AnalogicSensorOrientation.vertical,
            groupValue: _selection,
            toggleable: !(widget.primaryAnalogSensorSettings.orientation ==
                    AnalogicSensorOrientation.vertical ||
                widget.primaryAnalogSensorSettings.orientation ==
                    AnalogicSensorOrientation.verticalReversed),
            onChanged: widget.primaryAnalogSensorSettings.orientation ==
                        AnalogicSensorOrientation.vertical ||
                    widget.primaryAnalogSensorSettings.orientation ==
                        AnalogicSensorOrientation.verticalReversed
                ? null
                : onSelectionChanged)),
        Obx(() => RadioListTile.adaptive(
            title: const Text('Horizontal'),
            value: AnalogicSensorOrientation.horizontal,
            groupValue: _selection,
            toggleable: widget.primaryAnalogSensorSettings.orientation ==
                    AnalogicSensorOrientation.vertical ||
                widget.primaryAnalogSensorSettings.orientation ==
                    AnalogicSensorOrientation.verticalReversed,
            onChanged: !(widget.primaryAnalogSensorSettings.orientation ==
                        AnalogicSensorOrientation.vertical ||
                    widget.primaryAnalogSensorSettings.orientation ==
                        AnalogicSensorOrientation.verticalReversed)
                ? null
                : onSelectionChanged)),
        Obx(() => RadioListTile.adaptive(
            title: const Text('Vertical inversé'),
            value: AnalogicSensorOrientation.verticalReversed,
            groupValue: _selection,
            toggleable: !(widget.primaryAnalogSensorSettings.orientation ==
                    AnalogicSensorOrientation.vertical ||
                widget.primaryAnalogSensorSettings.orientation ==
                    AnalogicSensorOrientation.verticalReversed),
            onChanged: widget.primaryAnalogSensorSettings.orientation ==
                        AnalogicSensorOrientation.vertical ||
                    widget.primaryAnalogSensorSettings.orientation ==
                        AnalogicSensorOrientation.verticalReversed
                ? null
                : onSelectionChanged)),
        Obx(() => RadioListTile.adaptive(
            title: const Text('Horizontal inversé'),
            value: AnalogicSensorOrientation.horizontalReversed,
            groupValue: _selection,
            toggleable: widget.primaryAnalogSensorSettings.orientation ==
                    AnalogicSensorOrientation.vertical ||
                widget.primaryAnalogSensorSettings.orientation ==
                    AnalogicSensorOrientation.verticalReversed,
            onChanged: !(widget.primaryAnalogSensorSettings.orientation ==
                        AnalogicSensorOrientation.vertical ||
                    widget.primaryAnalogSensorSettings.orientation ==
                        AnalogicSensorOrientation.verticalReversed)
                ? null
                : onSelectionChanged)),
        const SizedBox(
          height: 5,
        ),
        Obx(() => SwitchListTile.adaptive(
            title: const Text("Axe centré sur 0"),
            value: widget.analogSensorSettings.isCenteredToZero,
            onChanged: (bool newValue) {
              widget.analogSensorSettings.isCenteredToZero = newValue;
            })),
        Obx(() => Text(
              "Seuil de sensibilité: ${widget.analogSensorSettings.threshold.toString()}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          height: 12,
        ),
        AnalogInputThresholdSlider(
            analogSensorSettings: widget.analogSensorSettings)
      ],
    );
  }
}

class AnalogInputThresholdSlider extends StatefulWidget {
  const AnalogInputThresholdSlider(
      {super.key, required this.analogSensorSettings});
  final AnalogicSensorSettings analogSensorSettings;

  @override
  State<AnalogInputThresholdSlider> createState() =>
      _AnalogInputThresholdSliderState();
}

class _AnalogInputThresholdSliderState
    extends State<AnalogInputThresholdSlider> {
  @override
  Widget build(BuildContext context) {
    return Slider.adaptive(
      value: widget.analogSensorSettings.threshold,
      min: 0.0,
      max: 0.5,
      divisions: 5,
      label: widget.analogSensorSettings.threshold.toString(),
      semanticFormatterCallback: (double newValue) {
        return newValue.toString();
      },
      onChanged: (double value) {
        setState(() {
          widget.analogSensorSettings.threshold = value;
        });
      },
    );
  }
}
