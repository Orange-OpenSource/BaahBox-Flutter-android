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

import 'package:baahbox/welcome.dart';
import 'package:baahbox/services/settings/settingsPage.dart';
import 'package:baahbox/services/settings/generalSettingsPage.dart';
import 'package:baahbox/services/settings/spaceShipSettingsPage.dart';
import 'package:baahbox/services/settings/sheepSettingsPage.dart';
import 'package:baahbox/services/settings/toadSettingsPage.dart';
import 'package:baahbox/games/balloon/balloonGamePage.dart';
import 'package:baahbox/games/star/starGamePage.dart';
import 'package:baahbox/services/ble/connectionPage.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:baahbox/games/spaceShip/spaceShipGamePage.dart';
import 'package:baahbox/games/sheep/sheepGamePage.dart';
import 'package:baahbox/games/toad/toadGamePage.dart';

enum BBRoute {
  welcome(path: "/"),
  star(path: "/star"),
  balloon(path: "/balloon"),
  sheep(path: "/sheep"),
  spaceShip(path: "/spaceShip"),
  toad(path: "/toad"),
  testSensors(path: "/testSensors"),
  settings(path: "/settings"),
  connection(path: "/connection"),
  generalSettings(path: "/generalSettings"),
  sheepSettings(path: "/sheepSettings"),
  toadSettings(path: "/toadSettings"),
  spaceShipSettings(path: "/spaceShipSettings");


  const BBRoute({required this.path});
  final String path;
}

class BBRoutes {

  static String getHomePage() => BBRoute.welcome.path;

  static List<GetPage> routes = [
    GetPage(page: () => const WelcomePage(), name: BBRoute.welcome.path),
    GetPage(page: () => const SettingsPage(), name: BBRoute.settings.path),
    GetPage(page: () => GeneralSettingsPage(), name: BBRoute.generalSettings.path),
    GetPage(page: () => SheepSettingsPage(), name: BBRoute.sheepSettings.path),
    GetPage(page: () =>  SpaceShipSettingsPage(), name: BBRoute.spaceShipSettings.path),
    GetPage(page: () =>  ToadSettingsPage(), name: BBRoute.toadSettings.path),
    GetPage(page: () => const ConnectionPage(), name: BBRoute.connection.path),
    GetPage(page: () => BalloonGamePage(), name: BBRoute.balloon.path),
    GetPage(page: () => ToadGamePage(), name: BBRoute.toad.path),
    GetPage(page: () => SheepGamePage(), name: BBRoute.sheep.path),
    GetPage(page: () => SpaceShipGamePage(), name: BBRoute.spaceShip.path),
    GetPage(page: () => StarGamePage(), name: BBRoute.star.path),
  ];
}
