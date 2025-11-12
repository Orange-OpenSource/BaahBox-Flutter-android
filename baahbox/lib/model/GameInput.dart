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

import 'dart:math';

import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/model/sensorInput.dart';
import 'package:flame/components.dart';

import '../controllers/appController.dart';
import '../services/settings/settingsController.dart';
import 'package:get/get.dart';

import 'AnalogicSensor.dart';

class GameInput {
  final SettingsController settingsController = Get.find();

  final GameInputAxes axes;

  GameInputDirectionType get directionType {
    switch (settingsController.genericSettings.sensor) {
      case Sensor.none:
        return GameInputDirectionType.digital;
      case Sensor.muscle:
        return GameInputDirectionType.analogic;
      case Sensor.digitalJoystick:
        return GameInputDirectionType.digital;
      case Sensor.button:
        return GameInputDirectionType.digital;
      case Sensor.analogJoystick:
        return GameInputDirectionType.analogic;
      case Sensor.handle:
        return GameInputDirectionType.analogic;
    }
  }

  final MuscleSettings musclesSettings;
  final HandleSettings handleSettings;

  final Controller appController = Get.find();

  final Vector2 _delta = Vector2.zero();

  GameInput({required this.axes, required this.musclesSettings, required this.handleSettings});

  static const double _eighthOfPi = pi / 8;

  Vector2 get delta {
    switch (settingsController.genericSettings.sensor) {
      case Sensor.none:
        _delta.setValues(0, 0);
      case Sensor.muscle:
        convertMuscleInput();
      case Sensor.digitalJoystick:
        convertArcadeJoystickInput();
      case Sensor.button:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Sensor.analogJoystick:
        convertAnalogJoystickInput();
      case Sensor.handle:
        convertHandleInput();
    }
    return _delta;
  }

  GameInputDirection get direction {
    return convertDeltaToDirection(delta);
  }

  GameInputDirection convertDeltaToDirection(Vector2 currentDelta) {
    if (currentDelta.isZero()) {
      return GameInputDirection.idle;
    }

    var joystickAngle = currentDelta.screenAngle();
    // Since screenAngle and angleTo doesn't care about "direction" of the angle
    // we have to use angleToSigned and create an only increasing angle by
    // removing negative angles from 2*pi.
    joystickAngle = joystickAngle < 0 ? 2 * pi + joystickAngle : joystickAngle;
    if (joystickAngle >= 0 && joystickAngle <= _eighthOfPi) {
      return GameInputDirection.up;
    } else if (joystickAngle > 1 * _eighthOfPi &&
        joystickAngle <= 3 * _eighthOfPi) {
      return GameInputDirection.upRight;
    } else if (joystickAngle > 3 * _eighthOfPi &&
        joystickAngle <= 5 * _eighthOfPi) {
      return GameInputDirection.right;
    } else if (joystickAngle > 5 * _eighthOfPi &&
        joystickAngle <= 7 * _eighthOfPi) {
      return GameInputDirection.downRight;
    } else if (joystickAngle > 7 * _eighthOfPi &&
        joystickAngle <= 9 * _eighthOfPi) {
      return GameInputDirection.down;
    } else if (joystickAngle > 9 * _eighthOfPi &&
        joystickAngle <= 11 * _eighthOfPi) {
      return GameInputDirection.downLeft;
    } else if (joystickAngle > 11 * _eighthOfPi &&
        joystickAngle <= 13 * _eighthOfPi) {
      return GameInputDirection.left;
    } else if (joystickAngle > 13 * _eighthOfPi &&
        joystickAngle <= 15 * _eighthOfPi) {
      return GameInputDirection.upLeft;
    } else if (joystickAngle > 15 * _eighthOfPi) {
      return GameInputDirection.up;
    } else {
      return GameInputDirection.idle;
    }
  }

  void convertArcadeJoystickInput() {
    var joystickInput = appController.digitalInputs;

    if (joystickInput.right) {
      switch (axes) {
        case GameInputAxes.vertical:
          _delta.setValues(0, -1);
        case GameInputAxes.horizontal:
          _delta.setValues(1, 0);
        case GameInputAxes.both:
          _delta.setValues(1, 0);
      }
    } else if (joystickInput.left) {
      switch (axes) {
        case GameInputAxes.vertical:
          _delta.setValues(0, 1);
        case GameInputAxes.horizontal:
          _delta.setValues(-1, 0);
        case GameInputAxes.both:
          _delta.setValues(-1, 0);
      }
    } else if (joystickInput.up) {
      switch (axes) {
        case GameInputAxes.vertical:
          _delta.setValues(1, 0);
        case GameInputAxes.horizontal:
          _delta.setValues(-1, 0);
        case GameInputAxes.both:
          _delta.setValues(-1, 0);
      }
    } else if (joystickInput.down) {
      switch (axes) {
        case GameInputAxes.vertical:
          _delta.setValues(-1, 0);
        case GameInputAxes.horizontal:
          _delta.setValues(1, 0);
        case GameInputAxes.both:
          _delta.setValues(1, 0);
      }
    } else {}
  }

