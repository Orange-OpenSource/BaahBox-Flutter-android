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
      ),
      body: ListView(
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
              value: controller.mazeSettings["hasChrono"],
              onChanged: (bool newValue) {
                controller.setMazeHasChrono(newValue);
              })),
          const SizedBox(
            height: 12,
          ),
          const SizedBox(
            height: 12,
          ),
          Obx(() => Text(
            "Temps maximum pour sortir : " +
                controller.mazeSettings["chronoMaxTime"]
                    .toString()+" secondes",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold,
                color:controller.mazeSettings["hasChrono"] ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.outline),

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
              value: controller.mazeSettings["hasMaxTouch"],
              onChanged: (bool newValue) {
                controller.setMazeHasMaxWallTouches(newValue);
              })),
          const SizedBox(
            height: 12,
          ),
          Obx(() => Text(
            "Nombre d'impacts maximum : " +
                controller.mazeSettings["maxTouches"]
                    .toString(),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold,
              color:controller.mazeSettings["hasMaxTouch"] ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.outline),

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
                          'Joystick :',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ]))),
          const SizedBox(
            height: 12,
          ),
          Obx(() => SwitchListTile.adaptive(
              title: Text("Direction précise"),
              value: controller.mazeSettings["isFineDirection"],
              onChanged: (bool newValue) {
                controller.setMazeFineDirection(newValue);
              }))
        ],
      ),
    );
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
    final double _maxDuration = controller.mazeSettings["chronoMaxTime"] ?? 10;
    double _value = _maxDuration;
    return Obx(() => Slider.adaptive(
      value: _value,
      min: 10,
      max: 60,
      divisions: 20,
      label: _value.floor().toString(),
      semanticFormatterCallback: (double newValue) {
        return '${newValue.round()} secondes';
      },
      onChanged: controller.mazeSettings["hasChrono"] ? (double value) {
        setState(() {
          _value = value.floorToDouble();
          controller.setMazeChronoMaxTime(_value);
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
    final int _nbT = controller.mazeSettings["maxTouches"] ?? 3;
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
      onChanged: controller.mazeSettings["hasMaxTouch"] ?(double value) {
        setState(() {
          _value = value;
          controller.setMazeWallMaxTouch(value.toInt());
        }) ;
      }: null,
    ));
  }
}

