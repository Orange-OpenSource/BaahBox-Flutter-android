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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/services/settings/settingsController.dart';

class Maze3dSettingsPage extends GetView<SettingsController> {
  final mainColor = BBGameList.maze.baseColor.color;
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Réglages du labyrinthe 3D", maxLines: 1),
        actions: [
          IconButton(
              icon: Image.asset(
                  'assets/images/Dashboard/settings_icon.png',
                  width: 25, height: 25,
                  color: mainColor),
              onPressed: () => Get.toNamed('/settings')),
        ],
      ),
      body: SafeArea(
    child:ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 32, top: 8),
          ),
          Card(
              shape: ContinuousRectangleBorder(),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Taille du labyrinthe : ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),

          Obx(() => Text(
            "Nombre de cases : ${controller.maze3dSettings.mazeSize}",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)
          )),
          const SizedBox(
            height: 12,
          ),
          Maze3dSizeSlider(),
          const SizedBox(
            height: 12,
          ),
          Card(
              shape: ContinuousRectangleBorder(),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Temps de jeu : ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          Obx(() => SwitchListTile.adaptive(
              title: Text("Rétroviseur"),
              value: controller.maze3dSettings.hasBackView,
              onChanged: (bool newValue) {
                controller.maze3dSettings.hasBackView = newValue;
              })),
          const SizedBox(
            height: 12,
          ),
          Obx(() => SwitchListTile.adaptive(
              title: Text("Mode chronomètré"),
              value: controller.maze3dSettings.hasChrono,
              onChanged: (bool newValue) {
                controller.maze3dSettings.hasChrono = newValue;
              })),
          const SizedBox(
            height: 12,
          ),
          Obx(() => Text(
            "Temps maximum pour sortir : ${controller.maze3dSettings.chronoMaxTime} secondes",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold,
                color:controller.maze3dSettings.hasChrono ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.outline),

          )),
          const SizedBox(
            height: 12,
          ),
          Maze3dChronoDurationSlider(),

          const SizedBox(
            height: 12,
          ),
          Obx(() => Text(
            "Vitesse de déplacement : ${controller.maze3dSettings.speedMovement}",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),

          )),
          const SizedBox(
            height: 12,
          ),
          Maze3dSpeedSlider(),
          const SizedBox(
            height: 12,
          ),
          Obx(() => Text(
            "Champ de vision (en degrés): ${(controller.maze3dSettings.FOV* 180 / pi).round()}",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),

          )),
          const SizedBox(
            height: 12,
          ),
          Maze3dFOVSlider()
        ],
      ),
    ));
  }
}

class Maze3dChronoDurationSlider extends StatefulWidget {
  const Maze3dChronoDurationSlider({super.key});

  @override
  State<Maze3dChronoDurationSlider> createState() => _Maze3dChronoDurationSliderState();
}

class _Maze3dChronoDurationSliderState extends State<Maze3dChronoDurationSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final double _maxDuration = controller.maze3dSettings.chronoMaxTime;
    double _value = _maxDuration;
    return Obx(() => Slider.adaptive(
      value: _value,
      min: 20,
      max: 240,
      divisions: 20,
      label: _value.floor().toString(),
      semanticFormatterCallback: (double newValue) {
        return '${newValue.round()} secondes';
      },
      onChanged: controller.maze3dSettings.hasChrono ? (double value) {
        setState(() {
          _value = value.floorToDouble();
          controller.maze3dSettings.chronoMaxTime=_value;
        });
      } : null,
    ));
  }
}

class Maze3dSpeedSlider extends StatefulWidget {
  const Maze3dSpeedSlider({super.key});

  @override
  State<Maze3dSpeedSlider> createState() => _Maze3dSpeedSliderState();
}

class _Maze3dSpeedSliderState extends State<Maze3dSpeedSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final double _speed = controller.maze3dSettings.speedMovement;
    double _value = _speed;
    return Slider.adaptive(
      value: _value,
      min: 1,
      max: 10,
      divisions: 9,
      label: _value.floor().toString(),
      semanticFormatterCallback: (double newValue) {
        return '${newValue.round()}';
      },
      onChanged: (double value) {
        setState(() {
          _value = value.floorToDouble();
          controller.maze3dSettings.speedMovement=_value;
        });
      } ,
    );
  }
}
class Maze3dFOVSlider extends StatefulWidget {
  const Maze3dFOVSlider({super.key});

  @override
  State<Maze3dFOVSlider> createState() => _Maze3dFOVSliderState();
}
class _Maze3dFOVSliderState extends State<Maze3dFOVSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final double _fov = controller.maze3dSettings.FOV * 180 / pi;
    double _value = max(30,_fov.round().toDouble());
    return Slider.adaptive(
      value: _value,
      min: 30,
      max: 60,
      divisions: 3,
      label: _value.round().toString(),
      semanticFormatterCallback: (double newValue) {
        return _value.round().toString();
      },
      onChanged: (double value) {
        setState(() {
          _value = value.roundToDouble();
          controller.maze3dSettings.FOV= _value * pi / 180.0;
        });
      } ,
    );
  }
}
class Maze3dSizeSlider extends StatefulWidget {
  const Maze3dSizeSlider({super.key});

  @override
  State<Maze3dSizeSlider> createState() => _Maze3dSizeSliderState();
}

class _Maze3dSizeSliderState extends State<Maze3dSizeSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final int _nbT = controller.maze3dSettings.mazeSize;
    double _value = _nbT.toDouble();
    return Slider.adaptive(
      value: _value,
      min: 4,
      max: 7,
      divisions: 3,
      label: _value.round().toString(),
      semanticFormatterCallback: (double newValue) {
        return '${newValue.round()}';
      },
      onChanged: (double value) {
        setState(() {
          _value = value;
          controller.maze3dSettings.mazeSize=value.toInt();
        }) ;
      });
  }
}

