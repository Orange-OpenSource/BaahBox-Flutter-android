//import 'package:get/get.dart';
import 'package:baahbox/welcome.dart';
import 'package:baahbox/settings.dart';
import 'package:baahbox/games/balloon/balloonGameScene.dart';
import 'package:baahbox/games/star/starGameScene.dart';
import 'package:baahbox/games/testGame.dart';
import 'package:baahbox/games/dino/dinoGameScene.dart';
import 'package:baahbox/services/bleConnectionPage.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

enum BBRoute {
  welcome(path: "/"),
  star(path: "/star"),
  balloon(path: "/balloon"),
  sheep(path: "/sheep"),
  spaceShip(path: "/spaceShip"),
  toad(path: "/toad"),
  dino(path: "/dino"),
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
    GetPage(page: () => const BleConnectionPage(), name: BBRoute.connection.path),
    GetPage(page: () => BalloonGameScene(), name: BBRoute.balloon.path),
    GetPage(page: () => TestGamePage(), name: BBRoute.testSensors.path),
    GetPage(page: () => DinoGameScene(), name: BBRoute.dino.path),
    GetPage(page: () => DinoGameScene(), name: BBRoute.toad.path),
    GetPage(page: () => DinoGameScene(), name: BBRoute.sheep.path),
    GetPage(page: () => DinoGameScene(), name: BBRoute.spaceShip.path),
    GetPage(page: () => StarGameScene(), name: BBRoute.star.path),
  ];
}
