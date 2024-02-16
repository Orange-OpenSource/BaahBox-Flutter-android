import 'package:baahbox/welcome.dart';
import 'package:baahbox/services/settings/settingsPage.dart';
import 'package:baahbox/services/settings/generalSettingsPage.dart';
import 'package:baahbox/services/settings/spaceShipSettingsPage.dart';
import 'package:baahbox/services/settings/sheepSettingsPage.dart';
import 'package:baahbox/services/settings/toadSettingsPage.dart';
import 'package:baahbox/games/balloon/balloonGamePage.dart';
import 'package:baahbox/games/star/starGamePage.dart';
import 'package:baahbox/games/testGamePage.dart';
import 'package:baahbox/games/dino/dinoGamePage.dart';
import 'package:baahbox/games/trex/trexGamePage.dart';
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
  dino(path: "/dino"),
  trex(path: "/trex"),
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
    GetPage(page: () => TestGamePage(), name: BBRoute.testSensors.path),
    GetPage(page: () => DinoGamePage(), name: BBRoute.dino.path),
    GetPage(page: () => ToadGamePage(), name: BBRoute.toad.path),
    GetPage(page: () => SheepGamePage(), name: BBRoute.sheep.path),
    GetPage(page: () => SpaceShipGamePage(), name: BBRoute.spaceShip.path),
    GetPage(page: () => StarGamePage(), name: BBRoute.star.path),
  ];
}