  void convertAnalogJoystickInput() {

    var axeXInput = (settingsController.analogJoystickSettings.sensor1.orientation == AnalogicSensorOrientation.horizontal) ||
        (settingsController.analogJoystickSettings.sensor1.orientation == AnalogicSensorOrientation.horizontalReversed) ?
    appController.analogInputs.analog1: appController.analogInputs.analog2;

    var axeYInput = axeXInput==appController.analogInputs.analog1?
    appController.analogInputs.analog2 : appController.analogInputs.analog1;

    var axeXInputsettings = axeXInput==appController.analogInputs.analog1 ?
    settingsController.analogJoystickSettings.sensor1 : settingsController.analogJoystickSettings.sensor2;

    var axeYInputsettings = axeYInput==appController.analogInputs.analog1?
    settingsController.analogJoystickSettings.sensor1 : settingsController.analogJoystickSettings.sensor2;

    double newXValue = (500 - axeXInput) / 500;
    if(newXValue.abs()<=axeXInputsettings.threshold) {
      newXValue = 0.0;
    }
    if(axeXInputsettings.orientation == AnalogicSensorOrientation.horizontalReversed) {
      newXValue = -1.0 * newXValue;
    }
    double newYValue = (500 - axeYInput) / 500;
    if(newYValue.abs()<axeYInputsettings.threshold) {
      newYValue = 0.0;
    }
    if(axeYInputsettings.orientation == AnalogicSensorOrientation.verticalReversed) {
      newYValue = -1.0 * newYValue;
    }
    switch (axes) {
      case GameInputAxes.horizontal:
        if (directionType == GameInputDirectionType.analogic) {
          _delta.setValues(newXValue, 0);
        } else {
          _delta.setValues(newXValue.abs() >= 0.5 ? newXValue.sign : 0, 0);
        }
      case GameInputAxes.vertical:
        if (directionType == GameInputDirectionType.analogic) {
          _delta.setValues(0, newYValue);
        } else {
          _delta.setValues(newYValue.abs() >= 0.5 ? newYValue.sign : 0, 0);
        }
      case GameInputAxes.both:
        if (directionType == GameInputDirectionType.analogic) {
          _delta.setValues(newXValue, newYValue);
        } else {
          _delta.setValues(newXValue.abs() >= 0.5 ? newXValue.sign : 0,
              newYValue.abs() >= 0.5 ? newYValue.sign : 0);
        }
    }
  }

  void convertOnlyOneMuscleInput(bool isMuscle1) {
    var sensorInput = isMuscle1
        ? appController.analogInputs.analog1
        : appController.analogInputs.analog2;
    var muscleOrientation = isMuscle1
        ? musclesSettings.sensor1.orientation
        : musclesSettings.sensor2.orientation;
    var isCenteredToZero = isMuscle1
        ? musclesSettings.sensor1.isCenteredToZero
        : musclesSettings.sensor2.isCenteredToZero;
    var hasBothAction = musclesSettings.hasBothAction;

    var inputValue = isCenteredToZero
        ? rangeMap(sensorInput, 0, 1000, -500, 500) / 500
        : rangeMap(sensorInput, 0, 1024, 0, 1000) / 1000;
    switch (muscleOrientation) {
      case AnalogicSensorOrientation.vertical:
        {
          if (directionType == GameInputDirectionType.analogic) {
            _delta.setValues(0, inputValue);
          } else {
            _delta.setValues(0, inputValue.abs() >= 0.5 ? inputValue.sign : 0);
          }
        }
      case AnalogicSensorOrientation.verticalReversed:
        {
          inputValue = -1.0 * inputValue;
          if (directionType == GameInputDirectionType.analogic) {
            _delta.setValues(0, inputValue);
          } else {
            _delta.setValues(0, inputValue.abs() >= 0.5 ? inputValue.sign : 0);
          }
        }
      case AnalogicSensorOrientation.horizontal:
        {
          if (directionType == GameInputDirectionType.analogic) {
            _delta.setValues(inputValue, 0);
          } else {
            _delta.setValues(inputValue.abs() >= 0.5 ? inputValue.sign : 0, 0);
          }
        }
      case AnalogicSensorOrientation.horizontalReversed:
        {
          inputValue = -1.0 * inputValue;
          if (directionType == GameInputDirectionType.analogic) {
            _delta.setValues(inputValue, 0);
          } else {
            _delta.setValues(inputValue.abs() >= 0.5 ? inputValue.sign : 0, 0);
          }
        }
      case AnalogicSensorOrientation.none:
        _delta.setValues(0, 0);
    }

    if (hasBothAction) {
      var analog1 =
          rangeMap(appController.analogInputs.analog1, 0, 1024, 0, 1000) / 1000;
      var analog2 =
          rangeMap(appController.analogInputs.analog2, 0, 1024, 0, 1000) / 1000;

      var deltaForAction = Vector2(analog1, analog2);
      var directionForAction = convertDeltaToDirection(deltaForAction);
      if (directionForAction == GameInputDirection.up) {
        _delta.setValues(0, -1);
      }
    }
  }

