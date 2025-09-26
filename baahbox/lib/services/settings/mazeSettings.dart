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
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:baahbox/constants/enums.dart';
import 'package:baahbox/services/settings/settingsController.dart';

class MazeSettingsPage extends GetView<SettingsController> {
  final mainColor = BBGameList.maze.baseColor.color;
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Réglages du labyrinthe", maxLines: 1),
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
            "Nombre de cases : ${controller.mazeSettings.mazeSize}",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)
          )),
          const SizedBox(
            height: 12,
          ),
          MazeSizeSlider(),
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
              title: Text("Mode chronomètré"),
              value: controller.mazeSettings.hasChrono,
              onChanged: (bool newValue) {
                controller.mazeSettings.hasChrono = newValue;
              })),
          const SizedBox(
            height: 12,
          ),
          Obx(() => Text(
            "Temps maximum pour sortir : ${controller.mazeSettings.chronoMaxTime} secondes",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold,
                color:controller.mazeSettings.hasChrono ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.outline),

          )),
          const SizedBox(
            height: 12,
          ),
          MazeChronoDurationSlider(),
          Card(
              shape: ContinuousRectangleBorder(),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Impacts des murs :',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          Obx(() => SwitchListTile.adaptive(
              title: Text("Impacts pénalisant"),
              value: controller.mazeSettings.hasMaxTouch,
              onChanged: (bool newValue) {
                controller.mazeSettings.hasMaxTouch=newValue;
              })),
          const SizedBox(
            height: 12,
          ),
          Obx(() => Text(
            "Nombre d'impacts maximum : ${controller.mazeSettings.hasMaxTouch}",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold,
              color:controller.mazeSettings.hasMaxTouch ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.outline),

          )),
          const SizedBox(
            height: 12,
          ),
          MazeWallTouchNumberSlider(),
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
                          'Déplacement :',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          Obx(() => Text(
            "Vitesse de déplacement : ${controller.mazeSettings.speedMovement}",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),

          )),
          const SizedBox(
            height: 12,
          ),
          MazeSpeedSlider(),
          const SizedBox(
            height: 12,
          ),
          Obx(() => SwitchListTile.adaptive(
              title: Text("Direction précise"),
              value: controller.mazeSettings.isFineDirection,
              onChanged: (bool newValue) {
                controller.mazeSettings.isFineDirection=newValue;
              }))
        ],
      ),
    ));
  }
}

class MazeChronoDurationSlider extends StatefulWidget {
  const MazeChronoDurationSlider({super.key});

  @override
  State<MazeChronoDurationSlider> createState() => _MazeChronoDurationSliderState();
}

class _MazeChronoDurationSliderState extends State<MazeChronoDurationSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final double _maxDuration = controller.mazeSettings.chronoMaxTime;
    double _value = _maxDuration;
    return Obx(() => Slider.adaptive(
      value: _value,
      min: 20,
      max: 120,
      divisions: 10,
      label: _value.floor().toString(),
      semanticFormatterCallback: (double newValue) {
        return '${newValue.round()} secondes';
      },
      onChanged: controller.mazeSettings.hasChrono ? (double value) {
        setState(() {
          _value = value.floorToDouble();
          controller.mazeSettings.chronoMaxTime=_value;
        });
      } : null,
    ));
  }
}

class MazeWallTouchNumberSlider extends StatefulWidget {
  const MazeWallTouchNumberSlider({super.key});

  @override
  State<MazeWallTouchNumberSlider> createState() => _MazeWallTouchNumberSliderState();
}

class _MazeWallTouchNumberSliderState extends State<MazeWallTouchNumberSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final int _nbT = controller.mazeSettings.maxTouches;
    double _value = _nbT.toDouble();
    return Obx(() => Slider.adaptive(
      value: _value,
      min: 3,
      max: 10,
      divisions: 7,
      label: _value.round().toString(),
      semanticFormatterCallback: (double newValue) {
        return '${newValue.round()}';
      },
      onChanged: controller.mazeSettings.hasMaxTouch ?(double value) {
        setState(() {
          _value = value;
          controller.mazeSettings.maxTouches = value.toInt();
        }) ;
      }: null,
    ));
  }
}

class MazeSpeedSlider extends StatefulWidget {
  const MazeSpeedSlider({super.key});

  @override
  State<MazeSpeedSlider> createState() => _MazeSpeedSliderState();
}

class _MazeSpeedSliderState extends State<MazeSpeedSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final double _speed = controller.mazeSettings.speedMovement;
    double _value = _speed;
    return Slider.adaptive(
      value: _value,
      min: 20,
      max: 80,
      divisions: 5,
      label: _value.floor().toString(),
      semanticFormatterCallback: (double newValue) {
        return '${newValue.round()}';
      },
      onChanged: (double value) {
        setState(() {
          _value = value.floorToDouble();
          controller.mazeSettings.speedMovement=_value;
        });
      } ,
    );
  }
}


class MazeSizeSlider extends StatefulWidget {
  const MazeSizeSlider({super.key});

  @override
  State<MazeSizeSlider> createState() => _MazeSizeSliderState();
}

class _MazeSizeSliderState extends State<MazeSizeSlider> {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final int _nbT = controller.mazeSettings.mazeSize;
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
          controller.mazeSettings.mazeSize=value.toInt();
        }) ;
      });
  }
}

