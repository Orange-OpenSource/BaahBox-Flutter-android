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
import 'analogInputSettingsView.dart';

class AnalogicJoystickInputSettingsView extends StatefulWidget {
  const AnalogicJoystickInputSettingsView(
      {super.key, required this.analogJoystickSettings});
  final AnalogicChannelsSettings analogJoystickSettings;
  @override
  State<AnalogicJoystickInputSettingsView> createState() =>
      _AnalogicJoystickInputSettingsViewState();
}

class _AnalogicJoystickInputSettingsViewState
    extends State<AnalogicJoystickInputSettingsView> {


  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        const Text(
          "Orientation de l'axe 1",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        AnalogInputSettingsView(analogSensorSettings:widget.analogJoystickSettings.sensor1),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "Orientation de l'axe 2",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        AnalogInputSettingsSlaveView(analogSensorSettings:widget.analogJoystickSettings.sensor2,
            primaryAnalogSensorSettings:widget.analogJoystickSettings.sensor1)
      ],
    );
  }
}