  void convertBothMusclesInput() {
    var muscle1Orientation = musclesSettings.sensor1.orientation;
    if (axes != GameInputAxes.both) {
      _delta.setValues(0, 0);
    } else {
      var analog1 =
          rangeMap(appController.analogInputs.analog1, 0, 1024, 0, 1000) / 1000;

      var analog2 =
          rangeMap(appController.analogInputs.analog1, 0, 1024, 0, 1000) / 1000;

      switch (muscle1Orientation) {
        case AnalogicSensorOrientation.vertical:
          if (directionType == GameInputDirectionType.analogic) {
            if (analog1 > analog2) {
              _delta.setValues(0, -analog1);
            } else {
              _delta.setValues(0, analog2);
            }
          } else {
            if (analog1 > analog2) {
              _delta.setValues(0, analog1 >= 0.5 ? -1 : 0);
            } else {
              _delta.setValues(0, analog2 >= 0.5 ? 1 : 0);
            }
          }
        case AnalogicSensorOrientation.verticalReversed:
          if (directionType == GameInputDirectionType.analogic) {
            if (analog1 > analog2) {
              _delta.setValues(0, analog1);
            } else {
              _delta.setValues(0, -analog2);
            }
          } else {
            if (analog1 > analog2) {
              _delta.setValues(0, analog1 >= 0.5 ? 1 : 0);
            } else {
              _delta.setValues(0, analog2 >= 0.5 ? -1 : 0);
            }
          }
        case AnalogicSensorOrientation.horizontal:
          if (directionType == GameInputDirectionType.analogic) {
            if (analog1 > analog2) {
              _delta.setValues(-analog1, 0);
            } else {
              _delta.setValues(analog2, 0);
            }
          } else {
            if (analog1 > analog2) {
              _delta.setValues(analog1 >= 0.5 ? -1 : 0, 0);
            } else {
              _delta.setValues(analog2 >= 0.5 ? 1 : 0, 0);
            }
          }
        case AnalogicSensorOrientation.horizontalReversed:
          if (directionType == GameInputDirectionType.analogic) {
            if (analog1 > analog2) {
              _delta.setValues(analog1, 0);
            } else {
              _delta.setValues(-analog2, 0);
            }
          } else {
            if (analog1 > analog2) {
              _delta.setValues(analog1 >= 0.5 ? 1 : 0, 0);
            } else {
              _delta.setValues(analog2 >= 0.5 ? -1 : 0, 0);
            }
          }
        case AnalogicSensorOrientation.none:
          _delta.setValues(0, 0);
      }
    }
  }

  void convertMuscleInput() {
    if (musclesSettings.sensor1.orientation == AnalogicSensorOrientation.none &&
        musclesSettings.sensor2.orientation == AnalogicSensorOrientation.none) {
      // no muscle selected
      _delta.setValues(0, 0);
    } else if (musclesSettings.sensor1.orientation ==
        AnalogicSensorOrientation.none) {
      // Only muscle 2
      convertOnlyOneMuscleInput(false);
    } else if (musclesSettings.sensor2.orientation ==
        AnalogicSensorOrientation.none) {
      // Only muscle1
      convertOnlyOneMuscleInput(true);
    } else if (musclesSettings.sensor1.orientation !=
        musclesSettings.sensor2.orientation) {
      convertBothMusclesInput();
    } else {
      _delta.setValues(0, 0);
    }
  }

  void convertHandleInput() {
    var joystickInput = appController.analogInputs;


    int calibratedInput = calibrateAnalogInput(
        joystickInput.analog1,
        handleSettings.rangeForHandleLower,
        handleSettings.rangeForHandleUpper);

    double analog1 = calibratedInput / 1000;

    if(handleSettings.isCenteredToZero) {
      analog1 = rangeMap(calibratedInput , 0, 1000, -500, 500) / 500;
    }

    switch (axes) {
      case GameInputAxes.horizontal:
      case GameInputAxes.both:
        if (directionType == GameInputDirectionType.analogic) {
          _delta.setValues(analog1, 0);
        } else {
          _delta.setValues(analog1.abs() >= 0.5 ? analog1.sign : 0, 0);
        }
      case GameInputAxes.vertical:

        if (directionType == GameInputDirectionType.analogic) {
          _delta.setValues(0, -1 * analog1);
        } else {
          _delta.setValues(0, analog1.abs() >= 0.5 ? -1 *analog1.sign : 0);
        }
    }
  }
}
