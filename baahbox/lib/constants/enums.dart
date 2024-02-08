import 'dart:ui';

enum objectVelocity {
  low(value: .5),
  medium(value: 1),
  high(value: 2);

  const objectVelocity({required this.value});
  final double value;
}

enum Sensitivity {
  low,
  medium,
  high;
}

enum ShootingType {
  automatic,
  manual;
}

enum SensorType {
  muscle,
  arcadeJoystick,
  button,
  digitalJoystick,
  wheelChairJoystick;
}

enum BBColor implements Comparable<BBColor> {
  beurkGreen(sRGB: 0xFFCEAF17),
  blueGreen(sRGB: 0xFF085559),
  greenDash(sRGB: 0xFF3A9B8D),
  greyGreen(sRGB: 0xFF86A2A3),
  lightGreen(sRGB: 0xFFA2CC81),
  orange(sRGB: 0xFFE26F3B),
  pinky(sRGB: 0xFFF98885),
  violet(sRGB: 0xFF70576E);

  const BBColor({required this.sRGB});
  final int sRGB;
  Color get color => Color(this.sRGB) as Color;

  @override
  int compareTo(BBColor other) => sRGB - other.sRGB;
}

enum GameState {
  // notStarted,
  // onGoing,
  // halted,
  // ended;
  initializing,
  ready,
  running,
  paused,
  won,
  lost;
}

enum BBGameList {
  star(
      title: 'Star',
      mainAsset: 'assets/images/Dashboard/menu_etoile@2x.png',
      baseColor: BBColor.violet,
      numberOfSensors: 1),
  balloon(
      title: 'Balloon',
      mainAsset: 'assets/images/Dashboard/menu_ballon@2x.png',
      baseColor: BBColor.orange,
      numberOfSensors: 1),
  sheep(
    title: 'Sheep',
    mainAsset: 'assets/images/Dashboard/menu_mouton@2x.png',
    baseColor: BBColor.pinky,
    numberOfSensors: 1,
  ),
  starship(
    title: 'StarShip',
    mainAsset: 'assets/images/Dashboard/menu_espace@2x.png',
    baseColor: BBColor.blueGreen,
    numberOfSensors: 2,
  ),
  toad(
    title: 'toad',
    mainAsset: 'assets/images/Dashboard/menu_gobe@2x.png',
    baseColor: BBColor.greyGreen,
    numberOfSensors: 2,
  );

  const BBGameList({
    required this.title,
    required this.mainAsset,
    required this.baseColor,
    required this.numberOfSensors,
  });

  final String title;
  final String mainAsset;
  final BBColor baseColor;
  final int numberOfSensors;
}
