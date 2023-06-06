//import 'package:get/get.dart';
import 'package:baahbox/welcome.dart';
import 'package:baahbox/settings.dart';
import 'package:baahbox/games/balloon/balloonGameScene.dart';
import 'package:baahbox/games/star/starGameScene.dart';
import 'package:baahbox/games/testGame.dart';
import 'package:baahbox/games/dino/dinoGameScene.dart';
import 'package:baahbox/services/bleConnectionPage.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';


 class BBRoutes {
  static const String welcome = "/";
  static const String star = "/star";
  static const String balloon = "/balloon";
  static String sheep = "/sheep";
  static String spaceShip = "/spaceShip";
  static String toad = "/toad";
  static String dino = "/dino";
  static String testSensors = "/testSensors";
  static const String settings = "/settings";
  static const String connection = "/connection";
  static String generalSettings = "/generalSettings";
  static String sheepSettings = "/sheepSettings";
  static String toadSettings = "/toadSettings";
  static String spaceShipSettings = "/spaceShipSettings";

  static String getHomePage() => welcome;

  static List<GetPage> routes = [
    GetPage(page: () => const WelcomePage(), name: welcome),
    GetPage(page: () => const SettingsPage(), name: settings),
    GetPage(page: () => const BleConnectionPage(), name: connection),
    GetPage(page: () =>  BalloonGameScene(), name: balloon),
    GetPage(page: () =>  TestGamePage(), name: testSensors),
    GetPage(page: () =>  DinoGameScene(), name: dino),
    GetPage(page: () =>  DinoGameScene(), name: toad),
    GetPage(page: () =>  DinoGameScene(), name: sheep),
    GetPage(page: () =>  DinoGameScene(), name: spaceShip),
    GetPage(page: () =>  DinoGameScene(), name: star),
  ];
}