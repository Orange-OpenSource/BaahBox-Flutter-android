/*
 * Baah Box
 * Copyright (c) 2024-2025. Orange SA
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

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AnalogicSensorOrientation {
  vertical,
  verticalReversed,
  horizontal,
  horizontalReversed,
  none;
}

class AnalogicSensorSettings {
  late final SharedPreferences prefs;
  late final String prefsPrefix;

  AnalogicSensorSettings({required this.prefs, required this.prefsPrefix}) {
    _orientation = (AnalogicSensorOrientation.values
        .byName(prefs.getString('${prefsPrefix}_orientation') ?? AnalogicSensorOrientation.vertical.name))
        .obs;

    _isCenteredToZero = (prefs.getBool('${prefsPrefix}_isCenteredToZero') ?? false).obs;
  }
  late Rx<AnalogicSensorOrientation> _orientation = AnalogicSensorOrientation.vertical.obs;

  AnalogicSensorOrientation get orientation => _orientation.value;
  set orientation(AnalogicSensorOrientation orientation) {
    _orientation.value = orientation;
    prefs.setString('${prefsPrefix}_orientation', orientation.name);
  }

  late RxBool _isCenteredToZero;
  bool get isCenteredToZero => _isCenteredToZero.value;
  set isCenteredToZero(bool val) {
    _isCenteredToZero.value = val;
    prefs.setBool('${prefsPrefix}_isCenteredToZero', val);
  }
}

class AnalogicChannelsSettings {
  late final SharedPreferences prefs;
  late final String prefsPrefix;

  AnalogicChannelsSettings({required this.prefs, required this.prefsPrefix}) {
    sensor1 = AnalogicSensorSettings(prefs: prefs, prefsPrefix: prefsPrefix);
    sensor2 = AnalogicSensorSettings(prefs: prefs, prefsPrefix: prefsPrefix);
  }
  late final AnalogicSensorSettings sensor1;
  late final AnalogicSensorSettings sensor2;
}
