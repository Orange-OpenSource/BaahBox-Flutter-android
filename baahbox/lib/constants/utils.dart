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

import 'package:flutter/foundation.dart';

void debugLog(String message) {
  if (kDebugMode) {
    print(message);
  }
}


String prettyDuration(double durationInSec) {
  var components = <String>[];

  int seconds = durationInSec ~/ 1;
  int minutes = seconds ~/ 60;
  int hours = minutes ~/ 60;
  int days = hours ~/ 24;

  seconds %= 60;
  minutes %= 60;
  hours %= 24;

  if (days != 0) {
    components.add('${days}d');
  }
  if (hours != 0) {
    components.add('${hours}h');
  }

  if (minutes != 0) {
    components.add('${minutes}m');
  }

  components.add('$seconds');
  components.add('s');

  return components.join();
}
